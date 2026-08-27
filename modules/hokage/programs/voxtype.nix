{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.voxtype;
  voxtype-hip = pkgs.voxtype.overrideAttrs (oldAttrs: {
    pname = "voxtype-hip";
    buildFeatures = [ "gpu-hipblas" ];
    cargoBuildFeatures = [ "gpu-hipblas" ];
    cargoCheckFeatures = [ "gpu-hipblas" ];
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.rocmPackages.clr ];
    buildInputs =
      oldAttrs.buildInputs
      ++ (with pkgs.rocmPackages; [
        clr
        hipblas
        rocblas
      ]);
    env = oldAttrs.env // {
      HIP_PATH = "${pkgs.rocmPackages.clr}";
      AMDGPU_TARGETS = "gfx1100";
    };
  });
in
{
  options.hokage.programs.voxtype = {
    enable = lib.mkEnableOption "Voxtype speech-to-text daemon";
    gpuSupport = lib.mkEnableOption "Vulkan GPU acceleration for Voxtype";
    hipSupport = lib.mkEnableOption "AMD ROCm/HIP acceleration for Voxtype (gfx1100)";
    loadModelOnDemand = lib.mkEnableOption "loading the Voxtype model on demand";
    contextWindowOptimization = lib.mkEnableOption "context window optimization for short recordings";
    model = lib.mkOption {
      type = lib.types.str;
      default = "large-v3-turbo";
      example = "base";
      description = ''
        Whisper model to use. The base model uses about 142 MiB, while the
        default large-v3-turbo model uses about 1.6 GiB and provides
        substantially better German and English transcription accuracy.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.gpuSupport && cfg.hipSupport);
        message = "hokage.programs.voxtype.gpuSupport and hipSupport are mutually exclusive";
      }
    ];

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      services.voxtype = {
        enable = true;
        package =
          if cfg.hipSupport then
            voxtype-hip
          else if cfg.gpuSupport then
            pkgs.voxtype-vulkan
          else
            pkgs.voxtype;
        wayland.display = lib.mkIf hokage.waylandSupport "wayland-0";
        loadModels = [ cfg.model ];
        settings = {
          hotkey = {
            enabled = true;
            key = "SCROLLLOCK";
            mode = "push_to_talk";
          };
          whisper = {
            inherit (cfg) model;
            on_demand_loading = cfg.loadModelOnDemand;
            context_window_optimization = cfg.contextWindowOptimization;
            language = [
              "de"
              "en"
            ];
          };
          output.dotool_xkb_layout = "de";
          output.notification = {
            on_recording_start = true;
            on_recording_stop = true;
            on_transcription = true;
          };
        };
      };
    });
  };
}
