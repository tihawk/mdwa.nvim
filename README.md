<p align="center">
  <h1 align="center">mdwa.nvim</h2>
</p>

<p align="center">
    > A plugin to force you to write continusouly for a few minutes, lest you lose it all.
</p>

<div align="center">
 <img width="600" alt="A GIF demo" src="./.vhs/demo.gif">
</div>

## Features

Get over a writing block by forcing yourself to write non-stop for a set amount of time.

Just open your Neovim, and run the command `:Mdwa` to start a default 3-minute writing session, whereas if you stop writing for 5 seconds, you will lose what you've written so far!

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
  use_tabs = true, -- If you're like me, and dislike tabs, you can make the MDWA session start in the same tab you're on, by setting this to false.
})
```

## Commands

- `:Mdwa [duration]` - Creates a new writing session. Takes an optional argument `duration` for the duration of the session in minutes. It can take floating point numbers as well, like `1.5` for a minute and a half.

## Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## Motivations

This plugin is based on The Most Dangerous Writing App. The original version of the code for the plugin can be found [here](https://github.com/GitMurf/nvim-code-to-share/tree/main/mdwa).

For building the plugin, I used [a boilerplate by shortcuts](https://github.com/shortcuts/neovim-plugin-boilerplate).
