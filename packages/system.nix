{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    nvidia-offload
    # dev
    git
    vim
    zsh
    alacritty
    gcc
    gnumake

    # utils
    wget
    curl
    xorg.xkill
  ];
  environment.shells = with pkgs; [zsh];
}
