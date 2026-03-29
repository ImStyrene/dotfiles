{ config, lib, pkgs, ... }:

{
  plugins = {
    bufferline.enable = true;
    web-devicons.enable = true;
    lualine.enable = true;
    which-key.enable = true;
    snacks.enable = true;
  };
}
