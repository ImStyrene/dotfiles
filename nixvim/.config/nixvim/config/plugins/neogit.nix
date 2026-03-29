{ config, lib, pkgs, ... }:

{
  plugins.neogit = {
    enable = true;
    settings = {
      # Use telescope for selection lists
      integrations = {
        telescope = true;
        diffview = true;
      };
      
      # Disable signs in the gutter
      signs = {
        hunk = ["" ""];
        item = ["" ""];
        section = ["" ""];
      };
      
      # Customize the graph style
      graph_style = "unicode";
      
      # Configure popup and commit editor
      kind = "tab";
      commit_editor = {
        kind = "tab";
        show_staged_diff = true;
      };
      
      # Configure sections - use 'hidden' instead of 'folded'
      sections = {
        untracked = {
          hidden = false;
        };
        unstaged = {
          hidden = false;
        };
        staged = {
          hidden = false;
        };
        stashes = {
          hidden = true;
        };
        unpulled_upstream = {
          hidden = true;
        };
        unmerged_upstream = {
          hidden = false;
        };
        unpulled_pushRemote = {
          hidden = true;
        };
        unmerged_pushRemote = {
          hidden = false;
        };
        recent = {
          hidden = true;
        };
      };
      
      # Enable automatic refresh
      auto_refresh = true;
      
      # Use built-in notification
      use_default_keymaps = true;
    };
  };

  # Optional: Add diffview for better diff viewing
  plugins.diffview = {
    enable = true;
  };

  # Optional: Add telescope integration
  plugins.telescope.enable = true;
}
