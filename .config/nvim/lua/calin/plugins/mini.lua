require('mini.comment').setup()
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none(),
  }
})

require('mini.pairs').setup()
require('mini.tabline').setup()
-- Highight word under cursor
require('mini.cursorword').setup()
