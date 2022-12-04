{ config, ... }:

{
  imports = [
    ./fs.nix
    ./boot.nix
    ./hardware.nix
    ./network.nix
  ];
}
