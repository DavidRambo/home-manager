{pkgs, ...}: {
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

  programs.direnv = {
    enable = true;
    # nix-direnv.enable = true;
  };

  programs.fd = {
    enable = true;
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
}
