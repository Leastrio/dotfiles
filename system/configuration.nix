# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man pag# and in the NixOS manual (accessible by running `nixos-help`).
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    initrd.kernelModules = ["amdgpu"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
    allowedUDPPorts = [51820];
  };

  time.timeZone = "America/Denver";

  nix = {
    package = pkgs.nixUnstable;
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  #virtualisation = {
  #  waydroid.enable = true;
  #  lxd.enable = true;
  #};

  #programs.wireshark.enable = true;

  virtualisation.docker.enable = true;

  users.users.jacob = {
    initialPassword = "meow";
    isNormalUser = true;
    home = "/home/jacob";
    extraGroups = ["wheel" "networkmanager" "wireshark" "docker" "dialout"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoaJcvg0UPsRsFrkKdDtxn6+OrOMt7m8+NbQAYxxMKaJGFVbCcp3Jf40TvLdP7NDqmHxKYHD7WDO31GPPjckvEmM5tOo8KPrJLKv+aVO40NTb3vDLOGl1O8IjyLoW1bUyG29niO3cJ3ctrcNgldCY42doGcoV4Z+IVfkYjAbGxya0vDoHDcOv1HexKaBG1fZ2izUSMulfGjqZZA85StoV8Xw+nVAeEPeK1fDAqP8t1aBWB9KVo2OpcAF2GnRbECDp98k4/agj/M0SNm7I03pH3E5bMBQdhevwP9jTo2iB0TMbzqZiwNMn+YXa7k1dMDUjvnfmQb2nNkzs3zjKoUag+ZyxKWGDtDwZZTAIiqmN7WKM7Jhj2DU8e+zg1RYf5rozczaoFcssZNaLGKw5jOPdfHHwQxeb/LnJaB1SBn0Kc7DRO7So4xK/Te9nzg/3tBMM21qIsv/CFE46ELydt8XIIkIfppWfmzBp0ccLiL6/25m2yoTCPLlFssK6TolRz70E= jacob@nixos"
    ];
  };

  programs.fish.enable = true;

  boot.kernelParams = [
    "video=DP-1:2560x1440@170"
    "video=HDMI-A-1:2560x1440@59"
  ];

  zramSwap.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  security.polkit.enable = true;

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  fileSystems."/home/jacob/Projects" = {
    device = "/dev/disk/by-uuid/8458a125-3b00-4baa-ac24-d45b68644929";
    fsType = "ext4";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "jacob";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  documentation.dev.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git
      polkit-kde-agent
      man-pages
      man-pages-posix
      vesktop
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      QT_QPA_PLATFORM = "wayland";
    };
  };
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "DroidSansMono"];})
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  system.stateVersion = "23.05"; # Did you read the comment?
}
