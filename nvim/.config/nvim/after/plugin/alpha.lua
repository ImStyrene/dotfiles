local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local button = dashboard.button

-- ASCII art header
dashboard.section.header.val = [[








 .::::::.::::::::::::.-:.     ::-.:::      .::.:::.        :   
;;;`    `;;;;;;;;'''' ';;.   ;;;;'';;,   ,;;;' ;;;;;,.    ;;;  
'[==/[[[[,    [[        '[[,[[['   \[[  .[[/   [[[[[[[, ,[[[[, 
  '''    $    $$          c$$"      Y$c.$$"    $$$$$$$$$$$"$$$ 
 88b    dP    88,       ,8P"`        Y88P      888888 Y88" 888o
  "YMmMY"     MMM      mM"            MP       MMMMMM  M'  "MMM
]]

dashboard.section.buttons.val = {
  button("e", " New file", ":ene <BAR> startinsert <CR>"),
  button("f", " Find file", ":Telescope find_files<CR>"),
  button("p", " Packer", ":Packer<CR>"),
  button("m", " Mason", ":Mason<CR>"),
  button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
