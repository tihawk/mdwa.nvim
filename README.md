<p align="center">
  <h1 align="center">mdwa.nvim</h2>
</p>

<p align="center">
    > A plugin to force you to write continusouly for a few minutes, lest you lose it all.
</p>

<div align="center">
    > Drag your video (<10MB) here to host it for free on GitHub.
</div>

<div align="center">

> Videos don't work on GitHub mobile, so a GIF alternative can help users.

_[GIF version of the showcase video for mobile users](SHOWCASE_GIF_LINK)_

</div>

## ⚡️ Features

> Write short sentences describing your plugin features

- FEATURE 1
- FEATURE ..
- FEATURE N

## 📋 Installation

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

## ☄ Getting started

> Describe how to use the plugin the simplest way

## ⚙ Configuration

> The configuration list sometimes become cumbersome, making it folded by default reduce the noise of the README file.

<details>
<summary>Click to unfold the full list of options with their default values</summary>

> **Note**: The options are also available in Neovim by calling `:h mdwa.options`

```lua
require("mdwa").setup({
  debug = false,
  default_duration = 180, -- 3 minutes in seconds.
  max_inactivity = 5, -- 5 seconds of inactivity equals losing.
  use_tabs = true, -- If you're like me, and dislike tabs, you can make the MDWA session start in the same tab you're on, by setting this to false.
})
```

</details>

## 🧰 Commands

|   Command            |         Description        |
|----------------------|----------------------------|
|  `:Mdwa [duration]`  |     Starts a new session.  |

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 🎭 Motivations

This plugin is based on The Most Dangerous Writing App. The original version of the code for the plugin can be found [here](https://github.com/GitMurf/nvim-code-to-share/tree/main/mdwa).

For building the plugin, I used [a boilerplate by shortcuts](https://github.com/shortcuts/neovim-plugin-boilerplate).
