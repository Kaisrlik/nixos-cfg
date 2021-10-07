{config, pkgs, ...}:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.xeri = {
    home.enableNixpkgsReleaseCheck = false;

    # xdg.configFile."i3blocks/config".source = "/home/xeri/configs/i3.configs/i3blocks.conf";
    home.file.".config/i3".source = "/home/xeri/configs/i3.configs/";
    home.file.".gitignore".source = "/home/xeri/configs/git.configs/gitignore";
    home.file.".gitconfig".source = "/home/xeri/configs/git.configs/gitconfig";
    home.file.".zshrc".source = "/home/xeri/configs/omzsh.configs/zshrc";
    home.file.".oh-my-zsh/themes/xeri.zsh-theme".source = "/home/xeri/configs/omzsh.configs/xeri.zsh-theme";

  };
}
