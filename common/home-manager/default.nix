{
  inputs,
  pubKeys,
  homes,
}: {
  useGlobalPkgs = true;
  useUserPackages = true;
  backupFileExtension = "backup";
  extraSpecialArgs = {
    inherit inputs pubKeys;
  };

  users = {
    inherit (homes) eelco;
  };
}
