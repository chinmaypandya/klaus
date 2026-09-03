# Specs

One directory per feature, named with a stable kebab-case slug. Talk to
`/klaus` and it manages this structure for you; the layout below is what it
produces (and what `/spec`, `/lld`, etc. produce if invoked directly).

```
docs/specs/<feature-slug>/
├── state.md             /klaus     phase, status, resume pointer — read first
├── requirements-qa.md   /spec      one question at a time, updated in place
├── requirements.md                 written when the Q&A above closes
├── lld-qa.md            /lld       entities, then class-design, one at a time
├── lld.md                          entities, classes, DSA fit, traces
├── hld-qa.md            /hld       only created if HLD applies
├── hld.md                          network, storage, concurrency, cache, security
└── plan.md              /plan      ordered tasks, each with a definition of done
```

`_templates/` holds the shape each document should take. The skills read it
when present, so editing a template changes every future document of that
kind — including ones written by `/klaus`.

Not every feature needs every document. A bug fix may resume straight into
`plan.md`. A new service needs the whole chain.

`state.md` is the one file worth reading first if you're picking up a feature
after time away — it names the phase, and the resume pointer says exactly
where to continue.