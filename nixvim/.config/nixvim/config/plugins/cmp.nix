{ config, lib, pkgs, ... }:

{
  plugins = {
    luasnip.enable = true;
    
    cmp = {
      enable = true;
      autoEnableSources = true;
      
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
        
        mapping = {
          "<CR>" = "cmp.mapping.confirm({select = true})";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };
      };
    };
  };
}
