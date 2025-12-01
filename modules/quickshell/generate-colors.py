#!/usr/bin/env python3
"""
Generate Material Design 3 color scheme from base16/Stylix colors.
This script creates a colors.json file compatible with the end-4/dots-hyprland quickshell config.
"""

import json
import sys
import colorsys

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple (0-255)"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(r, g, b):
    """Convert RGB tuple to hex color"""
    return "#{:02x}{:02x}{:02x}".format(int(r), int(g), int(b))

def rgb_to_hsl(r, g, b):
    """Convert RGB (0-255) to HSL (0-1)"""
    r, g, b = r/255, g/255, b/255
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    return h, s, l

def hsl_to_rgb(h, s, l):
    """Convert HSL (0-1) to RGB (0-255)"""
    r, g, b = colorsys.hls_to_rgb(h, l, s)
    return int(r*255), int(g*255), int(b*255)

def adjust_lightness(hex_color, target_lightness):
    """Adjust the lightness of a color while preserving hue and saturation"""
    r, g, b = hex_to_rgb(hex_color)
    h, s, l = rgb_to_hsl(r, g, b)
    r, g, b = hsl_to_rgb(h, s, target_lightness)
    return rgb_to_hex(r, g, b)

def mix_colors(color1, color2, ratio=0.5):
    """Mix two hex colors with given ratio (0 = all color1, 1 = all color2)"""
    r1, g1, b1 = hex_to_rgb(color1)
    r2, g2, b2 = hex_to_rgb(color2)
    r = r1 * (1 - ratio) + r2 * ratio
    g = g1 * (1 - ratio) + g2 * ratio
    b = b1 * (1 - ratio) + b2 * ratio
    return rgb_to_hex(r, g, b)

def generate_material_colors(base16_colors):
    """
    Generate Material Design 3 colors from base16 color scheme.
    
    Base16 mapping:
    - base00: Background
    - base01: Lighter background (panels)
    - base02: Selection background
    - base03: Comments, subtle
    - base04: Dark foreground
    - base05: Default foreground (text)
    - base06: Light foreground
    - base07: Lightest background
    - base08: Red (errors)
    - base09: Orange (warnings)
    - base0A: Yellow (classes)
    - base0B: Green (strings)
    - base0C: Cyan (support)
    - base0D: Blue (functions) - PRIMARY
    - base0E: Purple (keywords)
    - base0F: Brown (deprecated)
    """
    
    # Get base colors
    bg = base16_colors['base00']
    bg_lighter = base16_colors['base01']
    selection = base16_colors['base02']
    comments = base16_colors['base03']
    fg_dark = base16_colors['base04']
    fg = base16_colors['base05']
    fg_light = base16_colors['base06']
    bg_lightest = base16_colors['base07']
    red = base16_colors['base08']
    orange = base16_colors['base09']
    yellow = base16_colors['base0A']
    green = base16_colors['base0B']
    cyan = base16_colors['base0C']
    blue = base16_colors['base0D']  # Primary accent
    purple = base16_colors['base0E']
    brown = base16_colors['base0F']
    
    # Determine if dark mode based on background lightness
    bg_r, bg_g, bg_b = hex_to_rgb(bg)
    _, _, bg_lightness = rgb_to_hsl(bg_r, bg_g, bg_b)
    is_dark = bg_lightness < 0.5
    
    # Generate surface containers (graduated lightness from background)
    if is_dark:
        surface_dim = adjust_lightness(bg, max(0.02, bg_lightness - 0.02))
        surface = bg
        surface_bright = adjust_lightness(bg, min(0.25, bg_lightness + 0.12))
        surface_container_lowest = adjust_lightness(bg, max(0.01, bg_lightness - 0.03))
        surface_container_low = adjust_lightness(bg, bg_lightness + 0.02)
        surface_container = adjust_lightness(bg, bg_lightness + 0.04)
        surface_container_high = adjust_lightness(bg, bg_lightness + 0.06)
        surface_container_highest = adjust_lightness(bg, bg_lightness + 0.09)
    else:
        surface_dim = adjust_lightness(bg, bg_lightness - 0.05)
        surface = bg
        surface_bright = adjust_lightness(bg, min(0.98, bg_lightness + 0.05))
        surface_container_lowest = adjust_lightness(bg, min(0.99, bg_lightness + 0.02))
        surface_container_low = adjust_lightness(bg, bg_lightness - 0.02)
        surface_container = adjust_lightness(bg, bg_lightness - 0.04)
        surface_container_high = adjust_lightness(bg, bg_lightness - 0.06)
        surface_container_highest = adjust_lightness(bg, bg_lightness - 0.09)
    
    # Primary color variations
    primary = blue
    primary_r, primary_g, primary_b = hex_to_rgb(primary)
    primary_h, primary_s, primary_l = rgb_to_hsl(primary_r, primary_g, primary_b)
    
    if is_dark:
        on_primary = adjust_lightness(primary, 0.15)
        primary_container = adjust_lightness(primary, 0.20)
        on_primary_container = adjust_lightness(primary, 0.85)
    else:
        on_primary = adjust_lightness(primary, 0.95)
        primary_container = adjust_lightness(primary, 0.85)
        on_primary_container = adjust_lightness(primary, 0.15)
    
    # Secondary from purple/cyan mix
    secondary = mix_colors(purple, cyan, 0.5)
    secondary_r, secondary_g, secondary_b = hex_to_rgb(secondary)
    secondary_h, secondary_s, secondary_l = rgb_to_hsl(secondary_r, secondary_g, secondary_b)
    
    if is_dark:
        on_secondary = adjust_lightness(secondary, 0.15)
        secondary_container = adjust_lightness(secondary, 0.25)
        on_secondary_container = adjust_lightness(secondary, 0.85)
    else:
        on_secondary = adjust_lightness(secondary, 0.95)
        secondary_container = adjust_lightness(secondary, 0.85)
        on_secondary_container = adjust_lightness(secondary, 0.15)
    
    # Tertiary from green
    tertiary = green
    if is_dark:
        on_tertiary = adjust_lightness(tertiary, 0.15)
        tertiary_container = adjust_lightness(tertiary, 0.20)
        on_tertiary_container = adjust_lightness(tertiary, 0.85)
    else:
        on_tertiary = adjust_lightness(tertiary, 0.95)
        tertiary_container = adjust_lightness(tertiary, 0.85)
        on_tertiary_container = adjust_lightness(tertiary, 0.15)
    
    # Error colors
    error = red
    if is_dark:
        on_error = adjust_lightness(error, 0.10)
        error_container = adjust_lightness(error, 0.20)
        on_error_container = adjust_lightness(error, 0.90)
    else:
        on_error = adjust_lightness(error, 0.95)
        error_container = adjust_lightness(error, 0.90)
        on_error_container = adjust_lightness(error, 0.10)
    
    # Success colors (from green)
    success = green
    if is_dark:
        on_success = adjust_lightness(success, 0.15)
        success_container = adjust_lightness(success, 0.25)
        on_success_container = adjust_lightness(success, 0.90)
    else:
        on_success = adjust_lightness(success, 0.95)
        success_container = adjust_lightness(success, 0.85)
        on_success_container = adjust_lightness(success, 0.10)
    
    # Surface/outline colors
    on_surface = fg
    on_surface_variant = comments if not is_dark else fg_dark
    surface_variant = selection
    outline = comments
    outline_variant = selection
    
    # Inverse colors
    if is_dark:
        inverse_surface = fg
        inverse_on_surface = bg
        inverse_primary = adjust_lightness(primary, 0.35)
    else:
        inverse_surface = adjust_lightness(bg, 0.15)
        inverse_on_surface = fg
        inverse_primary = adjust_lightness(primary, 0.75)
    
    # Fixed colors (always same regardless of light/dark)
    primary_fixed = adjust_lightness(primary, 0.85)
    primary_fixed_dim = adjust_lightness(primary, 0.75)
    on_primary_fixed = adjust_lightness(primary, 0.10)
    on_primary_fixed_variant = adjust_lightness(primary, 0.25)
    
    secondary_fixed = adjust_lightness(secondary, 0.85)
    secondary_fixed_dim = adjust_lightness(secondary, 0.75)
    on_secondary_fixed = adjust_lightness(secondary, 0.10)
    on_secondary_fixed_variant = adjust_lightness(secondary, 0.25)
    
    tertiary_fixed = adjust_lightness(tertiary, 0.85)
    tertiary_fixed_dim = adjust_lightness(tertiary, 0.75)
    on_tertiary_fixed = adjust_lightness(tertiary, 0.10)
    on_tertiary_fixed_variant = adjust_lightness(tertiary, 0.25)
    
    # Terminal colors (keep close to original base16)
    colors = {
        "background": bg,
        "on_background": fg,
        "surface": surface,
        "surface_dim": surface_dim,
        "surface_bright": surface_bright,
        "surface_container_lowest": surface_container_lowest,
        "surface_container_low": surface_container_low,
        "surface_container": surface_container,
        "surface_container_high": surface_container_high,
        "surface_container_highest": surface_container_highest,
        "on_surface": on_surface,
        "surface_variant": surface_variant,
        "on_surface_variant": on_surface_variant,
        "inverse_surface": inverse_surface,
        "inverse_on_surface": inverse_on_surface,
        "outline": outline,
        "outline_variant": outline_variant,
        "shadow": "#000000",
        "scrim": "#000000",
        "surface_tint": primary,
        "primary": primary,
        "on_primary": on_primary,
        "primary_container": primary_container,
        "on_primary_container": on_primary_container,
        "inverse_primary": inverse_primary,
        "secondary": secondary,
        "on_secondary": on_secondary,
        "secondary_container": secondary_container,
        "on_secondary_container": on_secondary_container,
        "tertiary": tertiary,
        "on_tertiary": on_tertiary,
        "tertiary_container": tertiary_container,
        "on_tertiary_container": on_tertiary_container,
        "error": error,
        "on_error": on_error,
        "error_container": error_container,
        "on_error_container": on_error_container,
        "primary_fixed": primary_fixed,
        "primary_fixed_dim": primary_fixed_dim,
        "on_primary_fixed": on_primary_fixed,
        "on_primary_fixed_variant": on_primary_fixed_variant,
        "secondary_fixed": secondary_fixed,
        "secondary_fixed_dim": secondary_fixed_dim,
        "on_secondary_fixed": on_secondary_fixed,
        "on_secondary_fixed_variant": on_secondary_fixed_variant,
        "tertiary_fixed": tertiary_fixed,
        "tertiary_fixed_dim": tertiary_fixed_dim,
        "on_tertiary_fixed": on_tertiary_fixed,
        "on_tertiary_fixed_variant": on_tertiary_fixed_variant,
        "success": success,
        "on_success": on_success,
        "success_container": success_container,
        "on_success_container": on_success_container,
        # Note: Terminal colors (term0-term15) are NOT included here because
        # MaterialThemeLoader.qml adds "m3" prefix to all keys, but Appearance.qml
        # expects terminal colors WITHOUT the m3 prefix (e.g., "term0" not "m3term0")
    }
    
    return colors

def main():
    if len(sys.argv) < 2:
        print("Usage: generate-colors.py <output-path>", file=sys.stderr)
        print("Base16 colors should be passed via environment variables BASE00-BASE0F", file=sys.stderr)
        sys.exit(1)
    
    import os
    
    # Read base16 colors from environment
    base16_colors = {}
    for i in range(16):
        # Generate both the environment variable name and the dict key
        if i < 10:
            env_key = f"BASE0{i}"
            dict_key = f"base0{i}"
        else:
            hex_char = chr(ord('A') + i - 10)
            env_key = f"BASE0{hex_char}"
            dict_key = f"base0{hex_char}"
        
        color = os.environ.get(env_key)
        if not color:
            print(f"Missing environment variable: {env_key}", file=sys.stderr)
            sys.exit(1)
        base16_colors[dict_key] = f"#{color}" if not color.startswith('#') else color
    
    colors = generate_material_colors(base16_colors)
    
    output_path = sys.argv[1]
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, 'w') as f:
        json.dump(colors, f, indent=2)
    
    print(f"Generated colors at {output_path}")

if __name__ == "__main__":
    main()
