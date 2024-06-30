{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    extraConfig = ''
      monitor = DP-3,2560x1440@170,0x520,1,bitdepth,10
      monitor = HDMI-A-1,2560x1440@59,2560x0,1,transform,3,bitdepth,10

      exec-once = waybar
      exec-once = swww init && swww img $HOME/Wallpapers/tropic_island_night.jpg
      exec-once = wl-paste --type text --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store

      exec-once = [workspace 1 silent] kitty
      exec-once = [workspace 2 silent] firefox-devedition
      exec-once = [workspace 4 silent] vesktop
      exec-once = [workspace 3 silent] spotify

      bind = SUPER, Return, exec, kitty
      bind = SUPER, d, exec, rofi -show drun
      bind = SUPER, c, killactive
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      bind = , Print, exec, grimblast --notify copy area
      bind = SUPER, f, fullscreen
      bind = SUPER, v, togglefloating
      bind = SUPERSHIFT, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6

      workspace = 1, monitor:DP-3, default:true
      workspace = 2, monitor:HDMI-A-1, default:true
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:HDMI-A-1
      workspace = 5, monitor:DP-3
      workspace = 6, monitor:HDMI-A-1

      windowrule = float,lutris
      windowrule = center,lutris

      windowrule = center,Rofi
      windowrule = stayfocused,Rofi

      windowrule = center,Erlang
      windowrule = float,Erlang

      general {
        gaps_out = 10
      }

      cursor {
        no_warps = true
      }

      decoration {
       rounding = 10

       drop_shadow = true
       shadow_range = 4
       shadow_render_power = 3
       col.shadow = rgba(1a1a1aee)
      }

      animations {
        enabled = true

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

    '';
  };
}
