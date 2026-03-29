{ config, lib, pkgs, ... }:

let
  # Function to import all .nix files from a directory
  importDir = dir:
    let
      files = builtins.readDir dir;
    in
    builtins.map
      (name: dir + "/${name}")
      (builtins.filter
        (name: builtins.match ".*\\.nix$" name != null)
        (builtins.attrNames files));
in
{
  imports = [
    ./options.nix
    ./remaps.nix
  ] ++ (importDir ./plugins)
    ++ (importDir ./colorschemes);

}
