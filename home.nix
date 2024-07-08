{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "david";
  home.homeDirectory = "/Users/david";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    alejandra
    bat
    erdtree
    fd
    fzf
    htop
    just
    lazygit
    lsd
    ripgrep
    sd
    uv
    zoxide
    zsh

    fish
    fishPlugins.autopair
    fishPlugins.bass
    fishPlugins.tide

    # quickemu dependencies
    bash
    cdrtools
    # coreutils
    jq
    # python3
    qemu
    samba
    socat
    swtpm
    # usbutils  # not available on aarch64.darwin
    zsync

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.configFile = {
    "skhd/skhdrc".source = ./dots/skhdrc;
    "wezterm/wezterm.lua".source = ./dots/wezterm.lua;
    "yabai/yabairc".source = ./dots/yabairc;
    "zsh/catppuccin-syntax".source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zsh-syntax-highlighting";
      rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
      hash = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/david/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    XDG_CACHE_HOME = "/Users/david/.config/cache";
    XDG_CONFIG_HOME = "/Users/david/.config";
    XDG_STATE_HOME = "/Users/david/.local/state";
    EDITOR = "~/nvim-macos-arm64/bin/nvim";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    LEDGER_FILE = "~/finance/2024.journal";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat = {
    enable = true;
    themes = {
      "catppuccin" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          # To get the commit rev and hash, run:
          # nix run "nixpkgs#nix-prefetch-git" -- https://github.com/catppuccin/bat
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          hash = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Latte.tmTheme";
      };
    };
    config = {
      theme = "Catppuccin Latte";
    };
  };

  programs.fish = {
    enable = true;
    loginShellInit = lib.mkIf pkgs.stdenv.isDarwin ''

      # Nix
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          # following is single user
          # source '/nix/var/nix/profiles/default/etc/profile.d/nix.fish'
      end
      # End Nix

      ################### Nix
      # Essential workaround for clobbered `$PATH` with nix-darwin.
      # Without this, both Nix and Homebrew paths are forced to the end of $PATH.
      # <https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1345383219>
      # <https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1030877541>
      #
      # A previous version of this snippet also included:
      #   - /run/wrappers/bin
      #   - /etc/profiles/per-user/$USER/bin # mwb needed if useGlobalPkgs used.
      #
      if test (uname) = Darwin
          fish_add_path --prepend --global \
            "${config.xdg.stateHome}/nix/profile/bin" \
            /etc/profiles/per-user/$USER/bin \
            /run/current-system/sw/bin \
            /nix/var/nix/profiles/default/bin
      end
    '';
    interactiveShellInit = ''
      set fish_greeting

      fish_vi_key_bindings

      # Location for nvm directory, since bass assumes ~/.nvm
      set -gx NVM_DIR ~/.config/nvm
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "catppuccin_fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
          hash = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
        };
      }
      {
        name = "fish-nvm";
        src = pkgs.fetchFromGitHub {
          owner = "fabioantunes";
          repo = "fish-nvm";
          rev = "57ddb124cc0b6ae7e2825855dd34f33b8492a35b";
          sha256 = "00gbvzh4l928rbnyjaqi8fc6dcpr0q4m6rd265gxfy4aqph6j7f0";
          # hash = "sha256-wB1p4MWKeNdfMaJlUwkG+bJmmEMRK+ntykgkSuDf6wE=";
        };
      }
    ];
    shellAbbrs = {
      "cat" = "bat";
      "cd" = "z";
      "cdi" = "zi";
      "du" = "dust";
      "ga" = {
        position = "command";
        expansion = "git add";
      };
      "gita" = "git add";
      "gch" = "git checkout";
      "gitcm" = {
        position = "command";
        setCursor = true;
        expansion = "git commit -m \"%\"";
      };
      "gcm" = {
        position = "command";
        setCursor = true;
        expansion = "git commit -m \"%\"";
      };
      "gl" = "git log";
      "gp" = "git pull";
      "gr" = "git rebase";
      "gits" = "git status";
      "gs" = "git status";
      "gss" = "git status --short";
      "gsw" = "git switch";

      # Pipe to grep and place cursor at %.
      "G" = {
        position = "anywhere";
        setCursor = true;
        expansion = "| grep '%'";
      };

      "hla" = "hledger add";
      "ht" = "hledger -f $HOME/notes/time_ledger.timedot bal";

      "pn" = "pnpm";

      "uvv" = "uv venv venv";
      "sv" = "source venv/bin/activate.fish";
    };
    shellAliases = {
      "cdc" = "cd ~/repos/code_projects/";
      "cdd" = "cd ~/repos/dnr-hugo/";
      "cde" = "cd ~/.config/doom";
      "cdf" = "cd ~/.config/fish";
      "cdn" = "cd ~/notes/";
      "cdnv" = "cd ~/.config/nvim/";
      "cdq" = "cd ~/repos/qmk_firmware/";
      "cdw" = "cd ~/.config/wezterm/";

      "el" = "erd -H -L 1";
      "ela" = "erd -H -L 1 -.";

      "ls" = "lsd";
      "lsa" = "lsd -a";
      "ll" = "lsd -l";
      "lla" = "lsd -la";
      # "lt" = "ls --tree";
      "l." = "lsd -d .* --color=auto";

      "nvim" = "~/nvim-macos-arm64/bin/nvim";
      "nv" = "~/nvim-macos-arm64/bin/nvim";

      "nvf" = "nv ~/.config/fish/config.fish";
      "nvfa" = "nv ~/.config/fish/alias.fish";
      "nvh" = "nv ~/.config/home-manager/home.nix";
      "nvnv" = "nv ~/.config/nvim/init.lua";
      "nvskhd" = "nv ~/.config/home-manager/dots/skhdrc";
      "nvw" = "nv ~/.config/home-manager/dots/wezterm.lua";
      "nvy" = "nv ~/.config/home-manager/dots/yabairc";
      "nvz" = "nv ~/.config/zsh/.zshrc";
      "nvza" = "nv ~/.config/zsh/aliases";

      "sshnas" = "ssh rambo@192.168.50.237";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    colors = {
      # Catppuccin-Latte
      bg = "#eff1f5";
      "bg+" = "#ccd0da";
      spinner = "#dc8a78";
      hl = "#d20f39";
      fg = "#4c4f69";
      header = "#d20f39";
      info = "#8839ef";
      pointer = "#dc8a78";
      marker = "#dc8a78";
      "fg+" = "#4c4f69";
      "prompt" = "#8839ef";
      "hl+" = "#d20f39";
    };
  };

  programs.git = {
    enable = true;
    userEmail = "davidrambo@mailfence.com";
    userName = "David Rambo";
    aliases = {
      ss = "status --short";
    };
    extraConfig = {
      pull.rebase = "false";
      credential.helper = "osxkeychain";
      init.defaultBranch = "main";
      github.user = "DavidRambo";
    };
    difftastic = {
      enable = true;
    };
  };

  programs.pyenv = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    # options = ["--cmd cd"];
    # Since I want to use *both* z/zi and cd/cdi, I do not use the init option to setup
    # cd/cdi aliases. Passing `--cmd cd` to zoxide in fish gets rid of the z prefix.
    # Instead, I only use that method for zsh, and I use manual abbreviations for fish.
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    # history.path = "$ZDOTDIR/.zsh_history";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dots;
        file = ".p10k.zsh";
      }
    ];
    initExtra = ''
      source ~/.config/zsh/catppuccin-syntax/themes/catppuccin_latte-zsh-syntax-highlighting.zsh

      export PATH="$XDG_CONFIG_HOME/emacs/bin":$PATH

      eval "$(zoxide init --cmd cd zsh)"
    '';
    shellAliases = {
      # Directory shortcuts
      cdn = "cd ~/notes/";
      cdq = "cd ~/repos/qmk_firmware/";
      cdd = "cd ~/repos/dnr-hugo/";
      cdz = "cd $ZDOTDIR";
      cde = "cd $XDG_CONFIG_HOME/doom";
      cdnv = "cd $XDG_CONFIG_HOME/nvim/";
      cdw = "cd $XDG_CONFIG_HOME/wezterm/";
      cdc = "cd ~/repos/code_projects/";

      # dotfile shortcuts
      nv = "~/nvim-macos-arm64/bin/nvim";
      nvim = "~/nvim-macos-arm64/bin/nvim";
      vz = "nvim $ZDOTDIR/.zshrc";
      vn = "nvim ~/.config/nvim/";
      vv = "nvim ~/.vimrc";
      vza = "nvim $ZDOTDIR/aliases";
      vyabai = "nvim $XDG_CONFIG_HOME/home-manager/dots/yabairc";
      vskhd = "nvim $XDG_CONFIG_HOME/home-manager/dots/skhdrc";
      nvnv = "nv $XDG_CONFIG_HOME/nvim/init.lua";
      nvh = "nv $XDG_CONFIG_HOME/home-manager/home.nix";
      nvw = "nv $XDG_CONFIG_HOME/wezterm/wezterm.lua";

      copydot = "cp -a $ZDOTDIR ~/Dropbox\ \(Maestral\)/backup/zsh/";

      sshnas = "ssh rambo@192.168.50.237";

      # # # # # # #
      # Git Aliases
      # # # # # # #
      gl = "git log";
      gp = "git pull";
      gs = "git status";
      gits = "git status";
      gitf = "git fetch";
      gita = "git add";
      gitcm = "git commit -m";
      gcm = "git commit -m";
      gch = "git checkout";

      # binary aliases
      cat = "bat";

      du = "dust";

      el = "erd -H -L 1";
      ela = "erd -H -L 1 -.";

      ls = "lsd";
      lsa = "lsd -a";
      ll = "lsd -l";
      lla = "ls -la";
      lt = "ls --tree";

      python = "python3";
      pip = "pip3";
      pym = "python3 -m";

      vnv = "python3 -m venv venv && source venv/bin/activate && pip install --upgrade pip";
      uvv = "uv venv venv"; # Create new virtual environment in ./venv/
      sv = "source *venv*/bin/activate";
    };
  };
}
