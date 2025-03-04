# memo.nvim
This plugin allows you to quickly take notes from anywhere within Neovim with **floating window**.

![](./docs/images/note.png)


## Installation

### Lazy
```lua
require("lazy").setup({
  {
    "tetsuya28/memo.nvim",
  }
})

require("memo").setup({})
```

## Settings
### Default settings
- Memo directory: `~/memos/`
  - Planning to make this configurable in future releases.

## Usage
- `:MemoNew` - Open memo ( default title is current datetime )
  - `:MemoNew <title>` - Open memo with title
- `:MemoOpen <title>` - Open memo with title
![](./docs/images/open.png)
