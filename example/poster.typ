// Example KInIT poster. Copy this file, replace the content, and run
//   ./build.sh path/to/your/poster.typ --png
// See README.md for the full authoring guide.

#import "../kinit-poster.typ": *

#show: poster.with(
  title: [Disinformation Capabilities of Large Language Models],
  authors: (
    (name: "Author One", affiliations: (1, 2)),
    (name: "Author Two", affiliations: (1,)),
    (name: "Author Three", affiliations: (1,)),
  ),
  affiliations: (
    "Kempelen Institute of Intelligent Technologies, Bratislava, Slovakia",
    "Faculty of Information Technology, Brno University of Technology, Brno, Czechia",
  ),
  why: [Automated disinformation generation is often cited as a key risk of
    large language models, yet the actual capability of current models to
    produce convincing false narratives is poorly understood.],
  results: [Ten models were asked to write news articles about twenty
    disinformation narratives. Most produced convincing, factually
    unsupported texts, and current detectors flag them only some of the time.],
  contact: (
    name: "Name Surname",
    role: "Research Assistant",
    institute: "Kempelen Institute of Intelligent Technologies",
    email: "name.surname@kinit.sk",
    web: "www.kinit.sk",
  ),
)

= Methodology

- We selected *20 disinformation narratives* across five domains: health,
  politics, conspiracy theories, regional topics, and history.
- Each of the 10 models generated 6 articles per narrative using two prompt
  styles, giving _1,200 texts_ in total.
- Human annotators and GPT-4 rated every article for style, agreement with
  the narrative, and the presence of safety disclaimers.

#kinit-table(
  header: ("Model", "Size", "Model Creator", "Cut-off"),
  rows: (
    ("GPT-3 Babbage v1", "1.3B", "OpenAI", "Oct 2019"),
    ("GPT-3 Curie v1", "6.7B", "OpenAI", "Oct 2019"),
    ("GPT-3 Davinci v3", "175B", "OpenAI", "Jun 2021"),
    ("GPT-3.5 (vs 0613)", "UNK", "OpenAI", "Sep 2021"),
    ("OPT-IML-Max", "30B", "Meta", "Unknown"),
    ("Falcon", "40B", "TII", "Feb 2023"),
    ("Vicuna", "33B", "LMSYS", "Unknown"),
    ("GPT-4 (vs 0613)", "UNK", "OpenAI", "Sep 2021"),
    ("Llama-2", "70B", "Meta", "Jan 2023"),
    ("Mistral", "7B", "Mistral AI", "Unknown"),
  ),
  group-after: 7,
)

= Key Findings

*Most models comply.* Only two models refused a substantial share of the
prompts; the rest wrote fluent articles that supported the requested
narrative.

== Safety filters

Disclaimers were rare and inconsistent. Where present, they were usually
appended after an otherwise complete disinformation article.

#colbreak()

#figure(
  image("figures/results.svg"),
  caption: [Share of generated articles that agree with the disinformation
    narrative, by model.],
)

= Detection

- Fine-tuned detectors reach high accuracy on in-distribution data but drop
  sharply on unseen models.
- Zero-shot detectors are close to random for the strongest models.

= Human Evaluation

#figure(
  image("figures/agreement.svg"),
  caption: [Annotator agreement per evaluation dimension.],
)

= Conclusion

- Current models are *capable disinformation generators* out of the box.
- Safety filters help, but only in a minority of models and prompts.
- Detection remains an open problem; we release the dataset to support it.
