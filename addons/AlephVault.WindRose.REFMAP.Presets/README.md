# WindRose.REFMAP.Presets

This package contains preset definitions that depend on `AlephVault.WindRose.REFMAP`.

Use this package for ready-to-use combinations, defaults, and helpers that should not live in the base REFMAP package. The base package remains focused on reusable REFMAP visuals, traits, and utilities; this package composes those pieces into higher-level presets.

## Usage

The root namespace is:

```gdscript
AlephVault__WindRose__REFMAP__Presets
```

It exposes the following namespaces:

- `AlephVault__WindRose__REFMAP__Presets.Utils`
- `AlephVault__WindRose__REFMAP__Presets.Traits`
- `AlephVault__WindRose__REFMAP__Presets.Visuals`
- `AlephVault__WindRose__REFMAP__Presets.Examples`

## Public Classes

- `AlephVault__WindRose__REFMAP__Presets.Traits.People.Simple`: Simple REFMAP people traits plus `name`, `description`, and `message`.
- `AlephVault__WindRose__REFMAP__Presets.Traits.People.Standard`: Standard REFMAP people traits plus `name`, `description`, and `message`.
- `AlephVault__WindRose__REFMAP__Presets.Visuals.People.Simple`: Simple REFMAP people visual with name, description, and message labels.
- `AlephVault__WindRose__REFMAP__Presets.Visuals.People.Standard`: Standard REFMAP people visual with name, description, and message labels.

## Examples

The standard citizen example is available at:

```text
addons/AlephVault.WindRose.REFMAP.Presets/examples/standard-citizen/sample-aleph-vault-refmap-presets-standard-citizen-usage.tscn
```

It creates one `Simple.MapEntity` with `Standard` citizen traits and a `Standard` citizen visual. The example assigns REFMAP component traits plus `name`, `description`, and `message` values to demonstrate label rendering and text normalization.
