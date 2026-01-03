{lib, ...}: let
  inherit (lib) lists match fileContents splitString;
in {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) src;
    version = let
      versionStr = lists.head (splitString "\n" (fileContents "${src}/VERSION"));
    in
      lists.head (match "go(.*)" versionStr);
  in {
    packages.go_1_25 = pkgs.go_1_25.overrideAttrs (_: {
      version = "${version}-tailscale";
      inherit src;
    });
  };
}
