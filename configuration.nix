{ config, pkgs, ... }:

{
  # 1. Hardware detectado durante la instalacion.
  #    Este archivo lo genera nixos-generate-config: NO copiarlo de otra PC.
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];
  # java para preparar los archivos de minecraft
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  # llavero para las credenciales de las aplicaciones
  services.gnome.gnome-keyring.enable = true;
  
  # compatibilidad con ejecutables externos
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # ventanas y gráficos
      libxkbcommon
      libxcb
      wayland
      vulkan-loader
      libglvnd
      libx11
      libxcursor
      libxext
      libxi
      libxrandr
      libxrender
      libxxf86vm

      # sonido y dispositivos
      alsa-lib
      udev

      # fuentes e integración
      fontconfig
      freetype
      dbus

      # dependencias del runtime de java
      zlib
      libxtst
    ];
  };

  # 2. Arranque UEFI.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 3. Nombre, idioma y zona horaria.
  networking.hostName = "nami";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";

  # 4. Red y firmware (la conexion no depende de Noctalia).
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # GESTIÓN DE ARCHIVOS Y DISPOSITIVOS
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # 5. Audio: PipeWire y WirePlumber.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # 6. Bateria, energia y permisos para los controles de Noctalia.
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  security.polkit.enable = true;

  # 7. Memoria: swap comprimida, sin particion swap.
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # 8. Escritorio: compositor Niri.
  programs.niri.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # 9. Inicio de sesion por terminal con greetd/tuigreet.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.niri.package}/bin/niri-session";
      user = "greeter";
    };
  };

  # 10. Cuenta personal. La contrasena se crea AL FINAL de nixos-install.
  users.users.miyu = {
    isNormalUser = true;

    shell = pkgs.zsh;

    extraGroups = [ "wheel" "networkmanager" ];
  };

  # 11. Herramientas generales y de diagnostico.
  environment.systemPackages = with pkgs; [
    git
    neovim
    pciutils
    usbutils
  ];

  # 12. Home Manager usa los mismos paquetes que NixOS.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.miyu = import ./home.nix;

  # 13. Optimizar el almacen sin borrar generaciones automaticamente.
  nix.settings.auto-optimise-store = true;

  # 14. Compatibilidad inicial de la instalacion, no fija versiones.
  system.stateVersion = "26.05";

  # 15. Shell del sistema
  programs.zsh.enable = true;
}
