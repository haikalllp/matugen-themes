local colors = {
  foreground = "{{ colors.on_background.default.hex }}",
  background = "{{ colors.background.default.hex }}",
  cursor_bg = "{{ colors.on_background.default.hex }}",
  cursor_fg = "{{ colors.background.default.hex }}",
  selection_bg = "{{ colors.on_secondary_container.default.hex }}",
  selection_fg = "{{ colors.secondary_container.default.hex }}",
  ansi = {
    "{{ colors.background.default.hex }}",
    "{{ "#CC241D" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#98971A" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#D79921" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#458588" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#B16286" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ "#689D6A" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 25.0 }}",
    "{{ colors.on_background.default.hex }}",
  },
  brights = {
    "{{ "#928374" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#FB4934" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#B8BB26" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#FABD2F" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#83A598" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#D3869B" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#8EC07C" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    "{{ "#EBDBB2" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
  },
  indexed = {
    [16] = "{{ "#D65D0E" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    [17] = "{{ "#A89984" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
    [18] = "{{ "#D79921" | to_color | blend: {{ colors.primary.default.hex }}, 0.85 | saturate: -20.0, "hsl" | auto_lightness: 15.0 }}",
  },
}
return colors
