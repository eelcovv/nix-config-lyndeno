{
  haumea,
  lib,
}: let
  # deadnix: skip
  loadFolder = folder: ({pkgs, ...} @ args:
    haumea.lib.load {
      src = folder;
      inputs = args;
      transformer = haumea.lib.transformers.liftDefault;
    });

  ls = folder: (builtins.attrNames (builtins.readDir folder));

  mods = modFolder: import ./modules.nix {inherit lib modFolder loadFolder;};
in rec {
  inherit loadFolder;
  makeNixosSystem = {
    hostFolder,
    commonFolder,
    modFolder,
    name,
    specialArgs ? {},
  }: let
    system = import (hostFolder + "/${name}/_localSystem.nix");

    hostCfg = loadFolder (hostFolder + "/${name}");
  in
    lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        hostCfg
        (loadFolder commonFolder)
        (mods modFolder)
        {networking.hostName = name;}
      ];
    };

  makeNixosSystems = {hostFolder, ...} @ args:
    builtins.listToAttrs
    (
      map
      (name: {
        inherit name;
        value = makeNixosSystem (args
          // {
            inherit name;
          });
      })
      (ls hostFolder)
    );
}
