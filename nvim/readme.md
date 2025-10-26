# [Neovim](https://neovim.io)

Opinionated configurations for [LazyVim](https://www.lazyvim.org/), a powerful system for configuring the neovim editor.

## `lua/plugins/completions.lua`

Remove all but LSP symbols from completions

```lua
return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { "lsp" },
      transform_items = function(_, items)
        return vim.tbl_filter(function(item)
          local kind = require("blink.cmp.types").CompletionItemKind[item.kind]
          return kind ~= "Text" and kind ~= "Snippet" and kind ~= "Macro"
        end, items)
      end,
    },
  },
}
```

## `lua/plugins/disabled.lua`

Disable the `mini.ai` plugin from `nvim-mini`.

```lua
return {
  {
    "nvim-mini/mini.ai",
    enabled = false,
  },
}
```

## `lua/plugins/lsp.lua`

Disable concealing symbols when rendering Markdown.

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
  },
}
```

## `lua/plugins/pairs.lua`

Disable `'` and `` ` `` from generating pairs. A single `'` is used to express lifetimes in Rust. Disabling `` ` `` prevents auto-generating closing code blocks in Markdown.

```lua
return {
  "nvim-mini/mini.pairs",
  opts = {
    mappings = {
      ["'"] = false,
      ["`"] = false,
    },
  },
}
```
