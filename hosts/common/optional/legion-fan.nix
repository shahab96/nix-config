{
  pkgs,
  config,
  ...
}:
let
  legion-fan = pkgs.writeShellApplication {
    name = "legion-fan";
    runtimeInputs = with pkgs; [ coreutils gawk ];
    text = ''
      # legion-fan: fan/profile control for Lenovo Legion via legion_laptop sysfs.
      #
      # Curves are 10-point (temp, pwm) tables applied to both fans (pwm1=CPU,
      # pwm2=GPU). pwm3 carries the same temperature column. Temps in sysfs are
      # millidegrees C; PWM is 0-255.

      set -euo pipefail

      need_root() {
        if [ "$(id -u)" -ne 0 ]; then
          echo "legion-fan: must run as root (use sudo)" >&2
          exit 1
        fi
      }

      find_hwmon() {
        # Retry briefly in case the module isn't fully populated yet
        # (boot oneshot races with systemd-modules-load).
        local tries=0
        while [ $tries -lt 50 ]; do
          for h in /sys/class/hwmon/hwmon*; do
            [ -r "$h/name" ] || continue
            if [ "$(cat "$h/name")" = "legion_hwmon" ]; then
              echo "$h"
              return 0
            fi
          done
          tries=$((tries + 1))
          sleep 0.1
        done
        echo "legion-fan: legion_hwmon not found - is legion_laptop loaded?" >&2
        exit 1
      }

      HWMON=""

      # Curve definitions: temp_c:pwm pairs, 10 points each.
      # Both fans (pwm1, pwm2) get the same curve. pwm3 mirrors the temp column.

      curve_cool() {
        echo "0:0 35:120 42:165 48:195 55:220 62:240 68:255 75:255 85:255 95:255"
      }

      curve_balanced() {
        echo "0:0 40:100 48:140 55:175 62:205 70:230 77:250 84:255 90:255 97:255"
      }

      curve_quiet() {
        echo "0:0 50:60 58:90 65:120 72:150 78:175 84:200 89:220 94:240 100:255"
      }

      apply_curve() {
        local name="$1"
        local points hyst minifc
        case "$name" in
          cool)        points=$(curve_cool);     hyst=2; minifc=0 ;;
          balanced)    points=$(curve_balanced); hyst=2; minifc=0 ;;
          quiet)       points=$(curve_quiet);    hyst=3; minifc=0 ;;
          silent-idle) points=$(curve_quiet);    hyst=3; minifc=1 ;;
          *) echo "legion-fan: unknown curve '$name' (cool|balanced|quiet|silent-idle)" >&2; exit 2 ;;
        esac

        # Ensure auto mode is active so the curve actually drives the fan.
        echo 2 > "$HWMON/pwm1_mode"

        local i=1
        for pair in $points; do
          local t=''${pair%%:*}
          local p=''${pair##*:}
          local tm=$(( t * 1000 ))
          local hm=$(( hyst * 1000 ))

          echo "$p"  > "$HWMON/pwm1_auto_point''${i}_pwm"
          echo "$tm" > "$HWMON/pwm1_auto_point''${i}_temp"
          echo "$hm" > "$HWMON/pwm1_auto_point''${i}_temp_hyst"

          echo "$p"  > "$HWMON/pwm2_auto_point''${i}_pwm"
          echo "$tm" > "$HWMON/pwm2_auto_point''${i}_temp"
          echo "$hm" > "$HWMON/pwm2_auto_point''${i}_temp_hyst"

          echo "$tm" > "$HWMON/pwm3_auto_point''${i}_temp"
          echo "$hm" > "$HWMON/pwm3_auto_point''${i}_temp_hyst"

          i=$((i + 1))
        done

        echo "$minifc" > "$HWMON/minifancurve" 2>/dev/null || true
        echo "legion-fan: applied curve '$name' (hysteresis ''${hyst}C, minifancurve=$minifc)"
      }

      show_curve() {
        printf '%-6s %-10s %-6s %-10s %-6s %-10s\n' "PT" "TEMP(C)" "PWM1" "PWM2" "HYST" "PWM3_T"
        for i in 1 2 3 4 5 6 7 8 9 10; do
          local t p1 p2 h t3
          t=$(awk '{print int($1/1000)}'  "$HWMON/pwm1_auto_point''${i}_temp")
          p1=$(cat "$HWMON/pwm1_auto_point''${i}_pwm")
          p2=$(cat "$HWMON/pwm2_auto_point''${i}_pwm")
          h=$(awk '{print int($1/1000)}'  "$HWMON/pwm1_auto_point''${i}_temp_hyst")
          t3=$(awk '{print int($1/1000)}' "$HWMON/pwm3_auto_point''${i}_temp")
          printf '%-6s %-10s %-6s %-10s %-6s %-10s\n' "$i" "$t" "$p1" "$p2" "$h" "$t3"
        done
      }

      do_status() {
        local profile minifc mode
        profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "?")
        mode=$(cat "$HWMON/pwm1_mode" 2>/dev/null || echo "?")
        minifc=$(cat "$HWMON/minifancurve" 2>/dev/null || echo "?")

        echo "platform_profile : $profile"
        echo "pwm1_mode        : $mode  (0=off/manual, 2=auto)"
        echo "minifancurve     : $minifc"
        echo

        for f in 1 2; do
          local lbl rpm tgt mx
          lbl=$(cat "$HWMON/fan''${f}_label" 2>/dev/null || echo "fan$f")
          rpm=$(cat "$HWMON/fan''${f}_input")
          tgt=$(cat "$HWMON/fan''${f}_target" 2>/dev/null || echo "-")
          mx=$(cat  "$HWMON/fan''${f}_max"    2>/dev/null || echo "-")
          printf '%-12s rpm=%-6s target=%-6s max=%s\n' "$lbl" "$rpm" "$tgt" "$mx"
        done
        echo

        for s in 1 2 3; do
          local lbl tc
          lbl=$(cat "$HWMON/temp''${s}_label" 2>/dev/null || echo "temp$s")
          tc=$(awk '{print int($1/1000)}' "$HWMON/temp''${s}_input")
          printf '%-12s %sC\n' "$lbl" "$tc"
        done
        echo
        echo "current curve:"
        show_curve
      }

      do_profile() {
        local p="$1"
        case "$p" in
          quiet|balanced|balanced-performance|performance) ;;
          *) echo "legion-fan: unknown profile '$p'" >&2; exit 2 ;;
        esac
        echo "$p" > /sys/firmware/acpi/platform_profile
        echo "legion-fan: platform_profile=$p"
      }

      do_manual() {
        local pwm="$1"
        if ! [[ "$pwm" =~ ^[0-9]+$ ]] || [ "$pwm" -gt 255 ]; then
          echo "legion-fan: manual pwm must be 0-255" >&2
          exit 2
        fi
        # Flat curve at the requested PWM, low temp thresholds so it always applies.
        echo 2 > "$HWMON/pwm1_mode"
        for i in 1 2 3 4 5 6 7 8 9 10; do
          local tm=$(( (i - 1) * 10 * 1000 ))
          echo "$pwm" > "$HWMON/pwm1_auto_point''${i}_pwm"
          echo "$tm"  > "$HWMON/pwm1_auto_point''${i}_temp"
          echo "$pwm" > "$HWMON/pwm2_auto_point''${i}_pwm"
          echo "$tm"  > "$HWMON/pwm2_auto_point''${i}_temp"
          echo "$tm"  > "$HWMON/pwm3_auto_point''${i}_temp"
        done
        echo "legion-fan: manual flat pwm=$pwm applied to both fans"
      }

      do_auto() {
        echo 2 > "$HWMON/pwm1_mode"
        echo "legion-fan: pwm1_mode=2 (auto)"
      }

      do_minifancurve() {
        local v="$1"
        case "$v" in
          on|1)  echo 1 > "$HWMON/minifancurve"; echo "legion-fan: minifancurve=on" ;;
          off|0) echo 0 > "$HWMON/minifancurve"; echo "legion-fan: minifancurve=off" ;;
          *) echo "legion-fan: minifancurve must be on|off" >&2; exit 2 ;;
        esac
      }

      usage() {
        cat <<EOF
      legion-fan - Lenovo Legion fan/profile control (requires sudo)

      USAGE:
        legion-fan status
        legion-fan profile <quiet|balanced|balanced-performance|performance>
        legion-fan auto
        legion-fan manual <0-255>
        legion-fan curve <cool|balanced|quiet|silent-idle>
        legion-fan curve show
        legion-fan minifancurve <on|off>

      CURVES:
        cool         aggressive low-end, full speed by 68C
        balanced     default; firm low-end ramp (applied at boot)
        quiet        silence-priority; expect 55-65C idle
        silent-idle  quiet curve + minifancurve=1 (fans fully off when allowed)
      EOF
      }

      # Reads are also gated behind sudo per design.
      need_root
      HWMON=$(find_hwmon)

      cmd=''${1-}
      case "$cmd" in
        status)        do_status ;;
        profile)       shift; do_profile "''${1-}" ;;
        auto)          do_auto ;;
        manual)        shift; do_manual "''${1-}" ;;
        minifancurve)  shift; do_minifancurve "''${1-}" ;;
        curve)
          shift
          sub=''${1-}
          case "$sub" in
            show) show_curve ;;
            "")   echo "legion-fan: curve requires a preset name" >&2; exit 2 ;;
            *)    apply_curve "$sub" ;;
          esac
          ;;
        ""|-h|--help|help) usage ;;
        *) echo "legion-fan: unknown command '$cmd'" >&2; usage >&2; exit 2 ;;
      esac
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    legion-fan
    lm_sensors
    s-tui
  ];

  security.sudo.extraRules = [
    {
      users = [ config.hostSpec.username ];
      commands = [
        {
          command = "${legion-fan}/bin/legion-fan";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];

  systemd.services.legion-fan-default = {
    description = "Apply default Legion fan curve (balanced)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${legion-fan}/bin/legion-fan curve balanced";
    };
  };
}
