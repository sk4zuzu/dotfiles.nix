{ config, pkgs, ... }: {
  home = {
    homeDirectory = "/home/asd";
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "26.05";
    username = "asd";
  };
  programs = {
    home-manager.enable = true;
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
      initExtra =
        let
          yellow = "\\033[38;2;255;255;0m";
          clear = "\\033[0m";
        in ''
          export TERM='xterm-256color'
          export PS1='${yellow}\w\$ ${clear}'
          export EDITOR='nvim'
          cd ~/_git/
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
      settings.user = {
        name = "Michal Opala";
        email = "sk4zuzu@gmail.com";
      };
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
  home.packages =
    let
      python3-with-pkgs = pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
        ansible-core
        pip python
        virtualenv
        yamllint
      ]);
      ruby-with-pkgs = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
        rspec rubocop
      ]);
    in with pkgs; [
      ansible-lint
      bash bat binutils
      cdrkit cloud-utils curl
      dpkg
      fd
      gcc git gnumake go graphviz-nox
      hatch
      igrep
      jq
      libarchive libosinfo libxml2 libxslt
      mc
      neovim
      pandoc patch python3-with-pkgs
      ripgrep rpm ruby-with-pkgs
      uv
      wget which
    ];
  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/nvim".source = ln "/etc/nixos/repti/asd/.config/nvim";
    };
}
