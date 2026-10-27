// KInIT A0 poster template for Typst.
//
// Usage (see example/poster.typ):
//
//   #import "../kinit-poster.typ": *
//   #show: poster.with(title: [...], authors: (...), affiliations: (...), ...)
//   = Section
//   - bullet
//
// Authors edit their poster file only; this file holds the layout and theme.

// ---------------------------------------------------------------- palette
#let yellow  = rgb("#FFC000")
#let gold    = rgb("#FAB118")
#let crimson = rgb("#B21230")
#let dark    = rgb("#3A2222")
#let ink     = rgb("#1E101C")
#let grey    = rgb("#EDEDED")
#let link-blue = rgb("#0563C1")

#let head-font = "Roboto"
#let body-font = "Hammersmith One"
#let quote-font = "Ultra"

// Hammersmith One ships only a Regular face; emulate bold with a thin outline
// stroke, exactly like the original PowerPoint template does.
#let fbold(body, fill: ink, w: 0.5pt) = text(fill: fill, stroke: w + fill, body)

// Small crimson square, optionally carrying a white numeral.
#let sq(numeral: none) = rect(
  width: 11.5mm, height: 10.8mm, fill: crimson, stroke: none, inset: 0pt,
  if numeral != none {
    align(center + horizon, text(font: head-font, fill: white, size: 22pt, numeral))
  },
)

// ------------------------------------------------------------ page geometry
#let page-w = 841mm
#let page-h = 1189mm
#let col-w = 358mm
#let gutter = 47mm
#let margin-x = 39mm      // (841 - 2*358 - 47) / 2 = 39
#let body-top = 186mm     // below the header band
#let footer-y = 1163mm    // top of the wave

// ------------------------------------------------------- header and footer
// Drawn in the page background at the coordinates measured from the
// reference template, so body text can never push them around.
#let header(title, authors, affiliations) = {
  place(dx: 28mm, dy: 14mm, sq())
  place(dx: 39mm, dy: 25mm, rect(
    width: 588mm, height: 150mm, fill: yellow, stroke: none,
    radius: (top-right: 14mm, bottom-right: 14mm),
  ))
  place(dx: 71mm, dy: 35mm, block(
    width: 507mm, height: 90mm,
    align(left + top, text(font: head-font, weight: "bold", size: 90pt, fill: dark, title)),
  ))
  let author-line = authors.map(a => {
    let affs = a.at("affiliations", default: ())
    a.name + super(affs.map(str).join(","))
  }).join(", ")
  place(dx: 63mm, dy: 118mm, block(
    width: 486mm, height: 25mm, fill: crimson, inset: (x: 10mm),
    align(left + horizon, text(font: head-font, weight: "bold", size: 31pt, fill: yellow, author-line)),
  ))
  place(dx: 63mm, dy: 145mm, block(
    width: 480mm,
    text(font: head-font, weight: "bold", size: 24pt, fill: dark,
      affiliations.enumerate().map(((i, a)) => str(i + 1) + " " + a).join(linebreak())),
  ))
  place(dx: 549mm, dy: 98mm, image("assets/mascot.svg", width: 90mm, height: 104mm, fit: "contain"))
  place(dx: 646mm, dy: 25mm, image("assets/kinit-logo.svg", width: 124mm, height: 75mm, fit: "contain"))
  place(dx: 646mm, dy: 114mm, image("assets/but-logo.svg", width: 156mm, height: 50mm, fit: "contain"))
}

#let footer = place(dx: 0mm, dy: footer-y,
  image("assets/wave.svg", width: page-w, height: 15mm, fit: "stretch"))

// Opening quotation mark plus the "Why?" / "Results." lead paragraphs.
#let intro(why, results) = {
  block(height: 20mm, place(dy: -2mm, text(font: quote-font, size: 90pt, fill: gold, "\u{201C}")))
  if why != none { par(fbold[Why?] + h(0.6em) + why) }
  if results != none { par(fbold[Results.] + h(0.6em) + results) }
}

// Yellow section bar with the crimson numeral square overlapping its corner.
#let section-bar(title, numeral) = block(
  width: 100%, height: 26mm, fill: yellow, above: 14mm, below: 8mm, breakable: false,
  {
    place(top + left, dx: -11mm, dy: -8mm, sq(numeral: numeral))
    align(center + horizon, text(font: head-font, weight: "bold", size: 45pt, fill: dark, title))
  },
)

// Table in the poster style: crimson header row, yellow body rows, thin white
// rules. `group-after: n` draws a heavy black rule below body row n (1-based),
// e.g. to separate open from closed models.
#let kinit-table(header: (), rows: (), group-after: none, columns: auto) = {
  let ncols = header.len()
  let cols = if columns == auto { (1fr,) * ncols } else { columns }
  let brk = if group-after == none { -1 } else { group-after }
  block(width: 100%, above: 10mm, below: 10mm, breakable: false,
    table(
      columns: cols, inset: (x: 4mm, y: 4.5mm),
      fill: (x, y) => if y == 0 { crimson } else { yellow },
      stroke: (x, y) => {
        let thin = 1.2pt + white
        let heavy = 3pt + black
        (left: thin, right: thin,
         top: if y == brk + 1 { heavy } else { thin },
         bottom: if y == brk { heavy } else { thin })
      },
      ..header.map(h => fbold(fill: white, text(size: 30pt, h))),
      ..rows.flatten().map(c => text(size: 26pt, c)),
    ),
  )
}

// "Let's Stay in Touch!" box: k-mark plus name, role, institute and links.
#let contact-box(c) = {
  heading(level: 1, c.at("heading", default: "Let's Stay in Touch!"))
  let web = c.at("web", default: none)
  let email = c.at("email", default: none)
  grid(
    columns: (44mm, 1fr), column-gutter: 8mm, align: horizon,
    image("assets/kinit-k.svg", width: 44mm, height: 43mm, fit: "contain"),
    text(size: 28pt, {
      fbold(fill: gold, c.name)
      if "role" in c { [ | ]; fbold(c.role) }
      linebreak()
      if "institute" in c { c.institute; linebreak() }
      if email != none { link("mailto:" + email, email) }
      if email != none and web != none { [ | ] }
      if web != none {
        let url = if web.starts-with("http") { web } else { "https://" + web }
        link(url, text(fill: link-blue, underline(web)))
      }
    }),
  )
}

// ------------------------------------------------------------- the poster
#let poster(
  title: [Title],
  authors: (),
  affiliations: (),
  why: none,
  results: none,
  contact: none,
  body,
) = {
  set page(
    width: page-w, height: page-h,
    margin: (top: body-top, left: margin-x, right: margin-x, bottom: page-h - footer-y + 8mm),
    columns: 2,
    background: header(title, authors, affiliations) + footer,
  )
  set columns(gutter: gutter)
  set text(font: body-font, size: 32pt, fill: ink)
  set par(leading: 0.55em, spacing: 1.0em, justify: false)

  // `= Heading` becomes a numbered section bar; numbering runs down the
  // left column and continues in the right one.
  set heading(numbering: "I")
  show heading.where(level: 1): it => section-bar(it.body, counter(heading).display("I"))
  show heading.where(level: 2): it => block(above: 10mm, below: 7mm, width: 100%,
    fbold(fill: crimson, text(size: 34pt, it.body)))

  // Bullets get a yellow dot; *strong* is crimson faux-bold.
  set list(marker: box(baseline: -2pt, circle(radius: 6pt, fill: yellow)),
    indent: 4mm, body-indent: 6mm, spacing: 1.1em)
  show strong: it => fbold(fill: crimson, it.body)

  // Figures get the framed grey box and a "Figure N: ..." caption below.
  set image(width: 100%)
  set figure(gap: 5mm)
  show figure.where(kind: image): it => block(above: 10mm, below: 10mm, breakable: false, {
    block(width: 100%, fill: grey, stroke: 1pt + dark, inset: 8mm, it.body)
    if it.caption != none {
      block(width: 100%, above: 5mm, align(center, text(size: 26pt, it.caption)))
    }
  })

  intro(why, results)
  body
  // Pin the contact box to the bottom of whichever column the body ended in
  // (normally the right one).
  if contact != none {
    place(bottom + left, float: true, clearance: 10mm, contact-box(contact))
  }
}
