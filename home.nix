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
      ruby
      python3
      lynx
    ];
  };
}
