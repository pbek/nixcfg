# Workaround for netbird 0.65.3 build failure with Go 1.26:
# The vendored gvisor dependency has runtime_constants_go125.go and
# runtime_constants_go126.go that both compile under Go 1.26 due to missing
# exclusive build constraints, causing WaitReason* redeclaration errors.
# netbird's go.mod declares "go 1.25", so pin buildGoModule to Go 1.25.
_final: prev: {
  netbird = prev.netbird.override {
    buildGoModule = prev.buildGoModule.override { go = prev.go_1_25; };
  };
}
