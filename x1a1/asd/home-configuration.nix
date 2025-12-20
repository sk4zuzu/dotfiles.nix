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
