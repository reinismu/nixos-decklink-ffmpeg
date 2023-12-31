# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/hardware/decklink.nix")
    ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "ibt=off" # https://forum.blackmagicdesign.com/viewtopic.php?f=12&t=170026
    # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
    #   vulnerabilities for a slight performance boost. Don't copy this blindly!
    #   And especially not for mission critical or server/headless builds
    #   exposed to the world.
    "mitigations=off"
  ];

  # Refuse ICMP echo requests on on desktops/laptops; nobody has any business
  # pinging them.
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8c82edcb-1765-442a-acb2-ecd01a6f6d07";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D078-986E";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b49a0cc4-7925-452b-829f-998088fa6b3a"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
}
