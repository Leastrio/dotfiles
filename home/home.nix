{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./programs/nvim.nix
    ./programs/hyprland.nix
    ./programs/obs.nix
    ./programs/dunst.nix
    ./programs/starship.nix
    ./programs/fish.nix
    ./programs/kitty.nix
    ./programs/rofi.nix
    ./programs/waybar.nix
    ./programs/btop.nix
    ./programs/ranger.nix
  ];
  home = {
    username = "jacob";
    homeDirectory = "/home/jacob";
    sessionVariables = {
      HOME_NIX = "$HOME/.config/nixos/home/home.nix";
      SYS_NIX = "$HOME/.config/nixos/system/configuration.nix";
    };
    packages = with pkgs; [
      firefox-devedition-bin
      spotify
      bitwarden
      pcmanfm
      wineWowPackages.stable
      winetricks
      lutris
      playerctl
      cliphist
      wl-clipboard
      helvum
      lutris
      obsidian-wayland
      swww
      insomnia
      ripgrep
      inotify-tools
      jetbrains.datagrip
      element-desktop
      ngrok
      gh
      gimp
      arduino
      fd
      ollama
      calibre
      erlang-ls
      qbittorrent
      mpv
      google-chrome
      lexical
      tailwindcss-language-server
      prismlauncher
      hyprcursor
      ffmpeg-full
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];
  };
  home.file.".icons/Catppuccin-Mocha-Light-Cursors".source = ./Catppuccin-Mocha-Light-Cursors;
  #home.pointerCursor = {
  #  gtk.enable = true;
  #  name = "Catppuccin-Mocha-Light-Cursors";
  #  package = pkgs.catppuccin-cursors.mochaLight;
  #  size = 16;
  #};
  #gtk = {
  #  enable = true;
  #  cursorTheme = {
  #    name = "Catppuccin-Mocha-Light-Cursors";
  #    package = pkgs.catppuccin-cursors.mochaLight;
  #    size = 16;
  #  };
  #};
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
    };
    nix-direnv = {
      enable = true;
    };
  };
  systemd.user.startServices = "sd-switch";
  programs.git = {
    enable = true;
    userName = "Leastrio";
    userEmail = "jacob@leastr.io";
    extraConfig.init.defaultBranch = "main";
    extraConfig.credential.helper = "store";
    extraConfig.push.autoSetupRemote = true;
  };
  home.stateVersion = "23.05";
}
