
For anyone else having trouble, here's what I did:

    skipped the extra config portion
    Don't forget to setup sudo smbpasswd -a <user> to add a user. Also add a password to the user when prompted


Tested and working with the minor modifications below for those not using flakes. Thanks for the update @TheRealGramdalf! You saved me a bunch of time.

The only glaring difference is that I got nssmdns4 does not exist so I commented it out.

{ config, lib, pkgs, ... }: {
    services = {
      # Network shares
      samba = {
        package = pkgs.samba4Full;
        # ^^ `samba4Full` is compiled with avahi, ldap, AD etc support (compared to the default package, `samba`
        # Required for samba to register mDNS records for auto discovery 
        # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
        enable = true;
        openFirewall = true;
        shares.testshare = {
          path = "/path/to/share";
          writable = "true";
          comment = "Hello World!";
        };
        extraConfig = ''
          server smb encrypt = required
          # ^^ Note: Breaks `smbclient -L <ip/host> -U%` by default, might require the client to set `client min protocol`?
          server min protocol = SMB3_00
        '';
      };
      avahi = {
        publish.enable = true;
        publish.userServices = true;
        # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
        #nssmdns4 = true;
        # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
        enable = true;
        openFirewall = true;
      };
      samba-wsdd = {
      # This enables autodiscovery on windows since SMB1 (and thus netbios) support was discontinued
        enable = true;
        openFirewall = true;
      };
    };
}

