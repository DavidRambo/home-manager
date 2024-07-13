{pkgs, ...}: {
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

  imports = [./packages.nix ./fish.nix ./zsh.nix ./cli.nix];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "justfile".source = dots/justfile;
    "repos/macos-scripts" = {
      source = ./macos-scripts;
      recursive = true;
    };
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

  # paths append to ~/.config/
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
    XDG_CACHE_HOME = "/Users/david/.cache";
    XDG_CONFIG_HOME = "/Users/david/.config";
    XDG_STATE_HOME = "/Users/david/.local/state";
    EDITOR = "~/nvim-macos-arm64/bin/nvim";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    LEDGER_FILE = "~/finance/2024.journal";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
