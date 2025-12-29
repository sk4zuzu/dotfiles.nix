{ config, pkgs, ... }: {
  home = {
    homeDirectory = "/home/sk4zuzu";
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "26.05";
    username = "sk4zuzu";
  };
  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
          WINIT_HIDPI_FACTOR = "1.0";
        };
        colors.primary = {
          background = "0x000000";
          foreground = "0x99e199";
        };
        colors.cursor = {
          text = "0x000000";
          cursor = "0xff0000";
        };
        font.bold = {
          family = "MonacoLigaturized";
          style = "Bold";
        };
        font.italic = {
          family = "MonacoLigaturized";
          style = "Italic";
        };
        font.normal = {
          family = "MonacoLigaturized";
          style = "Regular";
        };
        font.size = 10;
      };
    };
    bash = {
      enable = true;
      initExtra = ''
        export TERM='xterm-256color'
        export PS1='\u:\w\$ '
        export EDITOR='nvim'
        cd /etc/nixos/
      '';
      shellAliases = {
        g = "git";
        hrep = "history | grep";
        m = "make";
        root = "doas -s";
        vim = "nvim";
      };
    };
    git = {
      enable = true;
      settings.alias = {
        a = "add";
        c = ''! f(){ [ -n "$*" ] && git commit -m "$*" || git commit; }; f'';
        ca = "commit --amend";
        co = "checkout";
        d = "diff";
        f = "fetch";
        l = "log";
        s = "show";
        ss = "status";
        t = "tag";
      };
      settings.safe.directory = ["/etc/nixos"];
      settings.user = {
        email = "sk4zuzu@gmail.com";
        name = "Michal Opala";
      };
    };
    mc = {
      enable = true;
      settings.Layout = {
        command_prompt = "true";
        free_space = "false";
        keybar_visible = "false";
        menubar_visible = "false";
        message_visible = "false";
        xterm_title = "false";
      };
      settings.Midnight-Commander = {
        skin = "modarin256";
        use_internal_edit = "false";
      };
      settings.Panels = {
        navigate_with_arrows = "true";
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraOptionOverrides = {
        HostKeyAlgorithms = "+ssh-rsa";
        PubkeyAcceptedKeyTypes = "+ssh-rsa";
      };
      matchBlocks."*" = {
        forwardAgent = true;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
  };
  home.packages = with pkgs; [
    bat
    curl
    fd ffmpeg
    gnumake
    htop
    igrep
    jq
    neovim
    patch
    ripgrep
    wget which
    yt-dlp
  ] ++ [
    chromium
    dmenu dunst
    hsetroot
    libnotify
    pavucontrol procps
    redshift
    slock
  ] ++ [
    gimp
    maim mpv mupdf
    remmina
    transmission_4-gtk
  ] ++ [
    dosbox-staging
    mame
    (wine.override { wineRelease = "staging"; }) winetricks
  ];
  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/mpv/scripts/eww.lua".source = ln "/etc/nixos/repti/sk4zuzu/.config/mpv/scripts/eww.lua";
      ".config/nvim".source = ln "/etc/nixos/repti/sk4zuzu/.config/nvim";
      ".config/redshift.conf".source = ln "/etc/nixos/repti/sk4zuzu/.config/redshift.conf";
      ".local/bin/acpi.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/acpi.sh";
      ".local/bin/asd".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/asd";
      ".local/bin/ead".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/ead";
      ".local/bin/xrandr.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/xrandr.sh";
      ".local/share/fonts".source = ln "/etc/nixos/repti/sk4zuzu/.local/share/fonts";
      ".xmonad/xmonad.hs".source = ln "/etc/nixos/repti/sk4zuzu/.xmonad/xmonad.hs";
    };
}
