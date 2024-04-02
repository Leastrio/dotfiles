{
  config,
  pkgs,
  ...
}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#89B4FA";
        separator_color = "frame";
        separator_height = 3;
        font = "JetBrainsMono Nerd Font 10";
        format = ''<b>%s</b>\n%b'';
        mouse_left_click = "do_action, close_current";
        markup = "full";
        corner_radius = 8;
        monitor = 1;
        geometry = "600x50-50+65";
      };
      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };
      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };
      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#FAB387";
        timeout = 0;
      };
    };
  };
}
