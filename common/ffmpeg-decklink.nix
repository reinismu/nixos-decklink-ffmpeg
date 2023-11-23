{ pkgs, ... }:

let
  decklinkSdk = pkgs.callPackage ./blackmagic/decklink-sdk.nix { };

  decklinkFfmpeg = pkgs.ffmpeg.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-nonfree" "--enable-decklink" ];
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.blackmagic-desktop-video
      decklinkSdk
    ];
    
    postFixup = ''
      addOpenGLRunpath ${placeholder "lib"}/lib/libavcodec.so
      addOpenGLRunpath ${placeholder "lib"}/lib/libavutil.so

      wrapProgram $bin/bin/ffmpeg \
        --prefix LD_LIBRARY_PATH : ${pkgs.blackmagic-desktop-video}/lib
    '';

  });
  
in
{
  environment.extraOutputsToInstall = [ "dev" ];
  
  environment.systemPackages = [ 
    decklinkSdk
    decklinkFfmpeg 
  ];
}
