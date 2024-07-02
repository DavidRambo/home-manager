{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "david";
  home.homeDirectory = "/Users/david";
  xdg.cacheHome = "/Users/david/.config/cache";
  xdg.configHome = "/Users/david/.config";

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
    uv
    zoxide
    zsh

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

  # $XDG_CONFIG_HOME = ~/.config
  xdg.configFile = {
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
    EDITOR = "~/nvim-macos-arm64/bin/nvim";
    LEDGER_FILE = "~/finance/2024.journal";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
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

  programs.fzf = {
    enable = true;
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
    enableZshIntegration = true;
  };

  programs.powerline-go = {
    enable = true;
    modules = [
      "cwd"
      "gitlite"
    ];
    modulesRight = [
      "venv"
    ];
    settings = {
      cwd-mode = "plain"; # fancy, semifancy, plain, dironly
      cwd-max-depth = 4;
    };
    newline = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    # history.path = "$ZDOTDIR/.zsh_history";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "source ~/.config/zsh/catppuccin-syntax/themes/catppuccin_latte-zsh-syntax-highlighting.zsh";
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
      nvim = "nvim-macos-arm64/bin/nvim";
      vz = "nvim $ZDOTDIR/.zshrc";
      vn = "nvim ~/.config/nvim/";
      vv = "nvim ~/.vimrc";
      vza = "nvim $ZDOTDIR/aliases";
      vyabai = "nvim $XDG_CONFIG_HOME/yabai/yabairc";
      vskhd = "nvim $XDG_CONFIG_HOME/skhd/skhdrc";
      nvnv = "nv $XDG_CONFIG_HOME/nvim/";
      nvh = "nv $XDG_CONFIG_HOME/home-manager/home.nix";

      copydot = "cp -a $ZDOTDIR ~/Dropbox\ \(Maestral\)/backup/zsh/";

      sshnas = "ssh rambo@192.168.50.237";

      # # # # # # #
      # Git Aliases
      # # # # # # #
      gits = "git status";
      gitf = "git fetch";
      gita = "git add";
      gitcm = "git commit -m";

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
