{ config, pkgs, lib, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat bc bridge-utils
    cabextract cdrkit cpufrequtils cryptsetup
    dmidecode dnsutils dos2unix
    edid-decode efibootmgr ethtool exfat
    fd feh file
    git gnumake gnuplot gnupg gptfdisk
    htop hsetroot
    igrep iptables iotop
    jq
    lm_sensors lsof
    mc mkpasswd multipath-tools
    neovim nftables nmap ntfs3g ntp
    openssl openvpn
    p7zip patch pciutils procs pv
    radeontop ripgrep rsync
    sdparm syslinux
    tcpdump tmux
    unrar unshield unzip usbutils
    vim
    wireguard-tools
    xclip
    zip
  ] ++ [
    mesa-demos
    xorg.xdpyinfo xorg.xev xorg.xgamma xorg.xhost xorg.xkill xorg.xmodmap
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      charis-sil
      noto-fonts
      noto-fonts-color-emoji
    ];
  };

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI";
      };
      grub = {
        enable = true;
        enableCryptodisk = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    kernelModules = [ "ip6table_filter" "nbd" "vhost_net" ]; #++ [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    blacklistedKernelModules = [];
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "net.ipv6.conf.wlp6s0.disable_ipv6" = true;
    };
    extraModprobeConfig = ''
      options kvm-amd nested=1
    '';
    initrd = {
      luks.devices = {
        luks1 = { device = "/dev/disk/by-uuid/a23b3a97-9b0e-4054-9a2c-1ceeb893c74b"; keyFile = "luks"; allowDiscards = true; preLVM = true; };
      };
      secrets = {
        "luks" = /etc/secrets/initrd/luks;
      };
    };
  };

  fileSystems = {
    "/"     = { options = [ "defaults" "discard" "noatime" "nodiratime" "nobarrier" ]; };
    "/home" = { options = [ "defaults" "discard" "noatime" "nodiratime" "nobarrier" ]; };
    "/stor" = { options = [ "defaults" "discard" "noatime" "nodiratime" ]; };
  };

  powerManagement.cpuFreqGovernor = "conservative";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    enableIPv6 = true;
    hostName = "repti";
    extraHosts = ''
      127.0.0.1 lh
    '';
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    wireless = {
      enable = true;
      interfaces = [ "wlp6s0" ];
    };
    nat = {
      enable = true;
      externalInterface = "wlp6s0";
    };
    firewall = {
      enable = true;
      checkReversePath = false;
      trustedInterfaces = [ "br0" ];
      allowedTCPPorts = [ 80 4430 5000 6112 8000 ] ++ [ 5005 6443 ];
      allowedUDPPorts = [ 5029 5353 6112 27960 ];
    };
  };

  systemd.network = {
    networks."wlp6s0" = {
      matchConfig.Name = "wlp6s0";
      networkConfig.DHCP = "yes";
    };
    netdevs."br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };
    networks."br0" = {
      matchConfig.Name = "br0";
      networkConfig = {
        Address = "10.2.11.1/24";
        IPv4Forwarding = "yes";
        IPv6Forwarding = "yes";
        IPMasquerade = "no";
        ConfigureWithoutCarrier = "yes";
      };
      linkConfig = { ActivationPolicy = "always-up"; };
    };
  };

  systemd.services = {
    "systemd-networkd-wait-online".serviceConfig.ExecStart = [
      "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "pl";

  time = {
    timeZone = "Europe/Warsaw";
    hardwareClockInLocalTime = false;
  };

  security = {
    doas = {
      enable = true;
      extraRules = [ { groups = [ "wheel" ]; noPass = true; keepEnv = false; setEnv = [ "LOCALE_ARCHIVE" ]; } ];
    };
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    dconf.enable = true;
    light.enable = true;
    slock.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        log-driver = "local";
        features = { containerd-snapshotter = true; };
        ip6tables = false;
      };
    };
    #podman = {
    #  enable = true;
    #  dockerCompat = true;
    #};
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  services = {
    chrony.enable = true;
    displayManager = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "sk4zuzu";
      };
      defaultSession = "none+xmonad";
    };
    fwupd.enable = true;
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
    ntp.enable = false;
    openssh = {
      enable = true;
      ports = [ 2222 ];
    };
    picom = {
      enable = true;
      backend = "glx";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
    resolved = {
      enable = true;
      dnssec = "false";
      llmnr = "false";
      extraConfig = "MulticastDNS=no";
    };
    xserver = {
      enable = true;
      autorun = true;
      xkb.layout = "pl";
      desktopManager = {
        xterm.enable = false;
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      videoDrivers = [ "amdgpu" ];
    };
  };

  users.users = {
    asd = {
      isNormalUser = true;
      uid = 1000;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
    ead = {
      isNormalUser = true;
      uid = 8686;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
    sk4zuzu = {
      isNormalUser = true;
      uid = 6969;
      group = "wheel";
      extraGroups = [ "audio" "video" "docker" "libvirtd" "kvm" ];
    };
  };

  system.stateVersion = "26.05";
}
