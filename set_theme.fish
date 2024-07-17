#!/usr/bin/env fish

# Function to set the Kitty terminal theme
function setKittyTheme
    set -l theme $argv[1]
    if test "$theme" = dark
        set kitty_theme Catppuccin-mocha
    else
        set kitty_theme Catppuccin-latte
    end
    echo "Setting Kitty theme to $kitty_theme"
    kitty +kitten themes --reload-in=all --config-file-name themes.conf "$kitty_theme"
    echo "Kitty theme set to $kitty_theme"
end

# Function to set the Neovim theme
function setNeovimTheme
    set -l theme $argv[1]
    if test "$theme" = dark
        set nvim_theme catppuccin-mocha
    else
        set nvim_theme catppuccin-latte
    end
    echo "Setting Neovim theme to $nvim_theme"

    # Set theme for all open Neovim instances
    set servers (nvr --serverlist)
    if test -n "$servers"
        echo "Found Neovim servers: $servers"
        for server in $servers
            echo "Setting theme for Neovim server: $server"
            nvr --servername "$server" +"colorscheme $nvim_theme"
        end
    else
        echo "No Neovim servers found"
    end

    # Update the theme in Neovim configuration file
    sed -E -i '' 's/colorscheme = "[^"]*"/colorscheme = "'"$nvim_theme"'"/g' ~/.config/nvim/lua/plugins/colorscheme.lua
    echo "Neovim config updated with theme $nvim_theme"
end

# Function to set the Fzf theme
function setFzfTheme
    set -l theme $argv[1]
    echo "Setting Fzf theme to $theme for Fish"

    if test "$theme" = dark
        set -Ux FZF_DEFAULT_OPTS " \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
        echo "Fzf theme set to dark"
    else
        set -Ux FZF_DEFAULT_OPTS " \
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
        echo "Fzf theme set to light"
    end
end

# Function to set the Tmux theme
function setTmuxTheme
    set -l theme $argv[1]
    if test "$theme" = dark
        set tmux_theme mocha
    else
        set tmux_theme latte
    end
    echo "Setting Tmux theme to $tmux_theme"
    sed -E -i '' 's/set -g @catppuccin_flavour "[^"]*"/set -g @catppuccin_flavour "'"$tmux_theme"'"/g' ~/.tmux.conf
    tmux source-file ~/.tmux.conf
    echo "Tmux theme set to $tmux_theme"
end

# Check the value of DARKMODE and set the theme variable
echo "Checking DARKMODE value: $DARKMODE"
if test "$DARKMODE" -eq 0
    set theme light
else if test "$DARKMODE" -eq 1
    set theme dark
else
    echo "DARKMODE is not set or has an unexpected value: $DARKMODE"
    exit 1
end

# Export the theme variable to make it available to other scripts or commands
set -gx theme $theme

# Print the theme variable to confirm the correct value is set
echo "The theme is set to $theme"

# Call the functions to set the themes
setKittyTheme $theme
setNeovimTheme $theme
setFzfTheme $theme
setTmuxTheme $theme

echo "All themes have been set successfully for Fish."
