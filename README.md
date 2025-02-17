<p align="center">
  <h1 align="center">mdwa.nvim</h2>
</p>

<p align="center">
    > A plugin to force you to write continuously for a few minutes, lest you lose it all.
</p>

<div align="center">
 <img width="600" alt="A GIF demo" src="./.vhs/demo.gif">
</div>

## Features

Get over a writing block by forcing yourself to write non-stop for a set amount of time.

Just open your Neovim, and run the command `:Mdwa` to start a default 3-minute writing session, wherein if you stop writing for 5 seconds, you will lose what you've written so far!

Start a writing session with a custom duration, by providing the duration in minutes as an argument to the command, e.g. `:Mdwa 5` for a 5-minute session.

After you finish your session, if you want to keep what you've written, you can just save the buffer content before quitting with `:wq <filename>`.

The writing session buffer is formatted as markdown, btw.

## Installation

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>Snippet</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

</td>
<td>

```lua
-- stable version
use {"tihawk/mdwa.nvim", tag = "*" }
-- dev version
use {"tihawk/mdwa.nvim"}
```

</td>
</tr>
<tr>
<td>

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

</td>
<td>

```lua
-- stable version
Plug "tihawk/mdwa.nvim", { "tag": "*" }
-- dev version
Plug "tihawk/mdwa.nvim"
```

</td>
</tr>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
-- stable version
require("lazy").setup({{"tihawk/mdwa.nvim", version = "*"}})
-- dev version
require("lazy").setup({"tihawk/mdwa.nvim"})
```

</td>
</tr>
</tbody>
</table>
</div>

## Getting started

- Install using your favourite package manager from the [Installation](#installation) section.
- Optionally, configure by using the configuration settings from the [Configuration](#configuration) section.
- After starting Neovim, you should have the `:Mdwa` command available, to start a new writing session with a default duration of 3 minutes.
- You can provide a custom duration for a new session, e.g. `:Mdwa 2` for a 2-minute session.
- Start writing!
- Keep writing! If you stop writing for 5 seconds (also configurable), you will lose everything you've written so far!

## Configuration

> **Note**: The options are also available in Neovim by calling `:h mdwa.options`

```lua
require("mdwa").setup({
  debug = false,
  default_duration = 180, -- 3 minutes in seconds.
  max_inactivity = 5, -- 5 seconds of inactivity equals losing.
  -- If you're like me, and dislike tabs, you can make the MDWA session start in the same tab you're on, by setting this to false.
  use_tabs = true,
  colors = {
    -- Colours appearing during inactivity, progressing from right to left
    bad = { "#ff0033", "#e5002d", "#cc0028", "#b20023", "#7f0019", },
    -- Colour for successfully completing the writing session
    good = "#3b474a",
  },
  symbols = {
    -- Symbol for the empty portion of the progress bar
    empty_bar = "░",
    -- Symbol for the filled portion of the progress bar
    filled_bar = "█",
  },
})
```

## Commands

- `:Mdwa [duration]` - Creates a new writing session. Takes an optional argument `duration` for the duration of the session in minutes. It can take floating point numbers as well, like `1.5` for a minute and a half.

## Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## Motivations

This plugin is directly inspired by [The Most Dangerous Writing App](https://github.com/maebert/themostdangerouswritingapp), a web app which is now [owned by Squibler](https://www.squibler.io/dangerous-writing-prompt-app).

I wanted to have this integrated in Neovim, so I decided to write a plugin for it. I used the code provided [here](https://github.com/GitMurf/nvim-code-to-share/tree/main/mdwa) as a starting point, and to learn more about the Neovim API.

For building the plugin, I used [a boilerplate by shortcuts](https://github.com/shortcuts/neovim-plugin-boilerplate).
