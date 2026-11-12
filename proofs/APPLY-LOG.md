# Apply log (Phase 1a-apply)

Branch `restructure`, six steps, one commit each, every one compiled with
`latexmk -pdf -interaction=nonstopmode main.tex` before committing.

## 1. Steps

| step | applied | build | commit |
|---|---|---|---|
| 0 | 0a (`L16-distance.tex`, steps 3--4 of `lem:avss-dist`), 0b (`T1-soundness.tex:39`); plus the Phase 1a report itself | clean: 0 errors, 0 undefined, 0 multiply-defined, 2 overfull (the two present before) | `202f0a2` |
| 1 | F11 (six annotations, `\ref`$\to$`\cref`), `\setcounter{definition}{7}` deleted, `dependencies.tex` rewritten with `\cref`, F12 | clean | `1b3d058` |
| 2 | C1, C2, C3, C4, C6 | clean | `f2d88e8` |
| 3 | B1, B2 ($b$ and $c$ only), B3, B4, B5, B6, B7, B8, B9 | clean | `b4dc748` |
| 4 | C7, C8, C9, C10, C12 (C5 not applied: B9 is it) | clean | `e4285e5` |
| 5 | D1, D3, D5--D10; F1, F2, F3, F4, F7, F9, F10. **F5, F6, F8 not applied** (section 2.1) | clean | `032858b` |
| 6 | E1 with the `def:weights` split; `dependencies.tex` as an edge list | clean | `c5f7737` |

Final state: 22 pages, 0 errors, 0 undefined references, 0 multiply-defined labels, 1 overfull box
(against 18 pages and 2 overfull boxes before the changes).

Steps 1 and 2 were committed twice: the first version of each had picked up
`proofs/main.fdb_latexmk` and `proofs/main.fls` through `git add proofs/` (`.gitignore` does not
list them). Both commits were rebuilt from the same patches with those two files excluded; nothing
else differs. The branch has never been pushed.

## 2. Where the instructions could not be applied verbatim

### 2.1 Not applied: F5, F6, F8 (new letters already in use)

The request says to grep before using a new letter and, if it is taken, to stop and report rather
than choose another. Three of the letters it names are taken, so those three proposals are **not**
applied:

| proposal | letter | occurrences in `proofs/` | verdict |
|---|---|---|---|
| F5 ([BCIKS20]'s $k\mapsto\kappa$ in `external.tex`) | $\kappa$ | 19 | not applied |
| F6 (constraint index $s\mapsto c$ in `variants.tex`) | $c$ | the folding challenge $c_i=r_iT^{w_i}$ throughout, plus $\Fold_c$ | not applied |
| F8 ($T$-exponent $e\mapsto\eta$ in `lem:div`) | $\eta$ | 13 | not applied |

The three are independent of the rest of step 5; every other item of step 5 is in. Choosing the
letters is left to the author. Free letters in the same block, for reference: $\lambda$ and
$\Lambda$ were unused and are now used by F4 and F7 respectively.

### 2.2 Places where the given text could not go in verbatim

1. **Step 1, `T1-soundness.tex:20`.** `\cref{cor:johnson,cor:ud}` makes cleveref warn
   "`cref reference format for label type 'consequence' undefined`": `macros.tex` sets
   `\crefname{consequence}` but no plural format, so a `\cref` of two consequences does not
   compile cleanly. Written as `\usedby{\cref{cor:johnson} and \cref{cor:ud}}`. If the author
   prefers the single-`\cref` form, add `\crefmultiformat{consequence}` to `macros.tex`.
2. **Step 0a.** The replacement text cites `\cref{lem:roots}`, which does not exist until step 2.
   At step 0 the parenthetical reads "a nonzero polynomial of degree $<2^{2\tau}$ has fewer than
   $2^{2\tau}$ roots", and step 2 (C1) replaced that clause by `\cref{lem:roots}` with
   $D=2^{2\tau}$.
3. **Step 2, C3, intermediate state.** `completeness.tex` cited `\cref{lem:stab}(c)`, so at step 2
   `lem:stab` kept its items lettered `(b)` and `(c)` with `(a)` removed. Step 3 moved `(c)` to
   `lem:stab-cap` and `completeness.tex` now cites `\cref{lem:stab-cap}`.
4. **Step 2, C4.** The identity was spelled out at seven sites. The sentence now sits in
   `def:domains`; the three sites that re-derived it (`L09:14`, `T1:54--55`, `protocol:26--28`) now
   cite `\cref{def:domains}`. The other two (`T1`'s "$Mn=N$", `lem:round-up`'s
   "$\rho|L_i|=k^{m-i}$") are substitutions of the identity and were left as they are.
5. **Step 3, B4.** The given `lem:round-up` cites `\cref{def:fibre-avg}`, which only exists from
   step 6. At step 3 the statement cited `\cref{def:weights}`; step 6 switched the citation and
   made `lem:lift` generic in $\mu,\nu$ so that `lem:round-up` applies it to
   $\mu^{(i-1)},\nu^{(i)}$.
6. **Step 3, B6a.** The report's `lem:avss-close` wrote $\hat h:=U_{h'}$ "with $h'$ as in
   `def:avss`", but `def:avss` defines $f'$ only for $f$, and $\hat h$ for $h=f+\theta e$ was
   nowhere defined (that is F10). At step 3 the lemma put $\hat h:=\hat f+\theta\hat e$; step 5
   (F10) added to `def:avss` the sentence that $(\cdot)'$ is $\F$-linear, hence
   $(f+\theta e)'=f'+\theta e'$ and $\hat h=\hat f+\theta\hat e$, and step 5 switched the
   statement to $\hat h:=U_{h'}$.
7. **Step 3, B2.** As instructed, `lem:stab-codes` was not created: `lem:stab` keeps the stability
   statement (the report's B2b) and `lem:stab-cap` is new. Both proofs cite `lem:subst`.
8. **Step 3, annotations.** The splits changed who cites what, so eight `\uses`/`\usedby` entries
   were corrected in the same step: `lem:div`, `lem:unfold`, `lem:lift` are now used by
   `lem:round-up` rather than `lem:round`; `lem:start` and `lem:no-increase` gained
   `lem:sound-fold`; `lem:round` gained `lem:sound-fold` as a user; `lem:rootsum` and `lem:subst`
   gained their new users; `lem:found`-side entries for `lem:ext-agree` were added (the round lemma
   needs item (2) as well as item (1) of the old `lem:ext`, so it now cites both).
9. **Step 5, D3 and D5.** Nothing was left to change: D3 is already the hypothesis of the
   `lem:fold-parts` created in step 3 (it has no degree bound on $P_j$), and D5 is the hypothesis of
   `lem:ext-agree`, also created in step 3.
10. **Step 5, F3.** The caps are an unnumbered `\paragraph{The caps.}` in `defs.tex`. The local
    definition was removed from `lem:stab-cap` (it had inherited it from `lem:stab`(c)) and from
    `def:protocol`, whose sentence "Put $d_0:=0$ and $d_i:=\dots$" is deleted whole, because the
    paragraph defines $d_0$ too.
11. **Step 5, F2.** Besides `cor:johnson`'s "$\rho:=k^m/N$", `def:avss`'s "$\rho:=2^{2\tau}/N$"
    became "$\rho=k^m/N=2^{2\tau}/N$ by `\cref{def:domains}`".
12. **Step 5, F4.** $[\E:\F]$ replaces the letter everywhere it carried the extension degree, so
    the basis is now $e_0,\dots,e_{[\E:\F]-1}$ and $\varphi:\F^{[\E:\F]}\to\E$.
13. **Step 6, files.** The order needed three results in places their old files could not reach, so
    three files were created and two were cut: `L02-sz-total.tex` (from `total-degree.tex`, which
    keeps the line lemma and the applications and is retitled "Total degree: lines and
    applications"), `L10b-counting.tex` (from `T1-soundness.tex`), and
    `external-acceptance.tex` (from `external.tex`, which keeps the two curve theorems and their
    remarks). `L10-lifting.tex` became "Fibre averages and lifting" and holds `def:fibre-avg` and
    `lem:lift`.
14. **Step 6, `lem:lift`.** Its statement is now generic in $\mu,\nu$ ("let $\mu$ be a weight on
    $L_{i-1}$ with fibre average $\nu$"), because with `def:fibre-avg` separate the transcript is no
    longer needed; the proof is unchanged with $\mu$ for $\mu^{(i-1)}$ and $\nu$ for
    $\nu^{(i)}$. This is the one place where a statement changed beyond a hypothesis: notation only.
15. **Step 6, annotations.** `def:protocol`, `def:weights`, `rem:multi`, `rem:separate` and
    `rem:char` had no `\uses` line; the edge list is generated from `\uses`, so each got one
    (and a `\usedby` where it had none). `lem:round`'s statement and proof now cite
    `def:fibre-avg` where they described the fibre average.
16. **Reflowing.** Two overfull boxes that my edits introduced were removed by reflowing the
    sentences (`C1-share.tex` opening, `cor:johnson`'s proof); no symbol changed. The count is now
    1 against the 2 that were there before.

## 3. The grep checks for the new letters

```
$ grep -rho '\\kappa' *.tex | wc -l
19
$ grep -rho '\\lambda' *.tex | wc -l
0
$ grep -rho '\\eta' *.tex | wc -l
13
$ grep -rho '\\Lambda' *.tex | wc -l
0

$ grep -rc '\\eta' *.tex | grep -v ':0$'
H-hypothesis.tex:5
P2-avss-soundness.tex:1
T1-soundness.tex:3
external.tex:2

$ grep -rc '\\kappa' *.tex | grep -v ':0$'
H-hypothesis.tex:3
T1-soundness.tex:4
external.tex:6

$ grep -rn 'c_l\|c_i' *.tex | wc -l     # the folding challenge c_i = r_iT^{w_i}
27
```

$\lambda$ and $\Lambda$ were free and are now used (F4 in `defs.tex:15`, F7 in `lem:subcode`).
$\kappa$, $\eta$ and $c$ are taken, which is why F5, F6 and F8 are not applied (section 2.1).

## 4. The labels in compiled order

69 labelled results, in the order the file now has them, with the number each one
compiles to. The numbering is positional, so it has shifted; nothing is hard-coded any more.

| # | label | number |
|---|---|---|
| 1 | `def:domains` | D1 |\n| 2 | `def:poly` | D2 |\n| 3 | `def:kron` | D3 |\n| 4 | `def:fold` | D4 |\n| 5 | `def:wdeg` | D5 |\n| 6 | `def:codes` | D6 |\n| 7 | `def:agree` | D7 |\n| 8 | `lem:roots` | L1 |\n| 9 | `lem:rootsum` | L2 |\n| 10 | `lem:subst` | L3 |\n| 11 | `lem:kron` | L4 |\n| 12 | `lem:inj` | L5 |\n| 13 | `lem:sz-total` | L6 |\n| 14 | `cor:box` | L6.1 |\n| 15 | `lem:fold-parts` | L7 |\n| 16 | `lem:fold-sub` | L8 |\n| 17 | `lem:fold-invert` | L9 |\n| 18 | `cor:terminal` | L9.1 |\n| 19 | `lem:stab` | L10 |\n| 20 | `lem:stab-cap` | L11 |\n| 21 | `lem:div` | L12 |\n| 22 | `lem:unfold` | L13 |\n| 23 | `lem:ext` | L14 |\n| 24 | `lem:ext-agree` | L15 |\n| 25 | `lem:subcode` | L16 |\n| 26 | `lem:gran` | L17 |\n| 27 | `def:fibre-avg` | D8 |\n| 28 | `lem:lift` | L18 |\n| 29 | `lem:bad-count` | L19 |\n| 30 | `ext:bciks72` | E1 |\n| 31 | `ext:proof-facts` | 2 |\n| 32 | `ext:bciks71` | E2 |\n| 33 | `ext:facts71` | 3 |\n| 34 | `hyp:ca` | H |\n| 35 | `prop:H1` | P-H1 |\n| 36 | `prop:H2` | P-H2 |\n| 37 | `cor:share` | C1 |\n| 38 | `def:protocol` | D9 |\n| 39 | `def:weights` | D10 |\n| 40 | `ext:claim85` | E3 |\n| 41 | `lem:start` | L20 |\n| 42 | `lem:no-increase` | L21 |\n| 43 | `lem:round-up` | L22 |\n| 44 | `lem:round` | L23 |\n| 45 | `lem:sound-fold` | L24 |\n| 46 | `thm:reduction` | T1 |\n| 47 | `cor:johnson` | C2 |\n| 48 | `cor:ud` | C3 |\n| 49 | `rem:char` | 5 |\n| 50 | `prop:complete` | P1 |\n| 51 | `rem:multi` | 6 |\n| 52 | `rem:separate` | 7 |\n| 53 | `def:avss` | D11 |\n| 54 | `lem:avss-bits` | L25 |\n| 55 | `rem:avss-y` | 8 |\n| 56 | `con:avss-mask` | D12 |\n| 57 | `rem:avss-threshold` | 9 |\n| 58 | `lem:avss-bad` | L26 |\n| 59 | `lem:avss-close` | L27 |\n| 60 | `lem:avss-dist` | L28 |\n| 61 | `prop:avss-sound` | P2 |\n| 62 | `lem:avss-uniform` | L29 |\n| 63 | `lem:avss-secret` | L30 |\n| 64 | `rem:avss-leak` | 10 |\n| 65 | `lem:avss-caps` | L31 |\n| 66 | `prop:avss-cost` | P3 |\n| 67 | `lem:line-total` | L32 |\n| 68 | `rem:total-app` | 11 |\n| 69 | `rem:total-prior` | 12 |

## 5. The dependency graph, and the check

The list is `dependencies.tex`, generated from the final `\uses` lines: `A -> B` means $B$ uses $A$.
69 labels, 143 edges.

```
def:wdeg -> lem:subst
def:kron -> lem:kron
def:domains, lem:kron, lem:roots -> lem:inj
def:wdeg, lem:roots -> lem:sz-total
lem:sz-total, def:wdeg, def:poly -> cor:box
def:fold, def:domains, lem:rootsum -> lem:fold-parts
lem:fold-parts, def:kron, lem:kron -> lem:fold-sub
def:fold, def:domains, lem:rootsum -> lem:fold-invert
lem:fold-sub -> cor:terminal
lem:fold-sub, lem:subst, def:codes -> lem:stab
lem:fold-sub, lem:subst, def:codes, def:wdeg -> lem:stab-cap
def:codes, lem:inj, lem:roots -> lem:div
def:kron, def:codes, lem:div, lem:inj, lem:fold-parts -> lem:unfold
def:codes -> lem:ext
def:codes, def:agree -> lem:ext-agree
def:agree, def:domains -> lem:gran
def:domains -> def:fibre-avg
def:agree, def:fibre-avg, def:domains -> lem:lift
ext:bciks72, ext:proof-facts -> hyp:ca
ext:bciks72, ext:proof-facts -> prop:H1
ext:bciks71, ext:facts71 -> prop:H2
hyp:ca, lem:subcode -> cor:share
def:domains, def:kron, def:fold -> def:protocol
def:fibre-avg, def:protocol, def:fold -> def:weights
def:codes, def:agree, def:kron -> lem:start
def:weights, def:agree -> lem:no-increase
def:domains, def:fibre-avg, lem:div, lem:fold-invert, lem:lift, lem:unfold -> lem:round-up
hyp:ca, cor:share, lem:round-up, lem:ext, lem:ext-agree, lem:gran -> lem:round
hyp:ca, lem:start, lem:round, lem:no-increase -> lem:sound-fold
lem:sound-fold, lem:bad-count, ext:claim85 -> thm:reduction
prop:H1, thm:reduction -> cor:johnson
prop:H2, thm:reduction -> cor:ud
ext:bciks72 -> rem:char
def:protocol, lem:stab-cap, cor:terminal, cor:box -> prop:complete
lem:inj, lem:fold-sub, lem:stab, lem:div, lem:unfold, lem:round, thm:reduction -> rem:multi
rem:multi -> rem:separate
def:domains, def:kron, def:codes -> def:avss
def:avss, def:wdeg -> lem:avss-bits
def:avss, def:kron, lem:avss-bits -> rem:avss-y
def:avss, def:protocol -> con:avss-mask
def:avss -> rem:avss-threshold
def:avss, def:agree -> lem:avss-close
def:avss, con:avss-mask, lem:avss-bits, lem:avss-close, lem:inj, lem:roots, def:codes, def:agree -> lem:avss-dist
def:avss, con:avss-mask, lem:avss-bad, lem:avss-dist, cor:ud -> prop:avss-sound
def:avss -> lem:avss-uniform
def:avss, con:avss-mask, def:protocol, lem:avss-uniform -> lem:avss-secret
con:avss-mask -> rem:avss-leak
def:avss, def:protocol -> lem:avss-caps
def:avss, con:avss-mask, def:protocol, lem:avss-caps -> prop:avss-cost
def:wdeg, lem:subst -> lem:line-total
lem:sz-total, lem:line-total, def:protocol -> rem:total-app
rem:total-app -> rem:total-prior
```

Checked mechanically on the compiled order (the `\input` order of `main.tex`, then the label order
inside each file):

- no label is defined twice;
- no edge names a label that does not exist;
- **no edge points forward**: every `A -> B` has `A` before `B` in the order of section 4;
- **no cycle** (depth-first search over the 143 edges finds none).

The leaves — labels with no `\uses` entry — are the seven shared definitions, the five lemmas that
state `\uses{nothing}` (`lem:roots`, `lem:rootsum`, `lem:subcode`, `lem:bad-count`,
`lem:avss-bad`), and the five imported items.
