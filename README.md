# memo.nvim
This plugin allows you to quickly take notes from anywhere within Neovim. Whether you're coding, reading documentation, or browsing files, you can instantly capture your thoughts without disrupting your workflow. With simple keybindings, you can open a note-taking buffer, save your notes, and access them later - all without leaving your editor.

![](./docs/images/note.png)


## Installation

### Lazy
```
require("lazy").setup({
	{
		"tetsuya28/memo.nvim",
	}
})

require("memo").setup({})
```

## Usage
- `:MemoNew` - Open memo
  - `:MemoNew <title>` - Open memo with title
- `:MemoOpen <title>` - Open memo with title
