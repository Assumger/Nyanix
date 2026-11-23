
{ pkgs, ... }:

{
  # Instalar Noctalia para mi usuario.
  home.packages = [
    pkgs.noctalia
  ];

  # Administrar mi  configuración visual.
  xdg.configFile = {
    "noctalia/config.toml".source = ./config.toml;

    "noctalia/palettes/Monocromo.json".source =
      ./Monocromo.json;
  };
}

