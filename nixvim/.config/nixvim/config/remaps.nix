{ config, lib, pkgs, ... }:

{
  globals.mapleader = " ";

  keymaps = [

    # Oil File Tree
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Oil<CR>";
      options = {
	desc = "󰏇 Open Oil";
      };
    }

    # Dashboard (idk what was I thinking)
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>Dashboard<CR>";
      options = {
	desc = "󰕮 Open Dashboard";
      };
    }

    # NeoGit
    {
      mode = "n";
      key = "<leader>gm";
      action = "<cmd>Neogit<CR>";
      options = {
	desc = " Open NeoGit";
      };
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Neogit commit<CR>";
      options = {
        desc = " NeoGit Commit";
      };
    }
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>Neogit push<CR>";
      options = {
        desc = " NeoGit Push";
      };
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>Neogit pull<CR>";
      options = {
        desc = " NeoGit pull";
      };
    }

    # Editor
    {
      mode = "n";
      key = "\\";
      action = "<cmd>nohlsearch<CR>";
      options = {
	desc = "Clear search highlights";
      };
    }
  ];
}
