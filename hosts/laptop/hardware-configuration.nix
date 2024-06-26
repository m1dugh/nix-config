# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "usbhid" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "ec_sys" ];
  boot.extraModprobeConfig = ''
    options ec_sys write_support=1
    options nvidia NVreg_DynamicPowerManagement=0x02
  '';
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "acpi_rev_override=1"
    "acpi_osi=Linux"
    "nouveau.modeset=0"
    "pcie_aspm=off"
    "drm.vblankoffdelay=1"
    "scsi_mod.use_blk_mq=1"
    "nouveau.runpm=0"
    "mem_sleep_default=deep"
  ];

  boot.loader.timeout = 0;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b8a3a5df-a55e-4ebb-b346-556d8e0e921f";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5022-122C";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/788a4db7-36a4-40cb-9584-e7f63e4df148";
    fsType = "ext4";
  };


  swapDevices = [
    { device = "/dev/disk/by-uuid/58837a9b-9792-4308-9d70-300d77e5fde9"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp60s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp61s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
