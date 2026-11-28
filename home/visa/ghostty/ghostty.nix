{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    # TokyoNight Storm palette
    background = #24283b
    foreground = #c0caf5
    background-opacity = 0.88
    background-blur = true
    cursor-color = #c0caf5
    cursor-text = #24283b
    cursor-style = bar
    cursor-style-blink = true
    selection-background = #364a82
    selection-foreground = #c0caf5

    # Padding / window feel
    window-padding-x = 10
    window-padding-y = 8
    window-padding-balance = true

    # animated shaders
    custom-shader-animation = always
    # no custom shader
    # Example: custom-shader = ~/.config/ghostty/shaders/crt.glsl

    # Maple Mono NF
    font-family = Maple Mono NF
    font-family-bold = Maple Mono NF
    font-family-italic = Maple Mono NF
    font-family-bold-italic = Maple Mono NF
    font-size = 11.5

    # Kitty compatibility
    # Clipboard / tabs
    keybind = ctrl+shift+c=copy_to_clipboard
    keybind = ctrl+shift+v=paste_from_clipboard
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+n=new_window
    # Scrolling
    keybind = ctrl+shift+arrow_up=scroll_page_lines:-1
    keybind = ctrl+shift+arrow_down=scroll_page_lines:1
    keybind = ctrl+shift+home=scroll_to_top
    keybind = ctrl+shift+end=scroll_to_bottom
    # Font size
    keybind = ctrl+shift+==increase_font_size:1
    keybind = ctrl+shift+-=decrease_font_size:1
    keybind = ctrl+shift+backspace=reset_font_size
    # Window/split switching
    keybind = ctrl+shift+[=goto_split:previous
    keybind = ctrl+shift+]=goto_split:next
  '';
}
