{ ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        bars = 0;
        bar_width = 2;
        bar_spacing = 1;
      };
      color = {
        # Tokyo Night / system accent themed gradient
        gradient = 1;
        gradient_count = 8;
        gradient_color_1 = "'#7aa2f7'";
        gradient_color_2 = "'#769ff0'";
        gradient_color_3 = "'#5cb9ae'";
        gradient_color_4 = "'#488985'";
        gradient_color_5 = "'#bb9af7'";
        gradient_color_6 = "'#7dcfff'";
        gradient_color_7 = "'#2ac3de'";
        gradient_color_8 = "'#c0caf5'";
      };
      smoothing = {
        noise_reduction = 77;
      };
    };
  };
}
