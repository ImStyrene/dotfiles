{ config, lib, pkgs, ... }:

{
  plugins.multicursors = {
    enable = true;
    
    settings = {
      generate_hints = {
        normal = true;
        insert = true;
        extend = true;
      };
      
      hint_config = {
        float_opts = {
          border = "rounded";
        };
        position = "bottom-right";
      };
    };
  };
}
