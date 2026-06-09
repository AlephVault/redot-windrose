# WindRose.REFMAP.Presets

This package contains preset definitions that depend on `AlephVault.WindRose.REFMAP`.

Use this package for ready-to-use combinations, defaults, and helpers that should not live in the base REFMAP package. The base package remains focused on reusable REFMAP visuals, traits, and utilities; this package may compose those pieces into higher-level presets.

## Usage

The root namespace is:

```gdscript
AlephVault__WindRose__REFMAP__Presets
```

It exposes the following namespaces:

- `AlephVault__WindRose__REFMAP__Presets.Utils`
- `AlephVault__WindRose__REFMAP__Presets.Traits`
- `AlephVault__WindRose__REFMAP__Presets.Visuals`

The package also exposes `AlephVault__WindRose__REFMAP__Presets.REFMAP` as a direct alias to `AlephVault__WindRose__REFMAP` for preset code that needs to reference the base package explicitly.

## Public Classes

No concrete presets are defined yet. Add new preset modules under `utils/`, `traits/`, or `visuals/`, then export them from the matching `index.gd` file.
