{ pkgs, ... }:
let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
  };
  androidSdk = androidComposition.androidsdk;
in
{
  environment = {
    systemPackages = with pkgs; [
      androidSdk
      android-studio
    ];

    variables = let
      sdkPath = "${androidSdk}/libexec/android-sdk";
    in {
      ANDROID_HOME = sdkPath;
      ANDROID_SDK_ROOT = sdkPath;
      ANDROID_NDK_ROOT = "${sdkPath}/ndk-bundle";
      ANDROID_USER_HOME = "\${HOME}/.android";
    };
  };
}
