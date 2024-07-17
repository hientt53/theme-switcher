# ThemeSwitcher

ThemeSwitcher is a tool that automatically sets the themes for Kitty terminal, Neovim, Tmux, and Fzf based on the system’s dark mode setting. It supports both Bash and Fish shells.

## Features

    • Automatically switches themes based on macOS dark mode.
    • Supports Kitty terminal, Neovim, Tmux, and Fzf.
    • Works with both Bash and Fish shells.
    • Allows specifying a custom launch path for executing scripts.

## Prerequisites

    • macOS
    • Swift
    • Kitty terminal
    • Neovim
    • Fzf
    • nvr (Neovim remote plugin)

## Dependencies

Neovim

nvim-remote (aka nvr) is used for controlling the Neovim instances.

Kitty

For Kitty to receive remote commands, you’ll need to update your config to have:

```sh
allow_remote_control true
```

Kitty / Tmux

If you’re using Kitty with Tmux, you’ll need to explicitly set the socket that Kitty listens on, since if you run the command from within Tmux, Kitty won’t pick up on it.

How you do this depends on how you start Kitty.

If you’re starting it from the application icon, you need to set the launch arguments in your Kitty config folder. For example, in `~/.config/kitty/macos-launch-services-cmdline` I have:

```
--listen-on unix:/tmp/kitty
```

Note: If you don’t open Kitty directly from the application (for example, if you’re using Raycast), then it won’t pick up these launch arguments.

Note: I haven’t tested this with more than one Kitty window.

## Installation

1. Clone the repository:
2. Build the Swift program:

```sh
make instal
```

## Usage

Once the program is running, it will automatically adjust your themes based on the system’s dark mode setting.

You can also specify a custom launch path using the --launch-path parameter.

Without --launch-path (defaults to /usr/bin/env):

```sh
theme-switcher <script_path>
```

With --launch-path:

```sh
theme-switcher <script_path> --launch-path /bin/bash
```

## Autostart

Move the plist file to the appropriate location:

```sh
mv com.example.theme-switcher.plist ~/Library/LaunchAgents/
```

Load the plist file:

```sh
launchctl load ~/Library/LaunchAgents/com.example.theme-switcher.plist
```

Remove program

```sh
launchctl unload ~/Library/LaunchAgents/com.example.theme-switcher.plist
```

The initial Swift code for detecting dark mode changes was inspired by bouk’s [dark-mode-notify](https://github.com/bouk/dark-mode-notify).
