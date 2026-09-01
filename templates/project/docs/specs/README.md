# Specs

One directory per feature, named with a stable kebab-case slug:

```
docs/specs/<feature-slug>/
├── requirements.md   /spec       in / out / later scope, edge cases
├── lld.md            /lld        entities, classes, DSA fit, traces
├── hld.md            /hld        network, storage, concurrency, cache, security
└── plan.md           /plan       ordered tasks, each with a definition of done
```

`_templates/` holds the shape each document should take. The skills read it when
present, so editing a template changes every future document.

Not every feature needs every document. A bug fix may go straight to `plan.md`.
A new service needs all four.
