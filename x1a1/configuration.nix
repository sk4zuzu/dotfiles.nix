{ config, pkgs, lib, ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.systemPackages = with pkgs; [
    bash bat
    fd file
    git gnumake
    htop
    igrep iproute2
    jq
    mc
    neovim nftables
    ripgrep
    tcpdump tmux
    unzip
    zip
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  imports = [ /etc/nixos/hardware-configuration.nix ] ++ (lib.pipe /etc/nixos/configuration.nix.d [
    builtins.readDir
    (lib.filterAttrs (name: _: lib.hasSuffix ".nix" name))
    (lib.mapAttrsToList (name: _: /etc/nixos/configuration.nix.d + "/${name}"))
  ]);

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  swapDevices = [];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.kernelParams       = [ "net.ifnames=0" "biosdevname=0" ];
  boot.growPartition      = true;

  networking.hostName        = "nixos";
  networking.useDHCP         = false;
  networking.useNetworkd     = true;
  networking.firewall.enable = false;

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    doas = {
      enable = true;
      extraRules = [ { groups = [ "wheel" ]; noPass = true; keepEnv = false; setEnv = [ "LOCALE_ARCHIVE" ]; } ];
    };
    sudo.wheelNeedsPassword = false;
  };

  users.users.asd = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
    password     = "asd";
    uid          = 1000;
  };

  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  services.openssh.enable = true;

  services.cloud-init.enable         = true;
  services.cloud-init.network.enable = true;
  services.cloud-init.settings       = { datasource_list = [ "NoCloud" ]; };

  system.stateVersion = "25.11";
}
