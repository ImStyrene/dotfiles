{ config, lib, pkgs, ... }:

{
  plugins.dashboard = {
    enable = true;
    settings = {
      theme = "doom";
      config = {
	header = [
	  ""
	  ""
	  ""
	  "                                                                  "
	  "                                                                  "
	  "   _..._   .--.             .----.     .----..--. __  __   ___    "
	  " .'     '. |__|              \\    \\   /    / |__||  |/  `.'   `.  "
	  ".   .-.   ..--.               '   '. /'   /  .--.|   .-.  .-.   ' "
	  "|  '   '  ||  | ____     _____|    |'    /   |  ||  |  |  |  |  | "
	  "|  |   |  ||  |`.   \\  .'    /|    ||    |   |  ||  |  |  |  |  | "
	  "|  |   |  ||  |  `.  `'    .' '.   `'   .'   |  ||  |  |  |  |  | "
	  "|  |   |  ||  |    '.    .'    \\        /    |  ||  |  |  |  |  | "
	  "|  |   |  ||__|    .'     `.    \\      /     |__||__|  |__|  |__| "
	  "|  |   |  |      .'  .'`.   `.   '----'                           "
	  "|  |   |  |    .'   /    `.   `.                                  "
	  "'--'   '--'   '----'       '----'                                 "
	  ""
	  ""
	  ""
	];
	center = [
	  {
	    icon = "󰈔 ";
	    icon_hl = "Title";
	    desc = "New File";
	    desc_hl = "String";
	    key = "n";
	    key_hl = "Number";
	    action = "enew";
	  }
	  {
	    icon = "󰈞 ";
	    icon_hl = "Title";
	    desc = "Find File";
	    desc_hl = "String";
	    key = "f";
	    key_hl = "Number";
	    action = "Telescope find_files";
	  }
	  {
	    icon = "󰋚 ";
	    icon_hl = "Title";
	    desc = "Recent Files";
	    desc_hl = "String";
	    key = "r";
	    key_hl = "Number";
	    action = "Telescope oldfiles";
	  }
	  {
	    icon = " ";
	    icon_hl = "Title";
	    desc = "Explorer";
	    desc_hl = "String";
	    key = "e";
	    key_hl = "Number";
	    action = "Oil";
	  }
	  {
	    icon = " ";
	    icon_hl = "Title";
	    desc = "Configuration";
	    desc_hl = "String";
	    key = "c";
	    key_hl = "Number";
	    action = "cd ~/.config/nixvim | e .";
	  }
	  {
	    icon = "󰩈 ";
	    icon_hl = "Title";
	    desc = "Quit";
	    desc_hl = "String";
	    key = "q";
	    key_hl = "Number";
	    action = "quit";
	  }
	];
	footer = [
	  ""
	  "Made with NixVim 󱄅 "
	];
      };
      hide = {
	statusline = true;
	tabline = true;
	winbar = true;
      };
    };
  };

  autoCmd = [
    {
      event = ["VimResized"];
      pattern = "*";
      callback = {
	__raw = ''
	  function()
	    if vim.bo.filetype == "dashboard" then
	      vim.cmd("Dashboard")
	    end
	  end
	  '';
      };
    }
  ];
}
