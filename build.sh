#!/usr/bin/env sh
# Build a KInIT poster and verify the PDF is print-ready.
#
#   ./build.sh                      # builds example/poster.typ -> example/poster.pdf
#   ./build.sh my/poster.typ        # builds my/poster.typ -> my/poster.pdf
#   ./build.sh my/poster.typ --png  # also writes a 40 dpi PNG preview next to the PDF
#
# Needs: typst (https://typst.app/open-source), and poppler-utils
# (pdfinfo/pdffonts/pdfimages) for the checks; the checks are skipped with a
# warning when poppler is missing.
set -eu

ROOT=$(cd "$(dirname "$0")" && pwd)
SRC=${1:-"$ROOT/example/poster.typ"}
PNG=0
for arg in "$@"; do [ "$arg" = "--png" ] && PNG=1; done
case "$SRC" in --png) SRC="$ROOT/example/poster.typ" ;; esac
OUT="${SRC%.typ}.pdf"

if ! command -v typst >/dev/null 2>&1; then
  echo "error: typst not found. Install it from https://typst.app/open-source" >&2
  echo "       (brew install typst | winget install Typst.Typst | cargo install typst-cli)" >&2
  exit 1
fi

typst compile --root "$ROOT" --font-path "$ROOT/fonts" --ignore-system-fonts "$SRC" "$OUT"
echo "built $OUT"

if ! command -v pdfinfo >/dev/null 2>&1; then
  echo "warning: poppler-utils not found; skipping PDF checks" >&2
  exit 0
fi

status=0

pages=$(pdfinfo "$OUT" | awk '/^Pages:/ {print $2}')
if [ "$pages" != "1" ]; then
  echo "error: poster has $pages pages; content overflows the A0 page." >&2
  echo "       Shorten text, reduce figure heights, or move content across #colbreak()." >&2
  status=1
fi

size=$(pdfinfo "$OUT" | awk -F': *' '/^Page size:/ {print $2}')
case "$size" in
  *"(A0)"*) ;;
  *) echo "error: page size is '$size', expected A0" >&2; status=1 ;;
esac

notemb=$(pdffonts "$OUT" | tail -n +3 | awk '$(NF-4) != "yes" {print $1}')
if [ -n "$notemb" ]; then
  echo "error: fonts not embedded: $notemb" >&2
  status=1
fi

rasters=$(pdfimages -list "$OUT" | tail -n +3 | wc -l | tr -d ' ')
echo "raster images in PDF: $rasters (the template adds none; any listed come from your figures)"

if [ "$PNG" = 1 ]; then
  if command -v pdftoppm >/dev/null 2>&1; then
    pdftoppm -r 40 -png -singlefile "$OUT" "${OUT%.pdf}"
    echo "preview ${OUT%.pdf}.png"
  else
    echo "warning: pdftoppm not found; skipping PNG preview" >&2
  fi
fi

[ "$status" = 0 ] && echo "all checks passed"
exit $status
