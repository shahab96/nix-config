return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    float_opts = {
      border = "curved",
    },
    size = function(term)
      if term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.5)
      elseif term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.35)
      end
    end,
    persist_size = false,
  },
}