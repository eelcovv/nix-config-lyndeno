{
  config,
  lib,
  lsLib,
  inputs,
  pkgs,
  ...
}: let
  modNames = lsLib.lsDirs ./.;

  getMod = name: ({
      # deadnix: skip
      pkgs,
      # deadnix: skip
      config,
      ...
    } @ args:
      inputs.haumea.lib.load {
        src = ./${name};
        inputs =
          args
          // {
            inherit lib;
          };
        transformer = inputs.haumea.lib.transformers.liftDefault;
      });
in {
  options.mods = builtins.listToAttrs (
    map
    (
      x: {
        name = x;
        value = {enable = lib.mkEnableOption "${x} mod";};
      }
    )
    modNames
  );
  config = lib.mkMerge (
    map
    (
      x: lib.mkIf config.mods.${x}.enable ((getMod x) {inherit pkgs config inputs;})
    )
    modNames
  );
}
