{pkgs, ...}:

{
  home = {
    file = {
      ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
      ".config/Code/User/settings.json".source = ./settings.json;
    };

    packages = with pkgs; [
      go
      rustc
      ponyc
      ruby
      python3
      lynx
    ];
  };
}
