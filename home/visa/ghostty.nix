{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    # Copied from kitty.conf: background_opacity 0.92
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

    # Maple Mono NF (installed declaratively)
    font-family = Maple Mono NF
    font-family-bold = Maple Mono NF
    font-family-italic = Maple Mono NF
    font-family-bold-italic = Maple Mono NF
    font-size = 11.5

    # --- Kitty compatibility (explicit Kitty defaults, additive) ---
    # Clipboard / tabs (same as Ghostty defaults, pinned explicit)
    keybind = ctrl+shift+c=copy_to_clipboard
    keybind = ctrl+shift+v=paste_from_clipboard
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+n=new_window
    # Kitty-style scrolling (Ghostty defaults use shift-only here)
    keybind = ctrl+shift+arrow_up=scroll_page_lines:-1
    keybind = ctrl+shift+arrow_down=scroll_page_lines:1
    keybind = ctrl+shift+home=scroll_to_top
    keybind = ctrl+shift+end=scroll_to_bottom
    # Kitty-style font size (Ghostty defaults are ctrl+= / ctrl+- / ctrl+0)
    keybind = ctrl+shift+==increase_font_size:1
    keybind = ctrl+shift+-=decrease_font_size:1
    keybind = ctrl+shift+backspace=reset_font_size
    # Kitty window switching ([ / ]) mapped to Ghostty splits
    keybind = ctrl+shift+[=goto_split:previous
    keybind = ctrl+shift+]=goto_split:next
  '';
}
