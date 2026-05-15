#!/usr/bin/env bash
set -euo pipefail

COLORS_JSON="${1:?Usage: $0 <colors.json> [--strength N]}"
STRENGTH="0.85"
if [[ "${2:-}" == "--strength" && -n "${3:-}" ]]; then
    STRENGTH="$3"
fi

CACHE_DIR="$HOME/.cache/matugen"
KITTY_PATH="$HOME/.config/kitty/matugen.conf"
WEZTERM_PATH="$HOME/.config/wezterm/matugen.lua"
SEQUENCES_PATH="$CACHE_DIR/sequences.txt"

eval "$(jq -r '
    @sh "PRIMARY=\(.primary // .source_color // "#888888")",
    @sh "SOURCE=\(.source_color // "")",
    @sh "BG=\(.background // "#000000")",
    @sh "ON_BG=\(.on_background // "#ffffff")",
    @sh "ON_SEC_CON=\(.on_secondary_container // "")",
    @sh "SEC_CON=\(.secondary_container // "")",
    @sh "SURFACE=\(.surface // "")",
    @sh "ON_SURF_VAR=\(.on_surface_variant // "")",
    @sh "SURF_CON=\(.surface_container // "")"
' "$COLORS_JSON")"

LUM_R=$((16#${BG:1:2}))
LUM_G=$((16#${BG:3:2}))
LUM_B=$((16#${BG:5:2}))
LUMINANCE=$(( (2126 * LUM_R + 7152 * LUM_G + 720 * LUM_B) / 10000 ))
IS_DARK=1
[ "$LUMINANCE" -ge 128 ] && IS_DARK=0

HARMONIZED=$(awk -v primary="$PRIMARY" -v source="$SOURCE" \
    -v is_dark="$IS_DARK" -v strength="$STRENGTH" '
function hex2(s,    i, v, c) {
    v = 0
    for (i = 1; i <= length(s); i++) {
        c = substr(s, i, 1)
        if (c >= "0" && c <= "9") v = v * 16 + (c + 0)
        else if (c >= "A" && c <= "F") v = v * 16 + 10 + index("ABCDEF", c) - 1
        else if (c >= "a" && c <= "f") v = v * 16 + 10 + index("abcdef", c) - 1
    }
    return v
}

function hex_to_hsl(hex) {
    R = hex2(substr(hex, 2, 2)) / 255.0
    G = hex2(substr(hex, 4, 2)) / 255.0
    B = hex2(substr(hex, 6, 2)) / 255.0
    mx = R; if (G > mx) mx = G; if (B > mx) mx = B
    mn = R; if (G < mn) mn = G; if (B < mn) mn = B
    oL = (mx + mn) / 2.0
    if (mx == mn) { oH = 0; oS = 0; return }
    d = mx - mn
    if (oL > 0.5) oS = d / (2.0 - mx - mn)
    else oS = d / (mx + mn)
    if (mx == R) { oH = (G - B) / d; if (G < B) oH += 6 }
    else if (mx == G) oH = (B - R) / d + 2
    else oH = (R - G) / d + 4
    oH = oH / 6.0
}

function hue2rgb(p, q, t) {
    if (t < 0) t += 1.0
    if (t > 1) t -= 1.0
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t
    if (t < 0.5) return q
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0
    return p
}

function hsl_to_hex(h, s, l,    q, p, r, g, b) {
    if (s == 0) { r = l; g = l; b = l }
    else {
        if (l < 0.5) q = l * (1.0 + s); else q = l + s - l * s
        p = 2.0 * l - q
        r = hue2rgb(p, q, h + 1.0/3.0)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1.0/3.0)
    }
    return sprintf("#%02X%02X%02X", int(r*255+0.5), int(g*255+0.5), int(b*255+0.5))
}

BEGIN {
    split("282828 CC241D 98971A D79921 458588 B16286 689D6A A89984 928374 FB4934 B8BB26 FABD2F 83A598 D3869B 8EC07C EBDBB2 D65D0E A89984 D79921", dark_base)
    split("FDF9F3 FF6188 A9DC76 FC9867 FFD866 F47FD4 78DCE8 333034 121212 FF6188 A9DC76 FC9867 FFD866 F47FD4 78DCE8 333034 D65D0E A89984 D79921", light_base)

    hex_to_hsl(primary)
    pri_H = oH; pri_S = oS; pri_L = oL

    if (source != "") {
        hex_to_hsl(source)
        src_S = oS
        chroma_sc = pri_S / src_S
        if (chroma_sc > 1.0) chroma_sc = 1.0
    } else {
        chroma_sc = 1.0
    }

    for (i = 1; i <= 19; i++) {
        if (is_dark == 1) hex = "#" dark_base[i]
        else hex = "#" light_base[i]
        if (i == 1) { printf "term%d=%s\n", i-1, bg; continue }
        if (i == 8) { printf "term%d=%s\n", i-1, onbg; continue }

        hex_to_hsl(hex)
        from_H = oH; from_S = oS; from_L = oL

        diff = pri_H - from_H
        if (diff > 0.5) diff -= 1.0
        if (diff < -0.5) diff += 1.0
        out_H = from_H + diff * strength
        out_H = out_H - int(out_H)
        if (out_H < 0) out_H += 1.0

        out_S = from_S * chroma_sc
        if (out_S > 1.0) out_S = 1.0

        idx = i - 1
        if (idx >= 1 && idx <= 6) { target_L = 0.58; blend_amt = 0.65 }
        else if (idx >= 8 && idx <= 15) { target_L = 0.68; blend_amt = 0.60 }
        else { target_L = 0.62; blend_amt = 0.60 }

        if (is_dark == 1) {
            out_L = from_L + (target_L - from_L) * blend_amt
        } else {
            out_L = from_L + ((1.0 - target_L) - from_L) * blend_amt
            if (out_L < 0.0) out_L = 0.0
        }
        if (out_L > 1.0) out_L = 1.0
        if (out_L < 0.0) out_L = 0.0

        printf "term%d=%s\n", idx, hsl_to_hex(out_H, out_S, out_L)
    }
}' -v bg="$BG" -v onbg="$ON_BG")

declare -A TERM
while IFS='=' read -r key val; do
    TERM["$key"]="$val"
done <<< "$HARMONIZED"

TERM[term0]="$BG"
TERM[term7]="$ON_BG"

write_kitty() {
    mkdir -p "$(dirname "$KITTY_PATH")"
    {
        echo "background ${TERM[term0]}"
        echo "foreground ${TERM[term7]}"
        echo "cursor ${TERM[term7]}"
        echo "cursor_text_color ${TERM[term0]}"
        echo "selection_background ${ON_SEC_CON:-${TERM[term7]}}"
        echo "selection_foreground ${SEC_CON:-${TERM[term0]}}"
        for i in $(seq 0 18); do echo "color${i} ${TERM[term${i}]}"; done
        echo ""
        echo "# --- Tab bar settings synced with Matugen ---"
        echo "active_tab_foreground ${SURFACE:-${TERM[term0]}}"
        echo "active_tab_background ${PRIMARY}"
        echo "inactive_tab_foreground ${ON_SURF_VAR:-${TERM[term8]}}"
        echo "inactive_tab_background ${SURF_CON:-${TERM[term0]}}"
        echo "tab_bar_background ${SURFACE:-${TERM[term0]}}"
    } > "$KITTY_PATH"
}

write_wezterm() {
    mkdir -p "$(dirname "$WEZTERM_PATH")"
    {
        echo "local colors = {"
        echo "  foreground = \"${TERM[term7]}\","
        echo "  background = \"${TERM[term0]}\","
        echo "  cursor_bg = \"${TERM[term7]}\","
        echo "  cursor_fg = \"${TERM[term0]}\","
        echo "  selection_bg = \"${ON_SEC_CON:-${TERM[term7]}}\","
        echo "  selection_fg = \"${SEC_CON:-${TERM[term0]}}\","
        echo "  ansi = {"
        for i in $(seq 0 7); do echo "    \"${TERM[term${i}]}\","; done
        echo "  },"
        echo "  brights = {"
        for i in $(seq 8 15); do echo "    \"${TERM[term${i}]}\","; done
        echo "  },"
        echo "  indexed = {"
        for i in 16 17 18; do echo "    [${i}] = \"${TERM[term${i}]}\","; done
        echo "  },"
        echo "}"
        echo "return colors"
    } > "$WEZTERM_PATH"
}

build_sequences() {
    local esc=$'\033' st=$'\033\\'
    local seq=""
    local fg_r=$((16#${TERM[term7]:1:2})) fg_g=$((16#${TERM[term7]:3:2})) fg_b=$((16#${TERM[term7]:5:2}))
    local bg_r=$((16#${TERM[term0]:1:2})) bg_g=$((16#${TERM[term0]:3:2})) bg_b=$((16#${TERM[term0]:5:2}))
    seq+="${esc}]10;rgb:${fg_r}/${fg_g}/${fg_b}${st}"
    seq+="${esc}]11;rgb:${bg_r}/${bg_g}/${bg_b}${st}"
    seq+="${esc}]12;rgb:${fg_r}/${fg_g}/${fg_b}${st}"
    seq+="${esc}]17;rgb:${fg_r}/${fg_g}/${fg_b}${st}"
    for i in $(seq 0 18); do
        local c="${TERM[term${i}]}"
        local cr=$((16#${c:1:2})) cg=$((16#${c:3:2})) cb=$((16#${c:5:2}))
        seq+="${esc}]4;${i};rgb:${cr}/${cg}/${cb}${st}"
    done
    mkdir -p "$(dirname "$SEQUENCES_PATH")"
    printf '%s' "$seq" > "$SEQUENCES_PATH"
}

apply_sequences() {
    for tty in /dev/pts/[0-9]*; do
        cat "$SEQUENCES_PATH" > "$tty" 2>/dev/null || true
    done
    pkill -USR1 -x kitty 2>/dev/null || true
}

write_kitty
write_wezterm
build_sequences
apply_sequences

MODE="dark"; [ "$IS_DARK" -eq 0 ] && MODE="light"
echo "mode:    $MODE"
echo "accent:  $PRIMARY"
echo ""
for i in $(seq 0 18); do printf "  term%-2d %s\n" "$i" "${TERM[term${i}]}"; done
echo ""
echo "kitty:   $KITTY_PATH"
echo "wezterm: $WEZTERM_PATH"
echo "sequences: $SEQUENCES_PATH"
