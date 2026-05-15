local colors = {
  foreground = "{{ colors.on_background.default.hex }}",
  background = "{{ colors.background.default.hex }}",
  cursor_bg = "{{ colors.on_background.default.hex }}",
  cursor_fg = "{{ colors.background.default.hex }}",
  selection_bg = "{{ colors.on_secondary_container.default.hex }}",
  selection_fg = "{{ colors.secondary_container.default.hex }}",
  ansi = {
    "{{ colors.background.default.hex }}",
    "{{ "#FF6188" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#A9DC76" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#FC9867" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#FFD866" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#F47FD4" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#78DCE8" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ colors.on_background.default.hex }}",
  },
  brights = {
    "{{ "#121212" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#FF6188" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#A9DC76" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#FC9867" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#FFD866" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#F47FD4" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#78DCE8" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#333034" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
  },
  indexed = {
    [16] = "{{ "#D65D0E" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    [17] = "{{ "#A89984" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    [18] = "{{ "#D79921" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
  },
}
return colors
