{pkgs, ...}: {
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
      gss = "git status --short";
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
