{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.instantwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.instantwm = {
      enable = mkEnableOption "instantwm";

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
        description = "instantwm package to install";
        type = types.package;
        default = cfg.instantosPackages.instantwm;
        defaultText = "cfg.instantosPackages.instantwm";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      {
        name = "instantwm";
        start =
          ''
            ${cfg.package}/bin/startinstantos &
            waitPID=$!
          '';
      };

    programs.instantlock = {
      enable = true;
      instantosPackages = mkDefault cfg.instantosPackages;
    };

    environment.systemPackages = [ cfg.package ];

  };

}
