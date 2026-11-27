{ pkgs, ... }:

{
  # perfil de usuario
  home.username = "miyu";
  home.homeDirectory = "/home/miyu";
  home.stateVersion = "26.05";
  
  # módulos independientes
  imports = [
    ./modulos/swayidle.nix
  ];

  # aplicaciones personales
  home.packages = with pkgs; [
    brave-origin
    firefox
    nautilus
    swaybg
    xwayland-satellite
    brightnessctl
    wireplumber
    pavucontrol
    libnotify
    vscodium
    proton-vpn
    qbittorrent
  ];

  # bloqueo de pantalla
  programs.swaylock.enable = true;

  xdg.configFile."swaylock/config".source = ./dotfiles/swaylock/config;

  # lanzador y servicios del escritorio
  programs.fuzzel.enable = true;

  xdg.configFile."fuzzel/fuzzel.ini".source = ./dotfiles/fuzzel/fuzzel.ini;

  # notificaciones por mako
  services.mako.enable = true;

  xdg.configFile."mako/config".source = ./dotfiles/mako/config;
    
  # indicador de volumen y brillo
  services.swayosd.enable = true;

  xdg.configFile."swayosd/config.toml".source = ./dotfiles/swayosd/config.toml;
  xdg.configFile."swayosd/style.css".source = ./dotfiles/swayosd/style.css;

  services.polkit-gnome.enable = true;

  # niri
  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;

  # waybar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.targets = [ "graphical-session.target" ];
  };

  # archivos de waybar
  xdg.configFile."waybar/config".source = ./dotfiles/waybar/config.jsonc;

  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;

  # kitty
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/kitty/kitty.conf;
  };

  # starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (
      builtins.readFile ./dotfiles/starship.toml
    );
  };

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # cursor
  gtk.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

}
