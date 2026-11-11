# Multivariate degree testing via symbolic FRI on Kronecker encodings

A multivariate polynomial is committed, as in FRI-based systems, by reading its coefficient vector
as one univariate polynomial: the Kronecker image $F(X)=f(X,X^k,\dots,X^{k^{m-1}})$ of a
polynomial whose individual degrees are below $k$. Ordinary FRI on that word certifies only the
individual degrees fixed by the encoding. Replacing the scalar folding challenge of round $i$ by a
symbolic one, $r_iT^{w_i}$, makes the last message of the protocol the polynomial
$G(T)=f(r_1T^{w_1},\dots,r_mT^{w_m})$, whose degree in $T$ is the weighted degree
$\deg_wf=\max\{\langle w,\alpha\rangle: f_\alpha\ne0\}$ of $f$; the verifier checks $\deg G\le D$,
and the oracles carry values in $\mathbb F[T]$. With $w=\mathbf 1$ the test certifies the total
degree, with $w=e_l$ the degree in $x_l$. Soundness is proved up to the Johnson radius, as a
reduction to the correlated-agreement theorems of Ben-Sasson, Carmon, Ishai, Kopparty and Saraf,
through two observations: those theorems remain valid when the code lives over an extension of the
challenge field, and correlated agreement over curves passes to every linear subcode. The same
test also fixes the thresholds of a FRISS-style verifiable secret sharing scheme (Section 6.5 of
the paper), and a certificate of the total degree shortens the reduction of two evaluation claims
to one along a line (Section 6.6).

## Layout

- `proofs/` — the results first, one file per lemma, each with its statement, proof,
  `\uses`/`\usedby`, and a dependency graph (`proofs/dependencies.tex`). Self-contained: it states
  the definitions it needs and relies on no other document.
- `paper/` — the article, written after the proofs. `paper/main.tex` compiles the sections in
  `paper/sections/`, the bibliography is `paper/refs.bib`, and `paper/sections/09-notation.tex` is
  the index of notation (Appendix A).
- `code/` — a Rust prototype of the protocol at the IOP level (no Merkle trees, no Fiat–Shamir).

## Building the PDFs

The paper uses `pdflatex` with `bibtex`:

```sh
cd paper
pdflatex -interaction=nonstopmode main.tex
bibtex main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

The results file has no bibliography and needs two passes:

```sh
cd proofs
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Both build with zero errors and zero undefined references. TeX Live is enough; the paper uses
`amsmath`, `amsthm`, `mathtools`, `biblatex` (backend `bibtex`), `aliascnt`, `cleveref`,
`hyperref`, `tikz`, `booktabs` and `longtable`.

## Running the prototype

```sh
cd code
cargo build --release
cargo run --release -- 42      # 42 is the seed; the field is Goldilocks, p = 2^64 - 2^32 + 1
cargo test
```

`cargo test` succeeds with zero tests: the crate's checks are not unit tests but the six
experiments the binary runs (E1–E6: completeness, wrong claims, a truncated last message, a mixed
word, individual and weighted degrees), whose output also appears in Section 7 of the paper.
`cargo build --release` emits one `dead_code` warning for an unused helper (`sub`).

## Status

Complete draft. The results of `proofs/` are proved unconditionally from one recorded hypothesis,
which is discharged at the Johnson radius (Proposition 4.17) and in the unique-decoding regime
(Proposition 4.18); open questions are listed in Section 8 of the paper.

## Author

Abdelali Mkhida (Algorizk) — ORCID
[0009-0009-2101-9070](https://orcid.org/0009-0009-2101-9070).

