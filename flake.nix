{
  description = "NixOS Example decklink machine";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # Replace the official cache with a mirror located in China
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:reinismu/nixpkgs/25555ed64b5785dea9896da492265ebc7613674c";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `outputs` are all the build result of the flake.
  #
  # A flake can have many use cases and different types of outputs.
  # 
  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  # 
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {;
      "decklink-machine" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./machines/decklink-machine/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.ddr = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}