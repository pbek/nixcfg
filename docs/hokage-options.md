## hokage\.audio\.enable

Whether to enable Enable audio system\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.cache\.enable

Whether to enable cache service\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.cache\.sources

List of cache sources to enable

_Type:_
list of (one of “home”, “remote”, “caliban”)

_Default:_

```
[
  "remote"
]
```

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.excludePackages

List of default packages to exclude from the configuration

_Type:_
list of package

_Default:_
`[ ]`

_Example:_
`[ pkgs.qownnotes ]`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.gaming\.enable

Whether to enable Enable Gaming\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.gaming\.ryubing\.highDpi

Whether to enable Enable high-dpi for ryubing\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.hostName

Hostname of the system

_Type:_
string

_Default:_
`""`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.kernel\.enable

Whether to enable automatic kernel selection based on requirements

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.kernel\.maxVersion

Maximum allowed kernel version

_Type:_
package

_Default:_
`<derivation linux-6.17.7>`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.kernel\.requirements

List of kernel packages required by various modules

_Type:_
list of package

_Default:_
`[ ]`

_Example:_
`[ ]`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.kernel\.selectedKernel

The automatically selected kernel package (lowest from requirements)

_Type:_
package _(read only)_

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.cplusplus\.enable

Whether to enable Enable C++ development support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.cplusplus\.ide\.enable

Whether to enable Enable C++ IDEs\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.cplusplus\.qt6\.enable

Whether to enable Enable Qt6 for IDEs\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.go\.enable

Whether to enable Enable Go development support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.go\.ide\.enable

Whether to enable Enable Go IDE\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.javascript\.enable

Whether to enable Enable Javascript development support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.javascript\.ide\.enable

Whether to enable Enable Javascript IDE\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.php\.enable

Whether to enable Enable PHP development support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.languages\.php\.ide\.enable

Whether to enable Enable PHP IDE\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.lowBandwidth

Don’t install all packages or use stable versions to save bandwidth

_Type:_
boolean

_Default:_
`false`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.enable

Whether to enable NVIDIA graphics support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.package

Nvidia driver package to use (overrides packageType if set)

_Type:_
null or package

_Default:_
`null`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.packageType

Type of NVIDIA driver package to use

_Type:_
one of “stable”, “latest”, “beta”, “production”, “legacy_535”

_Default:_
`"latest"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.modesetting\.enable

Whether to enable NVIDIA DRM modesetting (required for some Wayland compositors, e\.g\. Sway)\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.open

Whether to enable Open NVIDIA drivers (NVIDIA open-gpu-kernel-modules)\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.nvidia\.powerManagement\.enable

Whether to enable NVIDIA power management\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.plasma\.enable

Whether to enable Enable KDE Plasma\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.plasma\.enableOld

Whether to enable Enable plasma with old KDE packages\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.aider\.enable

Whether to enable Enable Aider AI code completion tool\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.atuin\.enable

Whether to enable Enable Atuin shell history\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.espanso\.enable

Whether to enable Enable Espanso to expand text\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.git\.enable

Whether to enable Enable Git integration\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.git\.enableUrlRewriting

Whether to enable Enable URL rewriting from HTTPS to SSH\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.enable

Whether to enable Enable JetBrains IDEs support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.clion\.enable

Whether to enable Enable CLion support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.clion\.package

The clion package to use\.

_Type:_
package

_Default:_
`pkgs.clion`

_Example:_
`clion`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.goland\.enable

Whether to enable Enable Goland support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.goland\.package

The goland package to use\.

_Type:_
package

_Default:_
`pkgs.goland`

_Example:_
`goland`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.phpstorm\.enable

Whether to enable Enable PhpStorm support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.phpstorm\.package

The phpstorm package to use\.

_Type:_
package

_Default:_
`pkgs.phpstorm`

_Example:_
`phpstorm`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.plugins

List of JetBrains plugin IDs or names to install\. See
https://github\.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/plugins/plugins\.json
for a list of plugins\.

_Type:_
list of (string or package)

_Default:_

```
[
  "github-copilot"
  "nixidea"
]
```

_Example:_

```
[
  "github-copilot"
]
```

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.jetbrains\.useStable

Whether to enable Use stable JetBrains packages\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.libvirt\.enable

Whether to enable Enable libvirt support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.libvirt\.gui\.enable

Whether to enable Enable VirtManager\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.libvirt\.role

Role of the libvirt system

_Type:_
one of “host”, “guest”

_Default:_
`"host"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.nixbit\.enable

Whether to enable Nixbit configuration\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.nixbit\.package

The Nixbit package to install

_Type:_
package

_Default:_
`<derivation nixbit-0.1.5>`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.nixbit\.forceAutostart

Whether to enable Force creation of autostart desktop entry when application starts\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.nixbit\.repository

Git repository URL for Nixbit

_Type:_
string

_Default:_
`"https://github.com/pbek/nixcfg.git"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.nushell\.enable

Whether to enable Enable Nushell\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.pia\.enable

Whether to enable Enable Private Internet Access\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.platformio\.enable

Whether to enable Enable PlatformIO support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.qtcreator\.enable

Whether to enable Enable qtcreator\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.qtcreator\.package

The QtCreator package to install

_Type:_
package

_Default:_
`<derivation qtcreator-17.0.2>`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.starship\.enable

Whether to enable Enable Starship support\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.uutils\.enable

Whether to enable Turn on uutils replacements for GNU utils, changes seems to need reboot\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.uutilsAliases\.enable

Whether to enable Add aliases for uutils to replace GNU coreutils in the shell\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.virtualbox\.enable

Whether to enable Enable VirtualBox\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.virtualbox\.maxKernelVersion

Maximum allowed kernel package vor VirtualBox

_Type:_
package _(read only)_

_Default:_
`<derivation linux-6.17.7>`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.virtualbox\.role

Role of the VirtualBox system

_Type:_
one of “host”, “guest”

_Default:_
`"host"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.programs\.yazi\.enable

Whether to enable Enable Yazi terminal file manager\.

_Type:_
boolean

_Default:_
`true`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.role

Role of the system

_Type:_
one of “desktop”, “server-home”, “server-remote”, “ally”

_Default:_
`"desktop"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.serverMba\.enable

Whether to enable Enable MBA server configuration\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.termFontSize

Terminal font size

_Type:_
floating point number

_Default:_
`12.0`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.tugraz\.enable

Whether to enable Enable TU Graz infrastructure\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.tugraz\.enableExternal

Whether to enable Enable settings for externally managed desktop\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.tugraz\.enableOrca

Whether to enable Enable Orca screen reader support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.useGhosttyGtkFix

Build Ghostty with GTK 4\.17\.6

_Type:_
boolean

_Default:_
`false`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.useGraphicalSystem

Use graphical system by default, otherwise use text-based system

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.useInternalInfrastructure

Use internal infrastructure of omega

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.useSecrets

Use secrets handling of omega

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.useSharedKey

Use shared keys of omega

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.userEmail

Email of the default user

_Type:_
string

_Default:_
`"patrizio@bekerle.com"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.userLogin

User login of the default user

_Type:_
string

_Default:_
`"omega"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.userNameLong

User full name of the default user

_Type:_
string

_Default:_
`"Patrizio Bekerle"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.userNameShort

User short name of the default user

_Type:_
string

_Default:_
`"Patrizio"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.users

List of users that should be created by hokage

_Type:_
list of string

_Default:_

```
[
  "omega"
]
```

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.usersWithRoot

List of users, including root

_Type:_
list of string _(read only)_

_Default:_

```
[
  "omega"
  "root"
]
```

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.waylandSupport

Wayland is the default, otherwise use X11

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.enable

Whether to enable Enable ZFS support\.

_Type:_
boolean

_Default:_
`false`

_Example:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.arcMax

Maximum size of ARC (Adaptive Replacement Cache) in bytes

_Type:_
signed integer

_Default:_
`1610612736`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.datasetRootName

Name of the root dataset of the ZFS pool

_Type:_
string

_Default:_
`""`

_Example:_
`"root"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.encrypted

Define if the ZFS datasets are encrypted

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.hostId

Host ID for ZFS, generate with ‘just zfs-generate-host-id’

_Type:_
string

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.maxKernelVersion

Maximum allowed kernel package vor ZFS

_Type:_
package _(read only)_

_Default:_
`<derivation linux-6.17.7>`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.poolName

Name of your ZFS pool

_Type:_
string

_Default:_
`"zroot"`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)

## hokage\.zfs\.useUnstable

Use pkgs\.zfs_unstable for zfs\.package when true (otherwise use pkgs\.zfs)\.

_Type:_
boolean

_Default:_
`true`

_Declared by:_

- [/nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage](file:///nix/store/g9gd12zg526p4lnj7wlr877ns8pap7s1-source/modules/hokage)
