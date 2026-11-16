{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    background-opacity = 0.92
    background = #131318
    background-blur = true
    # Pinned Plasma accent #5CB9AE, subtle use only
    cursor-color = #5cb9ae
    selection-background = #488985
    selection-foreground = #e4e1e9
    # Animated shaders need this (true = only when focused, always = even unfocused)
    custom-shader-animation = always
    # No custom-shader set = no background animations.
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
