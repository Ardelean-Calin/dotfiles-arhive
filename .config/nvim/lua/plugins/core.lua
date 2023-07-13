return {
  {
    "simrat39/rust-tools.nvim",
    opts = {
      tools = {
        inlay_hints = {
          auto = true,
          only_current_line = false,
          show_parameter_hints = true,
        },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "stylua",
        "nil",
        "shfmt",
        "bash-language-server",
        "lua-language-server",
      },
    },
  },
}
