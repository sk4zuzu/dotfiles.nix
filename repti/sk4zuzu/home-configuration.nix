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
      bashrcExtra = ''
        if SSH_AGENT_PID=$(pgrep -u "$USER" ssh-agent); then
            export SSH_AGENT_PID SSH_AUTH_SOCK="$HOME/.ssh/.agent"
        else
            rm -f "$HOME/.ssh/.agent"
            eval $(ssh-agent -a "$HOME/.ssh/.agent")
            fd -tf -E 'id_*.pub' 'id_*' "$HOME/.ssh/" -x ssh-add
        fi
      '';
      initExtra = ''
        export TERM='xterm-256color'
        export PS1='\u:\w\$ '
        export EDITOR='nvim'
        cd /etc/nixos/
      '';
      shellAliases = {
        g = "git";
        hrep = "history | grep";
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
      settings.user = {
        name = "Michal Opala";
        email = "sk4zuzu@gmail.com";
      };
      settings.safe.directory = ["/etc/nixos"];
    };
    mc = {
      enable = true;
      settings.Layout = {
        message_visible = "false";
        keybar_visible = "false";
        xterm_title = "false";
        command_prompt = "true";
        menubar_visible = "false";
        free_space = "false";
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
    acpitool
    bash bat
    chromium curl
    dmenu dosbox-staging dunst
    fd
    git gnumake
    htop
    igrep
    jq
    libnotify
    mame mc mpv
    neovim
    patch pavucontrol
    redshift ripgrep ruffle
    slock
    wget which
  ];
  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/mpv/scripts/junk.lua".source = ln "/etc/nixos/repti/sk4zuzu/.config/mpv/scripts/junk.lua";
      ".config/nvim".source = ln "/etc/nixos/repti/sk4zuzu/.config/nvim";
      ".config/redshift.conf".source = ln "/etc/nixos/repti/sk4zuzu/.config/redshift.conf";
      ".local/bin/asd".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/asd";
      ".local/bin/acpi.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/acpi.sh";
      ".local/bin/qed".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/qed";
      ".local/bin/slock.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/slock.sh";
      ".local/bin/xrandr.sh".source = ln "/etc/nixos/repti/sk4zuzu/.local/bin/xrandr.sh";
      ".local/share/fonts".source = ln "/etc/nixos/repti/sk4zuzu/.local/share/fonts";
      ".xmonad/xmonad.hs".source = ln "/etc/nixos/repti/sk4zuzu/.xmonad/xmonad.hs";
    };
}
