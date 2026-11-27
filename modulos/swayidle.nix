{ pkgs, ... }:

{
  # gestión de inactividad y suspensión
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        # bloquear la sesión
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        # apagar la pantalla
        timeout = 601;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
      {
        # suspender el equipo
        timeout = 1200;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = {
      # bloquear antes de suspender
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";

      # atender solicitudes de bloqueo
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}
