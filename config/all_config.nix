let
  all_config_mods = {}
  // (import ./ibm_bgq_config.nix)
  // (import ./knl_platform_config.nix)
  // (import ./intel_config.nix)
  // (import ./cray_config.nix)
  // (import ./allinea_config.nix)
  // (import ./shared_config.nix)
  // (import ./slurm_config.nix)
  // (import ./bbp_maintainers_config.nix);

  packages_override = (import ./apply_override.nix {
    config = all_config_mods;
  } );
in
  all_config_mods // packages_override
