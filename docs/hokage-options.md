## hokage\.audio\.enable

Whether to enable audio system\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.backtickFirst

Type a backtick without Shift and an acute accent with Shift on German keyboards

_Type:_
boolean

_Default:_

```nix
config.hokage.useInternalInfrastructure
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.bore\.enable

Whether to enable BORE scheduler kernel patch\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.bore\.kernelSeries

Kernel series used to fetch the BORE patch from the CachyOS kernel-patches repository\.

_Type:_
string

_Default:_

```nix
"6.18"
```

_Example:_

```nix
"6.19"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.bore\.maxKernelVersion

Maximum kernel version allowed when the BORE patch is enabled\.

_Type:_
package

_Default:_

```nix
<derivation linux-6.18.51>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.bore\.minBaseSliceNs

Default value for CONFIG_MIN_BASE_SLICE_NS when building the BORE-enabled kernel\.

_Type:_
signed integer

_Default:_

```nix
2000000
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.bore\.patchHash

Hash of the fetched BORE patch\.

_Type:_
string

_Default:_

```nix
"sha256-KQ3HeQBDcfcdI/J1iTBm3Xqo1oZKyfXQSEQ3m4VUygw="
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.cache\.enable

Whether to enable cache service\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.cache\.sources

List of cache sources to enable

_Type:_
list of (one of “home”, “remote”, “caliban”)

_Default:_

```nix
[
  "remote"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.catppuccin\.enable

Whether to enable Catppuccin theme\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.catppuccin\.flavor

Catppuccin flavor to use

_Type:_
one of “latte”, “frappe”, “macchiato”, “mocha”

_Default:_

```nix
"mocha"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.excludePackages

List of default packages to exclude from the configuration

_Type:_
list of package

_Default:_

```nix
[ ]
```

_Example:_

```nix
[ pkgs.qownnotes ]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.gaming\.enable

Whether to enable gaming\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.gaming\.ryubing\.highDpi

Whether to enable high-dpi for ryubing\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.hostName

Hostname of the system

_Type:_
string

_Default:_

```nix
""
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.kernel\.enable

Whether to enable automatic kernel selection based on requirements

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.kernel\.maxVersion

Maximum allowed kernel version

_Type:_
package

_Default:_

```nix
<derivation linux-7.2.5>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.kernel\.requirements

List of kernel packages required by various modules

_Type:_
list of package

_Default:_

```nix
[ ]
```

_Example:_

```nix
[ ]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.kernel\.selectedKernel

The automatically selected kernel package (lowest from requirements)

_Type:_
package _(read only)_

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.cplusplus\.enable

Whether to enable C++ development support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.cplusplus\.ide\.enable

Whether to enable C++ IDEs\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.cplusplus\.qt6\.enable

Whether to enable Qt6 for IDEs\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.go\.enable

Whether to enable Go development support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.go\.ide\.enable

Whether to enable Go IDE\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.javascript\.enable

Whether to enable Javascript development support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.javascript\.ide\.enable

Whether to enable Javascript IDE\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.php\.enable

Whether to enable PHP development support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.languages\.php\.ide\.enable

Whether to enable PHP IDE\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.lowBandwidth

Don’t install all packages or use stable versions to save bandwidth

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.mail\.enable

Whether to enable Himalaya mail accounts\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.mail\.aerc\.enable

Whether to enable aerc mail client\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.mail\.himalaya\.enable

Whether to enable Himalaya mail client\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.mail\.meli\.enable

Whether to enable meli mail client\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.mail\.neomutt\.enable

Whether to enable NeoMutt mail client\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.memory-swap\.enable

Whether to enable memory swap tuning\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.enable

Whether to enable NVIDIA graphics support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.package

Nvidia driver package to use (overrides packageType if set)

_Type:_
null or package

_Default:_

```nix
null
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.packageType

Type of NVIDIA driver package to use

_Type:_
one of “stable”, “latest”, “beta”, “production”, “new_feature”, “bleeding_edge”, “vulkan_beta”, “legacy_580”

_Default:_

```nix
"latest"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.maxKernelVersion

Maximum allowed kernel package for NVIDIA

_Type:_
package _(read only)_

_Default:_

```nix
<derivation linux-7.2.5>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.modesetting\.enable

Whether to enable NVIDIA DRM modesetting (required for some Wayland compositors, e\.g\. Sway)\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.open

Whether to enable Open NVIDIA drivers (NVIDIA open-gpu-kernel-modules)\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.nvidia\.powerManagement\.enable

Whether to enable NVIDIA power management\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.plasma\.enable

Whether to enable KDE Plasma\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.plasma\.enableOld

Whether to enable plasma with old KDE packages\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.plasma\.enablePlasmaManager

Whether to enable plasma-manager\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.aider\.enable

Whether to enable Aider AI code completion tool\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.atuin\.enable

Whether to enable Atuin shell history\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.enable

Whether to enable Copilot API - Turn GitHub Copilot into OpenAI/Anthropic API compatible server\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.package

The copilot-api package to use

_Type:_
package

_Default:_

```nix
<derivation copilot-api-0.7.0>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.accountType

Account type to use

_Type:_
one of “individual”, “business”, “enterprise”

_Default:_

```nix
"individual"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.manual

Enable manual request approval

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.openFirewall

Open firewall port for copilot-api

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.port

Port to listen on

_Type:_
16 bit unsigned integer; between 0 and 65535 (both inclusive)

_Default:_

```nix
4141
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.rateLimit

Rate limit in seconds between requests

_Type:_
null or (positive integer, meaning >0)

_Default:_

```nix
null
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.verbose

Enable verbose logging

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.copilot-api\.wait

Wait instead of error when rate limit is hit

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.espanso\.enable

Whether to enable Espanso to expand text\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.gemini-cli\.enable

Whether to enable Google Gemini CLI\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.git\.enable

Whether to enable Git integration\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.git\.enableUrlRewriting

Whether to enable URL rewriting from HTTPS to SSH\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.enable

Whether to enable JetBrains IDEs support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.clion\.enable

Whether to enable CLion support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.goland\.enable

Whether to enable Goland support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.phpstorm\.enable

Whether to enable PhpStorm support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.plugins

List of JetBrains plugin IDs to install\.

_Type:_
list of string

_Default:_

```nix
[
  "com.github.copilot"
  "nix-idea"
]
```

_Example:_

```nix
[
  "nix-idea"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.jetbrains\.useStable

Whether to enable stable JetBrains packages\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.libvirt\.enable

Whether to enable libvirt support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.libvirt\.gui\.enable

Whether to enable VirtManager\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.libvirt\.role

Role of the libvirt system

_Type:_
one of “host”, “guest”

_Default:_

```nix
"host"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.nixbit\.enable

Whether to enable Nixbit configuration\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.nixbit\.forceAutostart

Whether to enable Force creation of autostart desktop entry when application starts\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.nixbit\.repository

Git repository URL for Nixbit

_Type:_
string

_Default:_

```nix
"https://github.com/pbek/nixcfg.git"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.nushell\.enable

Whether to enable Nushell\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.opencode\.enable

Whether to enable AI coding agent built for the terminal\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.pia\.enable

Whether to enable Private Internet Access\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.platformio\.enable

Whether to enable PlatformIO support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.qownnotes\.enable

Whether to enable QOwnNotes note-taking app\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.qownnotes\.enableTui

Whether to enable QOwnNotes terminal browser\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.qownnotes\.settings

Settings for QOwnNotes\.override\.conf

_Type:_
attribute set of attribute set of (boolean or signed integer or string)

_Default:_

```nix
{
  Editor = {
    hangingIndent = true;
    showLineNumbers = true;
    showMarkdownImagePreviews = true;
  };
}
```

_Example:_

```nix
{
  General = {
    darkMode = true;
    interfaceLanguage = "en";
  };
}
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.qtcreator\.enable

Whether to enable qtcreator\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.qtcreator\.package

The QtCreator package to install

_Type:_
package

_Default:_

```nix
<derivation qtcreator-20.0.1>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.starship\.enable

Whether to enable Starship support\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.trippy\.enable

Whether to enable Trippy configuration\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.uutils\.enable

Whether to enable uutils replacements for GNU utils, changes seems to need reboot\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.uutilsAliases\.enable

Whether to enable aliases for uutils to replace GNU coreutils in the shell\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.virtualbox\.enable

Whether to enable VirtualBox\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.virtualbox\.maxKernelVersion

Maximum allowed kernel package vor VirtualBox

_Type:_
package _(read only)_

_Default:_

```nix
<derivation linux-6.18.51>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.virtualbox\.role

Role of the VirtualBox system

_Type:_
one of “host”, “guest”

_Default:_

```nix
"host"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.enable

Whether to enable Voxtype speech-to-text daemon\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.contextWindowOptimization

Whether to enable context window optimization for short recordings\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.gpuSupport

Whether to enable Vulkan GPU acceleration for Voxtype\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.hipSupport

Whether to enable AMD ROCm/HIP acceleration for Voxtype (gfx1100)\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.loadModelOnDemand

Whether to enable loading the Voxtype model on demand\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.voxtype\.model

Whisper model to use\. The base model uses about 142 MiB, while the
default large-v3-turbo model uses about 1\.6 GiB and provides
substantially better German and English transcription accuracy\.

_Type:_
string

_Default:_

```nix
"large-v3-turbo"
```

_Example:_

```nix
"base"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.yazi\.enable

Whether to enable Yazi terminal file manager\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.enable

Whether to enable the native Zerobyte backup service\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.package

The zerobyte package to use\.

_Type:_
package

_Default:_

```nix
pkgs.zerobyte
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.autoStart

Whether to start Zerobyte automatically at boot\.

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.backupPaths

Host paths exposed under /backup for existing Zerobyte volume definitions\.

_Type:_
list of string

_Default:_

```nix
[
  "/var/lib"
  "/home"
  "/etc"
  "/root"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.baseUrl

Base URL of the Zerobyte instance\.

_Type:_
string

_Default:_

```nix
"http://localhost:4096"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.dataDir

State directory used by Zerobyte\.

_Type:_
string

_Default:_

```nix
"/var/lib/zerobyte"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.environmentFile

Environment file containing APP_SECRET and other sensitive settings\.

_Type:_
absolute path

_Default:_

```nix
"config.age.secrets.zerobyte-secret.path"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.group

Group under which Zerobyte runs\.

_Type:_
string

_Default:_

```nix
"root"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.host

Address on which Zerobyte listens\.

_Type:_
string

_Default:_

```nix
"127.0.0.1"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.openFirewall

Whether to open the Zerobyte port in the firewall\.

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.port

Port on which Zerobyte listens\.

_Type:_
16 bit unsigned integer; between 0 and 65535 (both inclusive)

_Default:_

```nix
4096
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.readWriteBackupPaths

Whether Zerobyte may write to the configured backup paths for restores\.

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.resticHostname

Restic hostname, defaulting to the system hostname when empty\.

_Type:_
string

_Default:_

```nix
""
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.settings

Additional environment settings passed to Zerobyte\.

_Type:_
attribute set of (boolean or signed integer or string)

_Default:_

```nix
{ }
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.timezone

Timezone used by Zerobyte\.

_Type:_
string

_Default:_

```nix
"Europe/Vienna"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.trustedOrigins

Additional origins allowed to call the Zerobyte authentication API\.

_Type:_
list of string

_Default:_

```nix
[ ]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zerobyte\.user

User under which Zerobyte runs\.

_Type:_
string

_Default:_

```nix
"root"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.enable

Whether to enable ZFSGuard health monitoring service\.

_Type:_
boolean

_Default:_

```nix
true
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.checkSmart

Whether to check SMART disk health\.

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.checkZfs

Whether to check ZFS pool health\.

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.desktopNotifications

Enable local Linux desktop notifications via notify-send\.

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.intervalMinutes

Interval in minutes between ZFS/SMART health checks\.

_Type:_
signed integer

_Default:_

```nix
60
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.shoutrrrUrls

Shoutrrr notification URLs for remote alerting\. Examples:

- “discord://token@id”
- “telegram://token@telegram?channels=channel”
- “gotify://host/token”
- “ntfy://ntfy\.sh/topic”

_Type:_
list of string

_Default:_

```nix
[ ]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.programs\.zfsguard\.smartDevices

List of devices to check for SMART health\. Empty means auto-detect\.

_Type:_
list of string

_Default:_

```nix
[ ]
```

_Example:_

```nix
[
  "/dev/sda"
  "/dev/nvme0"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.role

Role of the system

_Type:_
one of “desktop”, “server-home”, “server-remote”, “ally”

_Default:_

```nix
"desktop"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.scx\.enable

Whether to enable sched-ext userspace scheduler\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.scx\.package

SCX package to install and use for the scheduler service\.

_Type:_
package

_Default:_

```nix
<derivation scx_full-1.1.2>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.scx\.extraArgs

Extra arguments passed to the selected SCX scheduler\.

_Type:_
list of string

_Default:_

```nix
[ ]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.scx\.scheduler

SCX scheduler to run via services\.scx\.

_Type:_
one of “scx_beerland”, “scx_bpfland”, “scx_chaos”, “scx_cosmos”, “scx_central”, “scx_flash”, “scx_flatcg”, “scx_lavd”, “scx_layered”, “scx_mitosis”, “scx_nest”, “scx_p2dq”, “scx_pair”, “scx_prev”, “scx_qmap”, “scx_rlfifo”, “scx_rustland”, “scx_rusty”, “scx_sdt”, “scx_simple”, “scx_tickless”, “scx_userland”, “scx_wd40”

_Default:_

```nix
"scx_rustland"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.serverMba\.enable

Whether to enable MBA server configuration\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.enable

Whether to enable NixHostForge host configuration prebuilder\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.branch

Git branch to watch\.

_Type:_
string

_Default:_

```nix
"main"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.concurrency

Maximum number of concurrent host builds\. Leave null to configure it in the web UI\.

_Type:_
null or (positive integer, meaning >0)

_Default:_

```nix
null
```

_Example:_

```nix
1
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.interval

Polling interval as a Go duration string\. Leave null to configure it in the web UI\.

_Type:_
null or string

_Default:_

```nix
null
```

_Example:_

```nix
"15m"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.listenAddress

Address for the web interface to listen on\.

_Type:_
string

_Default:_

```nix
"0.0.0.0"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.openFirewall

Open the web interface port in the firewall\.

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.port

Port for the web interface\.

_Type:_
16 bit unsigned integer; between 0 and 65535 (both inclusive)

_Default:_

```nix
9637
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.services\.nixhostforge\.repository

Git repository URL containing the Nix flake to check\.

_Type:_
string

_Default:_

```nix
"https://github.com/pbek/nixcfg.git"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.synth\.enable

Whether to enable synthesizer and MIDI device tooling\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.termFontSize

Terminal font size

_Type:_
floating point number

_Default:_

```nix
12.0
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.tugraz\.enable

Whether to enable TU Graz infrastructure\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.tugraz\.enableExternal

Whether to enable settings for externally managed desktop\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.tugraz\.enableOrca

Whether to enable Orca screen reader support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.useGhosttyGtkFix

Build Ghostty with GTK 4\.17\.6

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.useGraphicalSystem

Use graphical system by default, otherwise use text-based system

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.useInternalInfrastructure

Use internal infrastructure of omega

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.useSecrets

Use secrets handling of omega

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.useSharedKey

Use shared keys of omega

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.userEmail

Email of the default user

_Type:_
string

_Default:_

```nix
"patrizio@bekerle.com"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.userLogin

User login of the default user

_Type:_
string

_Default:_

```nix
"omega"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.userNameLong

User full name of the default user

_Type:_
string

_Default:_

```nix
"Patrizio Bekerle"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.userNameShort

User short name of the default user

_Type:_
string

_Default:_

```nix
"Patrizio"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.users

List of users that should be created by hokage

_Type:_
list of string

_Default:_

```nix
[
  "omega"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.usersWithRoot

List of users, including root

_Type:_
list of string _(read only)_

_Default:_

```nix
[
  "omega"
  "root"
]
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.waylandSupport

Wayland is the default, otherwise use X11

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.enable

Whether to enable ZFS support\.

_Type:_
boolean

_Default:_

```nix
false
```

_Example:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.arcMax

Maximum size of ARC (Adaptive Replacement Cache) in bytes

_Type:_
signed integer

_Default:_

```nix
1610612736
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.datasetRootName

Name of the root dataset of the ZFS pool

_Type:_
string

_Default:_

```nix
""
```

_Example:_

```nix
"root"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.devNodes

Override boot\.zfs\.devNodes to control which directory ZFS scans for
pool devices\. Useful for VMs with virtio disks that do not reliably
appear under /dev/disk/by-id (the ZFS default)\. Leave empty to keep
the ZFS default\.

_Type:_
string

_Default:_

```nix
""
```

_Example:_

```nix
"/dev/disk/by-path"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.encrypted

Define if the ZFS datasets are encrypted

_Type:_
boolean

_Default:_

```nix
true
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.hostId

Host ID for ZFS, generate with ‘just zfs-generate-host-id’

_Type:_
string

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.maxKernelVersion

Maximum allowed kernel package vor ZFS

_Type:_
package _(read only)_

_Default:_

```nix
<derivation linux-7.2.5>
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.poolName

Name of your ZFS pool

_Type:_
string

_Default:_

```nix
"zroot"
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.useSystemdInitrd

Enable the systemd-based stage-1 initrd (boot\.initrd\.systemd\.enable)\.
Required on some VMs so the ZFS encryption passphrase prompt appears
early enough in the boot sequence\.

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)

## hokage\.zfs\.useUnstable

Use pkgs\.zfs_unstable for zfs\.package when true (otherwise use pkgs\.zfs)\.

_Type:_
boolean

_Default:_

```nix
false
```

_Declared by:_

- [/nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage](file:///nix/store/j6f4856dayqr822a44df2ykaxa46y18k-source/modules/hokage)
