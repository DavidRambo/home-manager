{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    bat
    erdtree
    exercism
    fzf
    htop
    http-prompt
    just
    lazygit
    lsd
    mongosh
    nodePackages_latest.pnpm
    pipx
    ripgrep
    rye
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
}
