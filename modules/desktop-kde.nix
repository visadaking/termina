{ pkgs, ... }:
{
  services.xserver.enable = true; # required by sddm/plasma plumbing on many setups
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.discover
  ];
}
