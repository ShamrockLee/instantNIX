{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.instantlock;

in
{
  options = {
    programs.instantlock = {
      enable = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = ''
          Whether to install instantlock screen locker with setuid wrapper.
        '';
      };
      instantosPackages = mkOption {
        # It's a legacyPackage (pkgs) kind of attribute set,
        # which might contains non-derivation attributes.
        type = types.attrs;
        default = { };
        example = literalExpression ''
          pkgs.nur.repos.instantos # from NUR Nixpkgs overlay
          config.nur.repos.instantos # from NUR NixOS module / HM module
          (import /path/to/nur { inherit pkgs; }).repos.instantos # by importing NUR
          inputs.instantnix.packages # from instantNIX flake
          import /path/to/instantnix { inherit pkgs; } # by importing instantNIX
        '';
        description = ''
          instantOS package set to use.

          This is nessesary for both NUR-based and
          Flake-based setup.

          The default value is dummy, since these packages
          are not part of Nixpkgs, and there's no sane
          "default location" to use.
        '';
      };
      package = mkOption {
        type = types.package;
        default = cfg.instantosPackages.instantlock;
        defaultText = "cfg.instantosPackages.instantlock";
        description = ''
          instantlock package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.instantlock = {
      source = "${cfg.package}/bin/instantlock";
      owner = "root";
      group = "root";
    };
  };
}
