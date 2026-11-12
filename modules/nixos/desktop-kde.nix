{ pkgs, ... }:
{
  services.xserver.enable = true; # required by sddm/plasma plumbing on many setups
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # XWayland (X11 app compatibility on Wayland)
  programs.xwayland.enable = true;

  # exclude KDE/PIM apps you don't want (attr names may vary by nixpkgs rev)
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadiconsole
    elisa
    kmail
    kontact
    merkuro
    okular
  ];

  # exclude xterm (pulled in by X11 defaults)
  services.xserver.excludePackages = [ pkgs.xterm ];

  # kde connect
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.discover
    gparted
    (callPackage ../../pkgs/plasma-smart-video-wallpaper-reborn.nix { })
  ];
}
