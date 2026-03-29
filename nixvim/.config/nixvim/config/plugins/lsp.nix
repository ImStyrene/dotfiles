{ config, lib, pkgs, ... }:

{
  plugins.lsp = {
    enable = true;
    servers = {
      ts_ls.enable = true;
      lua_ls.enable = true;
      nixd.enable = true;
      rust_analyzer = {
	enable = true;
	installCargo = false;
	installRustc = false;
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    mason-nvim
    mason-tool-installer-nvim
  ];
}
