{ pkgs, ... }:
{
  services.xserver.enable = true; # wish that steam was native wayland so i can nuke xserver off my pc and this planet :)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # xwayland (the better x11)
  programs.xwayland.enable = true;

  # exclude KDE/PIM apps you don't want (attr names may vary by nixpkgs rev)
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadiconsole
    ark
    elisa
    kmail
    kontact
    merkuro
    okular
  ];

  # ewterm ugly terminal
  services.xserver.excludePackages = [ pkgs.xterm ];

  # kde connect
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.kzones
    kdePackages.discover
    gparted
  ];
}
