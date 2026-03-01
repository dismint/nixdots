{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dismint";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 7777 ];
  networking.firewall.allowedUDPPorts = [ 7777 ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  users.users.dismint = {
    isNormalUser = true;
    description = "Justin Choi";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  # because these are system wide packages, mandate a comment for why they belong
  environment.systemPackages = with pkgs; [
    bash # of course
    eza # fish dependency
    firefox # default lightweight browser
    fish # shell
    fuzzel # launcher
    fzf # fish dependency
    gcc # for make for nvim
    git # git
    kitty # terminal
    neovim # editor
    starship # fish dependency
    stow # manage my dotfiles
    xwayland-satellite # niri dependency (honestly not sure why this doesn't get installed with it)
    zoxide # fish dependency
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # foreign language support
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # the goat
      maple-mono.NF
      # general
      noto-fonts
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Maple Mono NF" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  programs.niri.enable = true;
  programs.steam.enable = true;

  fileSystems."/mnt/windows" = {
    device = "/dev/nvme1n1p3";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=1000"
      "dmask=022"
      "fmask=133"
      "nofail"
    ];
  };

  system.stateVersion = "25.11";
}
