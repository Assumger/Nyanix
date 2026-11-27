{ config, pkgs, lib, ... }:

{
  # hardware generado durante la instalación
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # arranque uefi
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # autenticación para el bloqueo de pantalla
  security.pam.services.swaylock = {};

  # nombre, idioma y zona horaria
  networking.hostName = "Reze-PC";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";

  # red, firmware, gráficos y bluetooth
  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # archivos, dispositivos y credenciales
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # batería, energía y permisos
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  security.polkit.enable = true;

  # intercambio comprimido en ram
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # escritorio
  programs.niri.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # inicio de sesión
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.niri.package}/bin/niri-session";
      user = "greeter";
    };
  };

  # cuenta personal y shell
  programs.zsh.enable = true;
  users.users.miyu = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # herramientas generales
  environment.systemPackages = with pkgs; [
    git
    neovim
    pciutils
    usbutils
  ];

  # gestor de contraseñas
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "miyu" ];
  };
  # permitir únicamente 1password como software no libre
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
  ];
  
  # fuentes del escritorio e iconos
  fonts.packages = with pkgs; [
    inter 
    nerd-fonts.symbols-only
    jetbrains-mono
  ];

  # integrar home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.miyu = import ./home.nix;

  # optimizar el almacén sin borrar generaciones
  nix.settings.auto-optimise-store = true;

  # versión inicial de compatibilidad
  system.stateVersion = "26.05";

}
