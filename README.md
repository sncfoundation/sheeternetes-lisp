<p align="center">
  <img src="https://sncfoundation.github.io/logos/lisp.svg" width="96" alt="Lisp client logo">
</p>

<h1 align="center">Lisp client</h1>

<p align="center"><b>Homoiconic orchestration from the REPL</b><br>
A <a href="https://sncfoundation.github.io">Sheet-Native Computing Foundation</a> project &#183; analog of <b>a Lisp SDK</b></p>

---

**Status:** 💾 Autosaving &#183; promoted from Unsaved Draft. Working code, released as [v0.1.0](https://github.com/sncfoundation/sheeternetes-lisp/releases/tag/v0.1.0), and the [tracking issue #29](https://github.com/sncfoundation/sheeternetes/issues/29) is closed. Google keeps saving it.

## About

Homoiconic orchestration from the REPL Part of the spreadsheet-native stack — the Sheet stays the source of truth, and it reconciles.

## Get involved

- 📋 Tracking issue &amp; design: [sncfoundation/sheeternetes#29](https://github.com/sncfoundation/sheeternetes/issues/29) (closed)
- 🗺️ [SNCF Landscape](https://sncfoundation.github.io/landscape.html)
- 🧩 [All projects](https://sncfoundation.github.io/projects.html)
- ⚖️ [Governance &amp; how to contribute](https://github.com/sncfoundation/governance)
- 🎓 [Get certified (CSFE)](https://sncfoundation.github.io/certification.html)

## Status legend

Everything starts as an **Unsaved Draft**. It reconciles up the tiers from there — see the
[maturity model](https://sncfoundation.github.io/foundation.html#maturity).

---

<sub>Licensed under Apache-2.0. The SNCF does not recommend running production on a spreadsheet. If you do, please film it.</sub>


## Usage

Requires [SBCL](http://www.sbcl.org/) and [Quicklisp](https://www.quicklisp.org/) with
`dexador` and `yason`.

```bash
export WEBAPP_URL="https://script.google.com/macros/s/XXXX/exec"
export TOKEN="CHANGE_ME_super_secret"

sbcl --non-interactive --load skctl.lisp -- get pods
sbcl --non-interactive --load skctl.lisp -- get deployments
sbcl --non-interactive --load skctl.lisp -- scale hello 3
sbcl --non-interactive --load skctl.lisp -- apply manifest.json
sbcl --non-interactive --load skctl.lisp -- delete hello
```

From the REPL:

```lisp
(load "skctl.lisp")
(in-package :sheeternetes)
(get-resource "nodes")
(scale "hello" 5)
```

Parentheses and spreadsheets share a deep love of nesting. Homoiconic orchestration — it reconciles.

