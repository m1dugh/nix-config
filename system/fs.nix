{ config, ... }:

{

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/788a4db7-36a4-40cb-9584-e7f63e4df148";
    fsType = "ext4";
  };
  fileSystems."/home/midugh/Documents" = {
    device = "/dev/disk/by-uuid/761dc816-7bf0-4436-9692-f30db0ac35c3";
    fsType = "ext4";
  };
}
