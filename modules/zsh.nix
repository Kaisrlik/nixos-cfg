{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
  };

  # Prevent the new user dialog in zsh
  system.userActivationScripts.zshrc = "touch .zshrc";
}
