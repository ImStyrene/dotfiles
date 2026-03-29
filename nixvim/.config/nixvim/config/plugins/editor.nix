{ config, lib, pkgs, ... }:

{
  plugins = {
    nvim-autopairs.enable = true;
    telescope.enable = true;
    oil.enable = true;
  };
}
