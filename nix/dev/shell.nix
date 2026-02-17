{
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) pre-commit;
  in {
    devShells.default = pkgs.mkShell {
      packages = pre-commit.settings.enabledPackages ++ [pkgs.gitMinimal];
      shellHook = ''
        ${pre-commit.installationScript}
      '';

      env = {
        inherit (pkgs.go_1_26) GOROOT_BOOTSTRAP;
      };
    };
  };
}
