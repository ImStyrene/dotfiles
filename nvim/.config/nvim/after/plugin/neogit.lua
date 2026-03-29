vim.keymap.set("n", "<leader>gs", function()
  require("neogit").open()
end, { noremap = true, silent = true })
