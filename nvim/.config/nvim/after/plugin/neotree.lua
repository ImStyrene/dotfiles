vim.keymap.set("n", "<leader>e", function()
  vim.cmd("Neotree toggle")
end, { noremap = true, silent = true })

require("neo-tree").setup({
  filesystem = {
    follow_current_file = true,
    hijack_netrw_behavior = "open_current",
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
  },
})
