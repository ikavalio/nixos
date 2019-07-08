{pkgs, ...}:

{
  home = {
    file = {
      ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
    };

    packages = with pkgs; [
      go
      rustc
      ponyc
      ruby
      python3
    ];
  };
}
