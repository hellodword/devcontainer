
# Android SDK (android-sdk)

Install Android SDK `cmdline-tools`, `platform-tools`, `ndk` and, `build-tools`.
The ~/.android will persisted in .mount/.android.
`"runArgs": [ "--device-cgroup-rule", "c 189:* rmw" ]` is required for usb.

## Example Usage

```json
"features": {
    "ghcr.io/hellodword/devcontainer/android-sdk:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| platform | SDK platform version | string | 34 |
| ndk | NDK version | string | 26.1.10909125 |
| build_tools | SDK build-tools version | string | 34.0.0 |
| base_packages | packages will override default packages, split by space | string | - |
| extra_packages | extra packages, split by space | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/hellodword/devcontainer/blob/main/src/android-sdk/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
