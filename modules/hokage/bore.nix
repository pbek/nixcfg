{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hokage.bore;
  upstreamPatch = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/${cfg.kernelSeries}/sched/0001-bore-cachy.patch";
    hash = cfg.patchHash;
  };
  rebasedPatch =
    pkgs.runCommand "bore-cachy-${cfg.kernelSeries}-rebased.patch"
      {
        inherit upstreamPatch;
      }
      ''
            cp "$upstreamPatch" "$out"

            perl -0pi -e 's{@@ -67,28 \+71,32 @@.*?__read_mostly unsigned int sysctl_sched_migration_cost\s*=\s*500000UL;\n}{@@ -69,14 +69,20 @@
         *
         * (default SCHED_TUNABLESCALING_LOG = *(1+ilog(ncpus))
         */
        +#ifdef CONFIG_SCHED_BORE
        +unsigned int sysctl_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
        +#else
         unsigned int sysctl_sched_tunable_scaling = SCHED_TUNABLESCALING_LOG;
        +#endif
         
         /*
         * Minimal preemption granularity for CPU-bound tasks:
         *
         * (default: 0.70 msec * (1 + ilog(ncpus)), units: nanoseconds)
         */
        +#ifdef CONFIG_SCHED_BORE
        +static const unsigned int nsecs_per_tick\t\t= 1000000000ULL / HZ;
        +unsigned int sysctl_sched_min_base_slice\t\t= CONFIG_MIN_BASE_SLICE_NS;
        +__read_mostly uint sysctl_sched_base_slice\t\t= nsecs_per_tick;
        +#else
         unsigned int sysctl_sched_base_slice\t\t\t= 700000ULL;
         static unsigned int normalized_sysctl_sched_base_slice\t= 700000ULL;
        +#endif
         
         __read_mostly unsigned int sysctl_sched_migration_cost\t= 500000UL;
        }ms or die "failed to rebase fair.c hunk #2\n"' "$out"

            perl -0pi -e 's{@@ -131,12 \+139,8 @@ int __weak arch_asym_cpu_priority\(int cpu\)\n(?:.*\n)*?@@ -202,6 \+206,13 @@ static inline void update_load_set\(struct load_weight \*lw, unsigned long w\)\n}{@@ -202,6 +206,13 @@ static inline void update_load_set(struct load_weight *lw, unsigned long w)
        }ms or die "failed to drop obsolete fair.c hunk #3\n"' "$out"
      '';

  inherit (lib)
    hasPrefix
    kernel
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.hokage.bore = {
    enable = mkEnableOption "BORE scheduler kernel patch";

    kernelSeries = mkOption {
      type = types.str;
      default = "6.18";
      example = "6.19";
      description = "Kernel series used to fetch the BORE patch from the CachyOS kernel-patches repository.";
    };

    patchHash = mkOption {
      type = types.str;
      default = "sha256-KQ3HeQBDcfcdI/J1iTBm3Xqo1oZKyfXQSEQ3m4VUygw=";
      description = "Hash of the fetched BORE patch.";
    };

    maxKernelVersion = mkOption {
      type = types.package;
      default = pkgs.linuxKernel.packages.linux_6_18.kernel;
      description = "Maximum kernel version allowed when the BORE patch is enabled.";
    };

    minBaseSliceNs = mkOption {
      type = types.int;
      default = 2000000;
      description = "Default value for CONFIG_MIN_BASE_SLICE_NS when building the BORE-enabled kernel.";
    };
  };

  config = mkIf cfg.enable {
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    boot.kernelPatches = [
      {
        name = "bore-cachy";
        patch = rebasedPatch;
        structuredExtraConfig = {
          SCHED_BORE = kernel.yes;
        };
        extraConfig = ''
          MIN_BASE_SLICE_NS ${toString cfg.minBaseSliceNs}
        '';
      }
    ];

    boot.kernel.sysctl."kernel.sched_bore" = 1;

    assertions = [
      {
        assertion = hasPrefix "${cfg.kernelSeries}." config.hokage.kernel.selectedKernel.version;
        message = "hokage.bore requires the selected kernel (${config.hokage.kernel.selectedKernel.version}) to match patch series ${cfg.kernelSeries}.";
      }
    ];
  };
}
