{ pkgs, ... }:

{
  imports = [
    ./noctalia/default.nix
  ];

  # 1. Mi perfil de usuario.
  home.username = "miyu";
  home.homeDirectory = "/home/miyu";
  home.stateVersion = "26.05";

  # 2. Aplicaciones personales.
  home.packages = with pkgs; [
    brave-origin
    nautilus
    xwayland-satellite  
    brightnessctl
    wireplumber
    vscodium
    proton-vpn
    qbittorrent
  ];
  # Kitty
  programs.kitty = {
    enable = true;

    settings = {
      font_size = 12;
      background = "#0c0c0c";
      background_opacity = 0.60;
      background_blur = 1;

      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
  };
  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      # primera línea con usuario, directorio y hora
      # segunda línea para escribir comandos
      format =
        "[](fg:#DDDDDD)"
        + "$username"
        + "[](fg:#DDDDDD bg:#C4C4C4)"
        + "$directory"
        + "[](fg:#C4C4C4 bg:#ADADAD)"
        + "$time"
        + "[](fg:#ADADAD)"
        + "$line_break"
        + "$character";

      # usuario
      username = {
        show_always = true;
        style_user = "bold fg:#292929 bg:#DDDDDD";
        format = "[ ▲ $user ]($style)";
      };

      # directorio actual
      directory = {
        style = "bold fg:#292929 bg:#C4C4C4";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      # hora
      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "bold fg:#292929 bg:#ADADAD";
        format = "[  $time ]($style)";
      };

      # símbolo del prompt
      character = {
        success_symbol = "[❯](fg:#BEBEBE)";
        error_symbol = "[❯](fg:#BEBEBE)";
      };
    };
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # CURSOR
  gtk.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  # 3. Atajos de Niri, idioma del teclado e inicio de Noctalia.
  #    El archivo real ~/.config/niri/config.kdl lo administra Home Manager.
  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "latam"
        }
      }
    }
    //decoración de niri
    prefer-no-csd

    // Apariencia de ventanas
    layout {
        gaps 0

        focus-ring {
            off
        }

        border {
            on
            width 2

            active-color "#e6e6e6"
            inactive-color "#555555"
        }
    }

    spawn-at-startup "noctalia"

    cursor {
        xcursor-theme "Bibata-Modern-Ice"
        xcursor-size 24
    }

    binds {
      // Aplicaciones y paneles.
      Mod+T { spawn "kitty"; }
      Mod+E { spawn "nautilus"; }
      Mod+Space { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
      Mod+S { spawn "noctalia" "msg" "panel-toggle" "control-center"; }
      Mod+D { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
      Mod+B { spawn "brave-origin"; }

      // Ventanas y espacios de trabajo.
      Mod+Q { close-window; }
      Mod+Z { focus-column-left; }
      Mod+X { focus-column-right; }
      Mod+Up { focus-workspace-up; }
      Mod+Down { focus-workspace-down; }
      Mod+O { toggle-overview; }
      Mod+F { maximize-column; }
      Mod+Shift+E { quit; }
      
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      // Mover la columna enfocada a otro espacio.
      Mod+Ctrl+1 { move-column-to-workspace 1; }
      Mod+Ctrl+2 { move-column-to-workspace 2; }
      Mod+Ctrl+3 { move-column-to-workspace 3; }
      Mod+Ctrl+4 { move-column-to-workspace 4; }
      Mod+Ctrl+5 { move-column-to-workspace 5; }
      Mod+Ctrl+6 { move-column-to-workspace 6; }
      Mod+Ctrl+7 { move-column-to-workspace 7; }
      Mod+Ctrl+8 { move-column-to-workspace 8; }
      Mod+Ctrl+9 { move-column-to-workspace 9; }

      // Capturas de pantalla con Niri.
      Print { screenshot; }

      // Volumen y brillo controlados por Noctalia.
      XF86AudioRaiseVolume { spawn "noctalia" "msg" "volume-up"; }
      XF86AudioLowerVolume { spawn "noctalia" "msg" "volume-down"; }
      XF86AudioMute { spawn "noctalia" "msg" "volume-mute"; }
      XF86MonBrightnessUp { spawn "noctalia" "msg" "brightness-up"; }
      XF86MonBrightnessDown { spawn "noctalia" "msg" "brightness-down"; }
    }
  '';

  # 4. Activar el agente de autorizacion integrado de Noctalia v5.
  #    No instalar otro agente Polkit en paralelo.
  xdg.configFile."noctalia/config.toml".text = ''
    [shell]
    polkit_agent = true
  '';
}
