#!/bin/bash

# Generate Neovim theme (dark & light) from current macOS wallpaper
# Requires: peachy, osascript (macOS)

set -e

THEME_BASE="wallpaper-theme"
OUTPUT_FILE="$HOME/.config/nvim/lua/plugins/$THEME_BASE.lua"
GHOSTTY_CONFIG_DIR="${GHOSTTY_CONFIG_DIR:-$HOME/Library/Application Support/com.mitchellh.ghostty}"
GHOSTTY_THEME_DIR="$GHOSTTY_CONFIG_DIR/themes"
GHOSTTY_DARK_THEME_FILE="$GHOSTTY_THEME_DIR/$THEME_BASE-dark"
GHOSTTY_LIGHT_THEME_FILE="$GHOSTTY_THEME_DIR/$THEME_BASE-light"

# Peachy's generated light background can be too saturated/"hard" for editing.
# Soften it by blending only the light-mode backgrounds toward white.
# Override per run, e.g. LIGHT_BG_WHITE_MIX=92 ./generate-wallpaper-theme.sh
SOFTEN_LIGHT_BG=${SOFTEN_LIGHT_BG:-1}
LIGHT_BG_WHITE_MIX=${LIGHT_BG_WHITE_MIX:-88}
LIGHT_BGHL_WHITE_MIX=${LIGHT_BGHL_WHITE_MIX:-78}

blend_with_white() {
    local color="${1#\#}"
    local white_mix="$2"
    local color_mix=$((100 - white_mix))

    local r=$((16#${color:0:2}))
    local g=$((16#${color:2:2}))
    local b=$((16#${color:4:2}))

    printf "#%02X%02X%02X" \
        $(((r * color_mix + 255 * white_mix) / 100)) \
        $(((g * color_mix + 255 * white_mix) / 100)) \
        $(((b * color_mix + 255 * white_mix) / 100))
}

write_ghostty_theme() {
    local output_file="$1"
    local bg="$2"
    local fg="$3"
    local bg_highlight="$4"
    local comment="$5"
    local red="$6"
    local orange="$7"
    local yellow="$8"
    local green="$9"
    local cyan="${10}"
    local blue="${11}"
    local purple="${12}"
    local magenta="${13}"

    cat > "$output_file" << GHOSTTYTHEME
palette = 0=$bg
palette = 1=$red
palette = 2=$green
palette = 3=$yellow
palette = 4=$blue
palette = 5=$magenta
palette = 6=$cyan
palette = 7=$fg
palette = 8=$comment
palette = 9=$red
palette = 10=$green
palette = 11=$orange
palette = 12=$blue
palette = 13=$purple
palette = 14=$cyan
palette = 15=$fg
background = $bg
foreground = $fg
cursor-color = $fg
cursor-text = $bg
selection-background = $bg_highlight
selection-foreground = $fg
GHOSTTYTHEME
}

# Get current wallpaper path
WALLPAPER_PATH=$(osascript -e 'tell app "Finder" to get posix path of (get desktop picture as alias)' 2>/dev/null)

if [ -z "$WALLPAPER_PATH" ]; then
    echo "Error: Could not get wallpaper path. Make sure Finder is running."
    exit 1
fi

if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpaper file not found: $WALLPAPER_PATH"
    exit 1
fi

echo "󰈔 Found wallpaper: $WALLPAPER_PATH"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Generate DARK variant
echo "󰐊 Generating DARK variant..."
peachy delete "$THEME_BASE-dark" 2>/dev/null || true
peachy generate "$WALLPAPER_PATH" --save "$THEME_BASE-dark" --no-apply
peachy export "$THEME_BASE-dark" "$TEMP_DIR/dark"

# Generate LIGHT variant  
echo "󰐊 Generating LIGHT variant..."
peachy delete "$THEME_BASE-light" 2>/dev/null || true
peachy generate "$WALLPAPER_PATH" --light --save "$THEME_BASE-light" --no-apply
peachy export "$THEME_BASE-light" "$TEMP_DIR/light"

echo "󰈙 Creating toggleable Neovim config..."
mkdir -p "$HOME/.config/nvim/lua/plugins"

# Extract colors from both variants and create combined config
cat > "$OUTPUT_FILE" << 'LUACONFIG'
-- Auto-generated from current macOS wallpaper
-- Supports both dark and light modes, toggle with <leader>ub

local function get_colors()
  local is_dark = vim.o.background == "dark"
  
  if is_dark then
    -- DARK variant colors
    return {
      bg = "BGDARK",
      bg_dark = "BGDARK",
      bg_highlight = "BGHLDARK",
      fg = "FGDARK",
      fg_dark = "FGDARK",
      comment = "COMMDARK",
      red = "REDDARK",
      orange = "ORANGEDARK",
      yellow = "YELLOWDARK",
      green = "GREENDARK",
      cyan = "CYANDARK",
      blue = "BLUEDARK",
      purple = "PURPLEDARK",
      magenta = "MAGENTADARK",
    }
  else
    -- LIGHT variant colors
    return {
      bg = "BGLIGHT",
      bg_dark = "BGLIGHT",
      bg_highlight = "BGHLLIGHT",
      fg = "FGLIGHT",
      fg_dark = "FGLIGHT",
      comment = "COMMLIGHT",
      red = "REDLIGHT",
      orange = "ORANGELIGHT",
      yellow = "YELLOWLIGHT",
      green = "GREENLIGHT",
      cyan = "CYANLIGHT",
      blue = "BLUELIGHT",
      purple = "PURPLELIGHT",
      magenta = "MAGENTALIGHT",
    }
  end
end

local separator_groups = {
  "WinSeparator",
  "VertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeTabSeparatorActive",
  "NeoTreeTabSeparatorInactive",
  "NvimTreeWinSeparator",
  "DiffviewWinSeparator",
}

local function apply_separators(colors)
  -- Match rose-pine's approach: use the muted/comment tone as a visible but subtle border.
  -- Aether derives its default border from bg, which can make split separators disappear.
  local separator = colors.comment or colors.bg_highlight

  for _, group in ipairs(separator_groups) do
    vim.api.nvim_set_hl(0, group, { fg = separator, bg = colors.bg })
  end
end

local function apply_theme()
  local colors = get_colors()

  require("aether").setup({
    transparent = false,
    colors = colors,
  })
  vim.cmd.colorscheme("aether")
  apply_separators(colors)
end

return {
  {
    "bjarneo/aether.nvim",
    branch = "v2",
    name = "aether",
    priority = 1000,
    opts = {},
    config = function(_, _)
      -- Initial apply
      apply_theme()
      
      -- Listen for background changes (triggered by <leader>ub)
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = apply_theme,
      })
      
      -- Enable hot reload
      require("aether.hotreload").setup()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
LUACONFIG

# Extract colors from dark variant
DARK_BG=$(grep -o 'bg = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | head -1 | sed 's/.*"\(#.*\)".*/\1/')
DARK_FG=$(grep -o 'fg = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | head -1 | sed 's/.*"\(#.*\)".*/\1/')
DARK_BGHL=$(grep -o 'bg_highlight = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_COMMENT=$(grep -o 'comment = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_RED=$(grep -o 'red = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_ORANGE=$(grep -o 'orange = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_YELLOW=$(grep -o 'yellow = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_GREEN=$(grep -o 'green = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_CYAN=$(grep -o 'cyan = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_BLUE=$(grep -o 'blue = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_PURPLE=$(grep -o 'purple = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
DARK_MAGENTA=$(grep -o 'magenta = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/dark/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')

# Extract colors from light variant
LIGHT_BG=$(grep -o 'bg = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | head -1 | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_FG=$(grep -o 'fg = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | head -1 | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_BGHL=$(grep -o 'bg_highlight = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_COMMENT=$(grep -o 'comment = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_RED=$(grep -o 'red = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_ORANGE=$(grep -o 'orange = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_YELLOW=$(grep -o 'yellow = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_GREEN=$(grep -o 'green = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_CYAN=$(grep -o 'cyan = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_BLUE=$(grep -o 'blue = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_PURPLE=$(grep -o 'purple = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')
LIGHT_MAGENTA=$(grep -o 'magenta = "#[0-9A-Fa-f]\{6\}"' "$TEMP_DIR/light/neovim.lua" | sed 's/.*"\(#.*\)".*/\1/')

RAW_LIGHT_BG="$LIGHT_BG"
RAW_LIGHT_BGHL="$LIGHT_BGHL"
if [ "$SOFTEN_LIGHT_BG" != "0" ]; then
    LIGHT_BG=$(blend_with_white "$LIGHT_BG" "$LIGHT_BG_WHITE_MIX")
    LIGHT_BGHL=$(blend_with_white "$LIGHT_BGHL" "$LIGHT_BGHL_WHITE_MIX")
fi

# Replace placeholders with actual colors
sed -i '' \
  -e "s/BGDARK/$DARK_BG/g" \
  -e "s/BGHLDARK/$DARK_BGHL/g" \
  -e "s/FGDARK/$DARK_FG/g" \
  -e "s/COMMDARK/$DARK_COMMENT/g" \
  -e "s/REDDARK/$DARK_RED/g" \
  -e "s/ORANGEDARK/$DARK_ORANGE/g" \
  -e "s/YELLOWDARK/$DARK_YELLOW/g" \
  -e "s/GREENDARK/$DARK_GREEN/g" \
  -e "s/CYANDARK/$DARK_CYAN/g" \
  -e "s/BLUEDARK/$DARK_BLUE/g" \
  -e "s/PURPLEDARK/$DARK_PURPLE/g" \
  -e "s/MAGENTADARK/$DARK_MAGENTA/g" \
  -e "s/BGLIGHT/$LIGHT_BG/g" \
  -e "s/BGHLLIGHT/$LIGHT_BGHL/g" \
  -e "s/FGLIGHT/$LIGHT_FG/g" \
  -e "s/COMMLIGHT/$LIGHT_COMMENT/g" \
  -e "s/REDLIGHT/$LIGHT_RED/g" \
  -e "s/ORANGELIGHT/$LIGHT_ORANGE/g" \
  -e "s/YELLOWLIGHT/$LIGHT_YELLOW/g" \
  -e "s/GREENLIGHT/$LIGHT_GREEN/g" \
  -e "s/CYANLIGHT/$LIGHT_CYAN/g" \
  -e "s/BLUELIGHT/$LIGHT_BLUE/g" \
  -e "s/PURPLELIGHT/$LIGHT_PURPLE/g" \
  -e "s/MAGENTALIGHT/$LIGHT_MAGENTA/g" \
  "$OUTPUT_FILE"

mkdir -p "$GHOSTTY_THEME_DIR"
write_ghostty_theme \
  "$GHOSTTY_DARK_THEME_FILE" \
  "$DARK_BG" \
  "$DARK_FG" \
  "$DARK_BGHL" \
  "$DARK_COMMENT" \
  "$DARK_RED" \
  "$DARK_ORANGE" \
  "$DARK_YELLOW" \
  "$DARK_GREEN" \
  "$DARK_CYAN" \
  "$DARK_BLUE" \
  "$DARK_PURPLE" \
  "$DARK_MAGENTA"
write_ghostty_theme \
  "$GHOSTTY_LIGHT_THEME_FILE" \
  "$LIGHT_BG" \
  "$LIGHT_FG" \
  "$LIGHT_BGHL" \
  "$LIGHT_COMMENT" \
  "$LIGHT_RED" \
  "$LIGHT_ORANGE" \
  "$LIGHT_YELLOW" \
  "$LIGHT_GREEN" \
  "$LIGHT_CYAN" \
  "$LIGHT_BLUE" \
  "$LIGHT_PURPLE" \
  "$LIGHT_MAGENTA"

echo ""
echo "󰄴 Theme generated successfully!"
echo "󰈔 Neovim file: $OUTPUT_FILE"
echo "󰈔 Ghostty dark theme: $GHOSTTY_DARK_THEME_FILE"
echo "󰈔 Ghostty light theme: $GHOSTTY_LIGHT_THEME_FILE"
echo ""
echo "󰌓 Variants:"
echo "  󰌵 Dark BG: $DARK_BG | FG: $DARK_FG"
if [ "$SOFTEN_LIGHT_BG" != "0" ]; then
  echo "  󰌵 Light BG: $LIGHT_BG | FG: $LIGHT_FG (softened from $RAW_LIGHT_BG; bg_highlight $RAW_LIGHT_BGHL -> $LIGHT_BGHL)"
else
  echo "  󰌵 Light BG: $LIGHT_BG | FG: $LIGHT_FG"
fi
echo ""
echo "Neovim: toggle with <leader>ub (or :set background=light/dark)"
echo "Neovim: restart or run :Lazy reload aether to apply"
echo "Ghostty: add this to $GHOSTTY_CONFIG_DIR/config to use both variants:"
echo "  theme = dark:$THEME_BASE-dark,light:$THEME_BASE-light"
