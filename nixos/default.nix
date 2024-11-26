{
  inputs,
  outputs,
  ...
}:
let
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
in
{
  # The NixOs running on bare metal.
  desktop = nixosSystem {
    system = "x86_64-linux";

    # The Nix module system can modularize configuration,
    # improving the maintainability of configuration.
    #
    # Each parameter in the `modules` is a Nix Module, and
    # there is a partial introduction to it in the nixpkgs manual:
    #    <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
    # It is said to be partial because the documentation is not
    # complete, only some simple introductions.
    # such is the current state of Nix documentation...
    #
    # A Nix Module can be an attribute set, or a function that
    # returns an attribute set. By default, if a Nix Module is a
    # function, this function have the following default parameters:
    #
    #  lib:     the nixpkgs function library, which provides many
    #             useful functions for operating Nix expressions:
    #             https://nixos.org/manual/nixpkgs/stable/#id-1.4
    #  config:  all config options of the current flake, very useful
    #  options: all options defined in all NixOS Modules
    #             in the current flake
    #  pkgs:   a collection of all packages defined in nixpkgs,
    #            plus a set of functions related to packaging.
    #            you can assume its default value is
    #            `nixpkgs.legacyPackages."${system}"` for now.
    #            can be customed by `nixpkgs.pkgs` option
    #  modulesPath: the default path of nixpkgs's modules folder,
    #               used to import some extra modules from nixpkgs.
    #               this parameter is rarely used,
    #               you can ignore it for now.
    #
    # The default parameters mentioned above are automatically
    # generated by Nixpkgs.
    # However, if you need to pass other non-default parameters
    # to the submodules,
    # you'll have to manually configure these parameters using
    # `specialArgs`.
    # you must use `specialArgs` by uncomment the following line:
    # specialArgs = {...};  # pass custom arguments into all sub module.
    modules = [
      ./hosts/settings.nix
      ./hosts/desktop/configuration.nix
    ];
    specialArgs = {
      inherit inputs outputs;
    };
  };

  # The Tuxedo Pulse-14 Gen3 Laptop.
  laptop = nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/settings.nix
      ./hosts/laptop/configuration.nix
    ];
    specialArgs = {
      inherit inputs outputs;
    };
  };

  # The Tuxedo Pulse-14 Gen3 Laptop.
  tuxedo = nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/settings.nix
      ./hosts/tuxedo-pulse-14/configuration.nix
    ];
    specialArgs = {
      inherit inputs outputs;
    };
  };

  # The NixOs for the virtual machine.
  vm = nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/settings.nix
      ./hosts/vm/configuration.nix
    ];
    specialArgs = {
      inherit inputs outputs;
    };
  };
}