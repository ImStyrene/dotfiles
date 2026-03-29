{ config, lib, pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;

    # Enable syntax highlighting
    settings = {
      highlight = {
	enable = true;
	additional_vim_regex_highlighting = false;
      };

      ensure_installed = [
	"lua"
	"python"
	"javascript"
	"typescript"
	"json"
	"yaml"
	"markdown"
	"bash"
	"html"
	"css"
	"go"
	"rust"
	"java"
	"c"
	"cpp"
	"sql"
	"ruby"
	"php"
	"toml"
	"vim"
	"dockerfile"
	"graphql"
	"proto"
      ];

      incremental_selection = {
	enable = true;
      };

      indent = {
	enable = true;
      };
    };
  };

  opts = {
    /*
    foldmethod = "expr";
    foldexpr = "nvim_treesitter#foldexpr()";
    */
  };
}
