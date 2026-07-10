{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.lute =
        let
          configFile = pkgs.writeText "config.yml" ''
            ENV: prod
            DBNAME: lute.db
          '';
        in
        (inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = (import ../../packages/lute/package.nix) pkgs;
          flags = {
            "--config" = "${configFile}";
            "--port" = "6767";
          };
        });
    };
}
