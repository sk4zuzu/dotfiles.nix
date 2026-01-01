{ config, pkgs, rustaceanvim, ... }:
  let
    rustaceanvim-pkgs = rustaceanvim.packages.${pkgs.stdenv.hostPlatform.system};
    rustaceanvim-vimPlugins = pkgs.vimPlugins;
  in {
    home = {
      homeDirectory = "/home/ead";
      sessionPath = ["$HOME/.local/bin"];
      stateVersion = "26.05";
      username = "ead";
    };
    services = {
      podman = {
        enable = true;
        settings.containers.engine = {
          cgroup_manager = "cgroupfs";
        };
        settings.storage.storage = {
          driver = "overlay";
          graphroot = "/stor/ead/.local/share/containers/storage";
        };
      };
    };
    programs = {
      home-manager.enable = true;
      bash = {
        enable = true;
        bashrcExtra = ''
          SSH_AGENT_PID="$(pgrep -u "$USER" ssh-agent)"
          if [[ -n "$SSH_AGENT_PID" ]]; then
              export SSH_AGENT_PID SSH_AUTH_SOCK="$HOME/.ssh/.agent"
          else
              rm -f "$HOME/.ssh/.agent"
              eval "$(ssh-agent -a "$HOME/.ssh/.agent")"
              fd -tf -E 'id_*.pub' 'id_*' "$HOME/.ssh/" -x ssh-add
          fi
        '';
        initExtra =
          let
            magenta = "\\033[38;2;255;0;255m";
            clear = "\\033[0m";
          in ''
            export TERM='xterm-256color'
            export PS1='${magenta}\w\$ ${clear}'
            export EDITOR='nvim'
            cd ~/_git/
          '';
        shellAliases = {
          b = "bash";
          g = "git";
          hrg = "history | rg";
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
      neovim = {
        enable = true;
        extraLuaConfig = ''
          vim.diagnostic.config({
            underline = false,
            virtual_lines = true,
          })
          vim.g.rustaceanvim = {
            server = {
              default_settings = {
                ['rust-analyzer'] = {
                  cargo = { features = 'all' },
                },
              },
            },
          }
          vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'bash', 'json', 'make', 'markdown', 'rust', 'toml', 'yaml' },
            callback = function() vim.treesitter.start() end,
          })
          vim.cmd [[source /etc/nixos/repti/ead/.config/nvim/init.vim]]
        '';
        plugins = with pkgs.vimPlugins; [
          nvim-dap
          (nvim-treesitter.withPlugins (plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-json
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-yaml
          ]))
          rustaceanvim-vimPlugins.rustaceanvim
        ];
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
      fd
      gnumake
      igrep
      jq
      patch procs
      ripgrep
      which
    ] ++ [
      cargo
      gcc
      lldb
      nodejs
      rust-analyzer rustc
      tree-sitter
    ] ++ [
      rustaceanvim-pkgs.codelldb
      rustaceanvim-pkgs.rustaceanvim
    ];
    home.file =
      let
        ln = config.lib.file.mkOutOfStoreSymlink;
      in {
        ".config/nvim/colors/molokai.vim".source = /etc/nixos/repti/ead/.config/nvim/colors/molokai.vim;
      };
  }
