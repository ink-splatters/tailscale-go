{lib, ...}: let
  inherit (lib) lists match fileContents splitString;
  inherit (builtins) elemAt removeAttrs replaceStrings;
in {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) src;
    name = let
      versionLines = splitString "\n" (fileContents "${src}/VERSION");
      versionStr = lists.head versionLines;
      timeIsoExtended = lists.head (match "time (.*)" (elemAt versionLines 1));
      timeIsoBasic = replaceStrings ["-" ":"] ["" ""] timeIsoExtended;
    in "${versionStr}+tailscale.${timeIsoBasic}";
  in {
    packages.go_1_25 = (removeAttrs pkgs.go_1_25 ["pname" "version"]).overrideAttrs (_: {
      inherit name;
      inherit src;
    });
  };
}
