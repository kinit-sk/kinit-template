# Fonts

Vendored so the poster renders identically everywhere. Pass
`--font-path fonts --ignore-system-fonts` to Typst (build.sh does this).

| Family | Files | Role | License |
|---|---|---|---|
| Roboto | `Roboto-{Regular,Bold,Italic,BoldItalic}.ttf` | title, author bar, section bars | SIL OFL 1.1 (`LICENSE-Roboto.txt`) |
| Hammersmith One | `HammersmithOne-Regular.ttf` | body text, tables, captions | SIL OFL 1.1 (`LICENSE-HammersmithOne.txt`) |
| Ultra | `Ultra-Regular.ttf` | opening quotation mark | Apache 2.0 (`LICENSE-Ultra.txt`) |

Sources: [google/fonts](https://github.com/google/fonts) `ofl/roboto`,
`ofl/hammersmithone`, `apache/ultra`. Google Fonts ships Roboto only as a
variable font; the static instances here were generated with
`fontTools.varLib.instancer` at `wdth=100`, `wght=400/700`.

Hammersmith One and Ultra have no bold or italic faces. The template fakes
bold with a thin outline stroke, matching the original PowerPoint template.
