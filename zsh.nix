{}:
{
  config = {
    enable = true;

    interactiveShellInit = ''
    function chef-env() {
      out="$(chef shell-init zsh)"
      eval $out
    }

    export EDITOR=nvim
    export GOPATH="$HOME/go"
    export PATH="$PATH:$HOME/.rvm/bin:$GOPATH/bin"
    '';

    enableCompletion = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "ruby"
        "rbenv"
        "dotenv"
      ];
      theme = "bira";
    };

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  plugins = [];
}
