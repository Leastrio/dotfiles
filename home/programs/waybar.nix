{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "DP-3"
          "HDMI-A-1"
        ];
        modules-left = ["hyprland/workspaces"];
        modules-center = ["custom/music"];
        modules-right = ["cpu" "memory" "disk" "disk#disk2" "clock"];

        "hyprland/workspaces" = {
          "persistent-workspaces" = {
            "*" = [1 2 3 4 5 6];
          };
        };

        "clock" = {
          interval = 1;
          format = "{:%I:%M %p  %A %b %d}";
          tooltip = true;
          tooltip-format = "{:%A, %d %B %Y}\n<tt>{calendar}</tt>";
        };

        "memory" = {
          on-click = "kitty btop";
          interval = 4;
          format = "󰘚 {percentage}%";
          tooltip = true;
          tooltip-format = "{used}GiB / {total}GiB => {percentage}%";
          states = {
            warning = 85;
          };
        };

        "cpu" = {
          interval = 4;
          format = " {usage}%";
        };

        "disk" = {
          interval = 30;
          format = " {used}";
          path = "/";
          tooltip = true;
          tooltip-format = "{used} / {total} => {percentage_used}%";
        };

        "disk#disk2" = {
          interval = 30;
          format = " {used}";
          path = "/data";
          tooltip = true;
          tooltip-format = "{used} / {total} => {percentage_used}%";
        };

        "custom/music" = {
          format = " {}";
          escape = true;
          interval = 5;
          tooltip = false;
          exec = "playerctl metadata --format '{{ artist }} - {{ title }}'";
          on-click = "playerctl play-pause";
        };
      };
    };
    style = ''
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      * {
        font-family: "FiraCode Nerd Font";
        font-size: .9rem;
        border-radius: 1rem;
        transition-property: background-color;
        transition-duration: 0.5s;
        background-color: shade(@base, 0.9);
      }

      @keyframes blink_red {
        to {
          background-color: @red;
          color: @base;
        }
      }

      .warning, .critical, .urgent {
        animation-name: blink_red;
        animation-duration: 1s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #clock, #memory, #cpu, #disk, #custom-music {
        padding-left: .6rem;
        padding-right: .6rem;
      }

      /* Bar */
      window#waybar {
        background-color: transparent;
      }

      window > box {
        background-color: transparent;
        margin: .3rem;
        margin-bottom: 0;
      }

      /* Workspaces */
      #workspaces button {
        padding-right: .4rem;
        padding-left: .4rem;
        padding-top: .2rem;
        padding-bottom: .2rem;
        color: @red;
        /* border: .2px solid transparent; */
        background: transparent;
      }

      #workspaces button:hover {
        border: .2px solid transparent;
        color: @rosewater;
        box-shadow: none;
        text-shadow: none;
      }

      /* Tooltip */
      tooltip {
        background-color: @base;
        border: .2px solid @blue;
      }

      tooltip label {
        color: @rosewater;
      }

      /* Extra */
      #memory {
        color: @peach;
      }
      #cpu {
        color: @blue;
      }
      #clock {
        color: @rosewater;
      }
      #disk {
        color: @maroon;
      }
      #custom-music {
        color: @green
      }
    '';
  };
}
