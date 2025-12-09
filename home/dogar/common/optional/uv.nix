{
  ...
}: {
  programs.uv = {
    enable = true;
    settings = {
      pip.index-url = "https://pip.dogar.dev";
    };
  };
}
