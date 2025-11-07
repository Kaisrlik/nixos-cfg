{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "xeri";
  home.homeDirectory = "/home/xeri";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
  ];

  # home.file.".config/i3".source = "/home/xeri/configs/i3.configs/";
  home.file.".gitignore".source = "${inputs.dot-files}/git.configs/gitignore";
  home.file.".gitconfig".source = "${inputs.dot-files}/git.configs/gitconfig";
  home.file.".zshrc".source = "${inputs.dot-files}/omzsh.configs/zshrc";
  home.file.".config/foot/foot.ini".source = "${inputs.dot-files}/foot.congigs/foot.ini";


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
