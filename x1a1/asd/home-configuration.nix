{ config, pkgs, ... }: {
  home = {
    homeDirectory = "/home/asd";
    stateVersion = "25.11";
    username = "asd";
  };
  services = {
    ssh-agent.enable = true;
  };
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      initExtra = ''
        export TERM='xterm-256color'
        export PS1='\w\$ '
        export EDITOR='nvim'
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
        addKeysToAgent = "yes";
        forwardAgent = true;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
  };
  home.packages = with pkgs; [
    neovim
  ];
  home.file =
    let
      ln = config.lib.file.mkOutOfStoreSymlink;
    in {
      ".config/nvim".source = ln "/etc/nixos/x1a1/asd/.config/nvim";
    };
}
