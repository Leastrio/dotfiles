{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./programs/nvim.nix
    ./programs/hyprland.nix
    ./programs/obs.nix
    ./programs/dunst.nix
    ./programs/starship.nix
    ./programs/fish.nix
    ./programs/kitty.nix
    ./programs/rofi.nix
    ./programs/waybar.nix
  ];
  home = {
    username = "jacob";
    homeDirectory = "/home/jacob";
    sessionVariables = {
      HOME_NIX = "$HOME/.config/nixos/home/home.nix";
      SYS_NIX = "$HOME/.config/nixos/system/configuration.nix";
    };
    packages = with pkgs; [
      firefox-devedition
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
      btop
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
      orca-slicer
      ollama
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.lexical.packages.${pkgs.system}.lexical
    ];
  };
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
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
