{ pkgs, ... }:

# Die Hölle ist leer, alle Teufel sind hier
pkgs.python314Packages.buildPythonPackage rec {
  pname = "lute";
  version = "3.10.1";

  src = pkgs.python314Packages.fetchPypi {
    inherit version;
    pname = "lute3";
    hash = "sha256-gqwoyINuP54ve6R2OonLUT2oZYmpjvUopyWbJ+stJrE=";
  };

  build-system = [ pkgs.python314Packages.flit-core ];
  pyproject = true;

  dependencies = with pkgs.python314Packages; [
    flask-sqlalchemy
    flask-wtf
    jaconv
    (platformdirs.overrideAttrs (oldAttrs: rec {
      version = "3.11.0";

      src = pkgs.fetchFromGitHub {
        owner = "tox-dev";
        repo = "platformdirs";
        tag = version;
        hash = "sha256-27Cy8VEmbrO96G2mVStxkoWSRXlwZLWirI3tH6kBsus=";
      };
    }))
    requests
    beautifulsoup4
    pyyaml
    toml
    (waitress.overrideAttrs (oldAttrs: rec {
      pname = "waitress";
      version = "2.1.2";

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-eApAgsX7wP3movz+Xibm78Ho9CVzCGPAQIV2l4H1Hro=";
      };
    }))
    pyparsing
    pypdf
    ahocorapy
    (pkgs.python314Packages.buildPythonPackage rec {
      pname = "natto-py";
      version = "1.0.1";
      pyproject = true;

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-dgEDuzlyMu4DPJkk0TV+MrFCu+Ey/GpDuM+C3WtlToY=";
      };

      build-system = [ setuptools ];

      dependencies = [ cffi ];
    })
    (pkgs.python314Packages.buildPythonPackage rec {
      pname = "openepub";
      version = "0.0.9";
      pyproject = true;

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-qki9VVUn/zMXIkzQ+Zu5D3CXGpBbO97xRVfttYMrR9s=";
      };

      build-system = [ hatchling ];

      dependencies = [
        (xmltodict.overrideAttrs (oldAttrs: rec {
          version = "0.15.1";

          src = pkgs.fetchFromGitHub {
            owner = "martinblech";
            repo = "xmltodict";
            tag = "v${version}";
            hash = "sha256-j3shoXjAoAWFd+7k+0w6eoNygS2wkbhDkIq7QG+TmSM=";
          };
        }))
        beautifulsoup4
      ];
    })
    (pkgs.python314Packages.buildPythonPackage rec {
      pname = "subtitle-parser";
      version = "2.0.1";
      pyproject = true;

      src = pkgs.fetchFromGitHub {
        owner = "remram44";
        repo = "subtitle-parser";
        rev = "v${version}";
        hash = "sha256-uqMedb/WSUaXUHccNTiin3S7V5dDMEaAxla/evIKU1E=";
      };

      build-system = [ poetry-core ];

      dependencies = [ chardet ];
    })
  ];
}
