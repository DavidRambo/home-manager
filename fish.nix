{
  pkgs,
  lib,
  config,
  ...
}: {
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
      # if test (uname) = Darwin
      #     fish_add_path --prepend --global \
      #       "${config.xdg.stateHome}/nix/profile/bin" \
      #       /etc/profiles/per-user/$USER/bin \
      #       /run/current-system/sw/bin \
      #       /nix/var/nix/profiles/default/bin
      # end
    '';
    interactiveShellInit = ''
      set fish_greeting

      fish_vi_key_bindings

      # Location for nvm directory, since bass assumes ~/.nvm
      set -gx NVM_DIR ~/.config/nvm

      fish_add_path ~/.local/bin

      uv generate-shell-completion fish | source
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

      "rc" = "ruff check";
      "rf" = "ruff check --fix";

      "uvv" = "uv venv";
      "sv" = "source .venv/bin/activate.fish";
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
}
