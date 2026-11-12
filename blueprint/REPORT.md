# Phase 1 report: blueprint and Lean skeleton

Branch `blueprint`, branched from `restructure` at `cdc0ac8`.  Nothing is pushed to `main`.

* `proofs/` was edited only in Step 0 (the two renaming fixes, the [BCIKS20] translation paragraph,
  and `.gitignore`), and `proofs/main.tex` compiles cleanly after it.
* `blueprint/` is a leanblueprint project whose `src/content.tex` is `proofs/` verbatim, with
  `\lean`, `\uses` (plain labels) and `\leanok` added.
* `lean/` holds the Lean sources of the project `SymFRI`: every definition is written and every
  result of `proofs/` that has a mathematical statement is declared, with `sorry` proofs.
* `lake build` succeeds with `sorry` warnings only; `leanblueprint web` and
  `leanblueprint checkdecls` both exit 0.

---

## R0. Step 0

Commit **`cdc0ac8`** on `restructure` (`restructure: step 7`), build clean: 0 errors, 0 undefined
references, 0 multiply-defined labels, 1 overfull box.

The greps were run **before** the renamings, over `proofs/*.tex`:

```
$ grep -rn '\\iota' proofs/*.tex   ->  (no match, 0 occurrences)
$ grep -rn '\\gamma' proofs/*.tex ->  (no match, 0 occurrences)
```

What Step 0 changed:

1. `external.tex`: the translation paragraph replaced by the text of the request.
2. `variants.tex`: the constraint index `s` renamed to `\iota` (`w^{(\iota)}`, `D_{\iota}`,
   `d^{(\iota)}_i`, `\bigcap_{\iota}`, `T_{\iota}`, `a_{\iota}`, `for all \iota`).  The number of
   repetitions `s` is untouched, and `variants.tex` contains no other `s`.
3. `lem:div`: the `T`-exponent `e` renamed to `\gamma`, here and in the two places that use it
   (`lem:round-up`'s "`\cref{lem:div}` with `e = w_ij`", and nothing in `lem:unfold`, which does not
   mention the exponent).  The mask polynomial keeps the name `e`.
4. `.gitignore`: `*.fls` and `*.fdb_latexmk` added (the other patterns were already there).

---

## R1. Inventory

73 environments, 69 of them labelled, in the `\input` order of `proofs/main.tex`.  `\uses` is the
final annotation, as plain labels.

| # | label | file | type | statement (one line) | `\uses` | proof lines |
|---|---|---|---|---|---|---|
| 1 | `def:domains` | defs | definition | $\F$ is a finite field; $k\ge 2$, $m\ge 1$ and $N$ are integers with $k^m\mid N$ and |  | 0 |
| 2 | `def:poly` | defs | definition | $R$ denotes a commutative $\F$-algebra (in practice $R=\F$ or $R=\F[T]$). For |  | 0 |
| 3 | `def:kron` | defs | definition | For $0\le i\le m$ and $q\in R[x_{i+1},\dots,x_m]_{<k}$, |  | 0 |
| 4 | `def:fold` | defs | definition | For $u:L_{i-1}\to R$ and $y\in L_i$, the \emph{components} of $u$ are |  | 0 |
| 5 | `def:wdeg` | defs | definition | Let $w\in\N^m$. For $f=\sum_\alpha f_\alpha x^\alpha\in\F[x_1,\dots,x_m]$, |  | 0 |
| 6 | `def:codes` | defs | definition | of words $L\to\F^t$ whose $t$ coordinates lie in $\RS[\F,L,d]$; we identify |  | 0 |
| 7 | `def:agree` | defs | definition | For words $u,v$ on $L$ and $\mu:L\to[0,1]$, |  | 0 |
| 8 | `lem:roots` | L00-tools | lemma | Let $D\ge1$, let $P\in\F[Y]$ with $\deg P<D$, and let $A\subseteq\F$ with $|A|\ge D$. If |  | 0 |
| 9 | `lem:rootsum` | L00-tools | lemma | Let $k\ge1$, let $\omega\in\F$ have multiplicative order exactly $k$, and let |  | 0 |
| 10 | `lem:subst` | L00-tools | lemma | Let $R$ be a commutative ring, $w\in\N^m$, $D\in\N$ and $I\subseteq\{1,\dots,m\}$. For $l\in I$ | def:wdeg | 0 |
| 11 | `lem:kron` | L01-kronecker | lemma | For any commutative ring $R$, the map $q\mapsto U^{(i)}_q$ is an $R$-linear bijection | def:kron | 0 |
| 12 | `lem:inj` | L01-kronecker | lemma | Let $R=\F[T]$ and $0\le i\le m$. The map $q\mapsto U^{(i)}_q\big|_{L_i}$ on | def:domains, lem:kron, lem:roots | 0 |
| 13 | `lem:sz-total` | L02-sz-total | lemma | Let $m\ge1$, $D\in\N$, and let $f\in\F[x_1,\dots,x_m]$ be nonzero with | def:wdeg, lem:roots | 0 |
| 14 | `cor:box` | L02-sz-total | corollary | Let $0\ne f\in\F[x_1,\dots,x_m]$ with $\deg_{x_l}f<k$ for every $l$ (the box | lem:sz-total, def:wdeg, def:poly | 0 |
| 15 | `lem:fold-parts` | L03-fold-substitution | lemma | Let $1\le i\le m$, let $R$ be a commutative $\F$-algebra, and let | def:fold, def:domains, lem:rootsum | 0 |
| 16 | `lem:fold-sub` | L03-fold-substitution | lemma | Let $1\le i\le m$, $q\in R[x_i,\dots,x_m]_{<k}$ and $u:=U^{(i-1)}_q|_{L_{i-1}}$. Then for every | lem:fold-parts, def:kron, lem:kron | 0 |
| 17 | `lem:fold-invert` | L03-fold-substitution | lemma | Let $1\le i\le m$ and let $u:L_{i-1}\to R$ have components $u_0,\dots,u_{k-1}$ | def:fold, def:domains, lem:rootsum | 0 |
| 18 | `cor:terminal` | L03-fold-substitution | corollary | Let $R=\F[T]$, $f\in\F[x_1,\dots,x_m]_{<k}$, $w\in\N^m$, $r\in\F^m$ and | lem:fold-sub | 0 |
| 19 | `lem:stab` | L04-stability | lemma | Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, $r\in\F$ and $c:=rT^{w_i}$. Then | lem:fold-sub, lem:subst, def:codes | 0 |
| 20 | `lem:stab-cap` | L04-stability | lemma | Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, $c_l:=r_lT^{w_l}$ for $1\le l\le i$, and let | lem:fold-sub, lem:subst, def:codes, def:wdeg | 0 |
| 21 | `lem:div` | L05-divisibility | lemma | Let $1\le i\le m$, $\gamma\in\N$, $v\in\Gc_i^{w,D}$ and $A\subseteq L_i$ with $|A|\ge k^{m-i}$. | def:codes, lem:inj, lem:roots | 0 |
| 22 | `lem:unfold` | L06-unfolding | lemma | Let $1\le i\le m$, $w\in\N^m$, $D\in\N$. Let $v_0,\dots,v_{k-1}\in\Gc_i^{w,D}$ and | def:kron, def:codes, lem:div, lem:inj, lem:fold-parts | 0 |
| 23 | `lem:ext` | L07-interleaved | lemma | Let $\E\supseteq\F$ be a finite extension, $e_0,\dots,e_{[\E:\F]-1}$ an $\F$-basis of | def:codes | 0 |
| 24 | `lem:ext-agree` | L07-interleaved | lemma | Let $\varphi:\F^t\to\E$ be an injective $\F$-linear map, applied pointwise to words on a set $L | def:codes, def:agree | 0 |
| 25 | `—` | L07-interleaved | remark | The identity $\varphi\big(\sum_jz_ju_j\big)=\sum_jz_j\varphi(u_j)$ for $z_j\in\F$ is the only p |  | 0 |
| 26 | `lem:subcode` | L08-subcode | lemma | Let $\E\supseteq\F$, let $W$ be an $\F$-linear space of words $L\to\E$ and let $v_0,\dots,v_l$  |  | 0 |
| 27 | `lem:gran` | L09-granularity | lemma | Let $\mu:L_i\to\frac1{k^i}\Z$. Then $\agree_\mu(u,v)\in\frac1N\Z$ for all words | def:agree, def:domains | 0 |
| 28 | `def:fibre-avg` | L10-lifting | definition | Let $\mu$ be a weight on $L_{i-1}$. Its \emph{fibre average} is the weight $\nu$ on $L_i$ with | def:domains | 0 |
| 29 | `lem:lift` | L10-lifting | lemma | Let $\mu$ be a weight on $L_{i-1}$ with fibre average $\nu$ (\cref{def:fibre-avg}). If $u,h$, m | def:agree, def:fibre-avg, def:domains | 0 |
| 30 | `lem:bad-count` | L10b-counting | lemma | For $1\le i\le m$ let $S_i:\F^{i-1}\to2^{\F}$ with $|S_i(r_1,\dots,r_{i-1})|\le\Theta_i$ for |  | 0 |
| 31 | `ext:bciks72` | external | imported | Let $V=\RS[\F,L,d]$, $n=|L|$, $\rho=d/n$. Let $u_0,\dots,u_l:L\to\F$, and let |  | 0 |
| 32 | `ext:proof-facts` | external | remark | for each $z\in S$, of a codeword $P_z\in V$ with |  | 0 |
| 33 | `ext:bciks71` | external | imported | Let $V=\RS[\F,L,d]$, $n=|L|$, $\rho=d/n$, $u_0,\dots,u_l:L\to\F$, and $\mu:L\to[0,1]$ |  | 0 |
| 34 | `ext:facts71` | external | remark | The proof of \cref{ext:bciks71} is the same as that of \cref{ext:bciks72} (\S7.1 of |  | 0 |
| 35 | `hyp:ca` | H-hypothesis | hypothesis | For $\alpha_*\in(0,1]$ and a function $\Theta(n,M,l)$, $\mathrm H(\alpha_*,\Theta)$ is the | ext:bciks72, ext:proof-facts | 0 |
| 36 | `prop:H1` | H-hypothesis | proposition | Let $\kappa\ge3$ and $\alpha_0:=\sqrt\rho\,(1+\frac1{2\kappa})$. Then | ext:bciks72, ext:proof-facts | 0 |
| 37 | `prop:H2` | H-hypothesis | proposition | Put $\eta_{\mathrm U}:=\min\big(\frac{(1-\sqrt\rho)^2}2,\frac{\sqrt\rho}{20}\big)$. For every | ext:bciks71, ext:facts71 | 0 |
| 38 | `cor:share` | C1-share | consequence | Assume $\mathrm H(\alpha_*,\Theta)$, let $\E,L,d,V,u_0,\dots,u_l$ and $\mu,M$ be as in | hyp:ca, lem:subcode | 0 |
| 39 | `def:protocol` | protocol | definition | Parameters: $\F,k,m,N,L_0,\dots,L_m$ as in \cref{def:domains}; $w\in\N^m$; $D\in\N$; | def:domains, def:kron, def:fold | 0 |
| 40 | `def:weights` | protocol | definition | For a transcript, define $\mu^{(0)}\equiv1$ on $L_0$ and, for $1\le i\le m$, let $\nu^{(i)}$ be | def:fibre-avg, def:protocol, def:fold | 0 |
| 41 | `ext:claim85` | external-acceptance | imported | With the weights of \cref{def:weights}, the probability that one query of |  | 0 |
| 42 | `lem:start` | L11-start | lemma | For every $u_0:L_0\to\F$, $\agree\big(u_0,\Gc_0^{w,D}\big)=\agree\big(u_0,C_{w,D}\big)$. | def:codes, def:agree, def:kron | 0 |
| 43 | `lem:no-increase` | L12-no-increase | lemma | Let $1\le i\le m$ and let $\mu^{(i)},\nu^{(i)}$ be the weights of \cref{def:weights} for a | def:weights, def:agree | 0 |
| 44 | `lem:round-up` | L13-round | lemma | Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, let $u:L_{i-1}\to\F[T]$ have components | def:domains, def:fibre-avg, lem:div, lem:fold-invert, lem:lift, lem:unfold | 0 |
| 45 | `lem:round` | L13-round | lemma | Assume $\mathrm H(\alpha_*,\Theta)$ and $\alpha_*>\rho$. Let $1\le i\le m$, let $u:L_{i-1}\to\F | hyp:ca, cor:share, lem:round-up, lem:ext, lem:ext-agree, lem:gran | 0 |
| 46 | `lem:sound-fold` | T1-soundness | lemma | Assume $\mathrm H(\alpha_*,\Theta)$ with $\alpha_*>\rho$, let $\alpha\ge\alpha_*$, and let | hyp:ca, lem:start, lem:round, lem:no-increase | 0 |
| 47 | `thm:reduction` | T1-soundness | theorem | Assume $\mathrm H(\alpha_*,\Theta)$ with $\alpha_*>\rho$, let $\alpha\ge\alpha_*$, and suppose | lem:sound-fold, lem:bad-count, ext:claim85 | 0 |
| 48 | `cor:johnson` | T1-soundness | consequence | Let $\kappa\ge3$, $\alpha\ge\alpha_0:=\sqrt\rho\,(1+\frac1{2\kappa})$, and | prop:H1, thm:reduction | 0 |
| 49 | `cor:ud` | T1-soundness | consequence | Let $\alpha>\frac{1+\rho}2$ and suppose $\agree(u_0,C_{w,D})\le\alpha$. Then the test accepts | prop:H2, thm:reduction | 0 |
| 50 | `—` | T1-soundness | remark | Since $C_{w,D}\subseteq\RS[\F,L_0,k^m]$, acceptance also certifies $\deg_{x_l}<k$ for all $l$; |  | 0 |
| 51 | `rem:char` | T1-soundness | remark | [BCIKS20, \S5.2.3] (the characteristic of $\F$ exceeds $D_Y$, the bound on the $Y$-degree of th | ext:bciks72 | 0 |
| 52 | `prop:complete` | completeness | proposition | Let $f\in\F[x_1,\dots,x_m]_{<k}$ with $\deg_wf\le D$, and let the prover be honest. | def:protocol, lem:stab-cap, cor:terminal, cor:box | 0 |
| 53 | `rem:multi` | variants | remark | Replace $\F[T]$ by $\F[T_1,\dots,T_p]$, the challenge $r_iT^{w_i}$ by | lem:inj, lem:fold-sub, lem:stab, lem:div, lem:unfold, lem:round, thm:reduction | 0 |
| 54 | `rem:separate` | variants | remark | Running $\Pi_{w^{(\iota)},D_{\iota}}$ separately on the same $u_0$ costs the sum of the $p$ run | rem:multi | 0 |
| 55 | `def:avss` | L14-bits | definition | Let $\tau,t\in\N$ with $2^\tau\ge t+1$. Set $k:=2$ and $m:=2\tau$, and let $N,L_0,\dots,L_m$ be | def:domains, def:kron, def:codes | 0 |
| 56 | `lem:avss-bits` | L14-bits | lemma | Let $f\in\F[X,Y]$ with $\deg_Xf,\deg_Yf<2^\tau$, and let $f',w^X,w^Y$ be as in | def:avss, def:wdeg | 0 |
| 57 | `rem:avss-y` | L14-bits | remark | With $X$ the low variable, $\deg_Yf\le t$ if and only if $\deg\hat f<2^\tau(t+1)$. Indeed | def:avss, def:kron, lem:avss-bits | 0 |
| 58 | `con:avss-mask` | L15-bad-challenge | definition | Let $\tau,t$ and $f\in\F[X,Y]$ with $\deg_Xf,\deg_Yf<2^\tau$ be as in \cref{def:avss}. The | def:avss, def:protocol | 0 |
| 59 | `rem:avss-threshold` | L15-bad-challenge | remark | Let $2^\tau\ge t+2$ and let $f\in\F[X,Y]$ satisfy $\deg_Xf,\deg_Yf<2^\tau$ and | def:avss | 0 |
| 60 | `lem:avss-bad` | L15-bad-challenge | lemma | Let $f,e\in\F[X,Y]$ with $\deg_Xf>t$. Then $\deg_X(f+\theta e)\le t$ for at most one |  | 0 |
| 61 | `lem:avss-close` | L16-distance | lemma | Let $f\in\F[X,Y]$ with $\deg_Xf,\deg_Yf<2^\tau$, let $e\in\F[X,Y]$ with $\deg_Xe,\deg_Ye<2^\tau | def:avss, def:agree | 0 |
| 62 | `lem:avss-dist` | L16-distance | lemma | Let $f\in\F[X,Y]$ with $\deg_Xf,\deg_Yf<2^\tau$, let $e\in\F[X,Y]$ with $\deg_Xe,\deg_Ye<2^\tau | def:avss, con:avss-mask, lem:avss-bits, lem:avss-close, lem:inj, lem:roots, def:codes, def:agree | 0 |
| 63 | `prop:avss-sound` | P2-avss-soundness | proposition | Let $\tau,t,u_f,u_e,\delta_0$ be as in \cref{def:avss}, let $\delta_0\le(1-\rho)/4$, let | def:avss, con:avss-mask, lem:avss-bad, lem:avss-dist, cor:ud | 0 |
| 64 | `lem:avss-uniform` | L17-avss-secrecy | lemma | Let $f,e\in V_t$ with $e$ uniform and independent of $f$ and of $\theta\in\F^*$. Then | def:avss | 0 |
| 65 | `lem:avss-secret` | L17-avss-secrecy | lemma | Let $f\in V_t$ and $\theta\in\F^{*}$, and let $e$ be uniform on $V_t$, independent of $f$, of | def:avss, con:avss-mask, def:protocol, lem:avss-uniform | 0 |
| 66 | `rem:avss-leak` | L17-avss-secrecy | remark | If the query points of the masked test cannot be chosen among the positions of the commitment, | con:avss-mask | 0 |
| 67 | `lem:avss-caps` | P3-avss-cost | lemma | Let $k=2$, $w=w^X$, $D=t$ and $t\le2^\tau-1$, and let | def:avss, def:protocol | 0 |
| 68 | `prop:avss-cost` | P3-avss-cost | proposition | Let $w=w^X$, $D=t$, $k=2$, $m=2\tau$, and let $d_i=\min\big(D,(k-1)\sum_{l\le i}w_l\big)$ be | def:avss, con:avss-mask, def:protocol, lem:avss-caps | 0 |
| 69 | `lem:line-total` | total-degree | lemma | Let $m\ge1$, $f\in\F[x_1,\dots,x_m]$ and $\mathbf a,\mathbf b\in\F^m$. Then | def:wdeg, lem:subst | 0 |
| 70 | `rem:total-app` | total-degree | remark | Let $f$ with $\deg_{x_l}f<k$ for all $l$ be committed, and suppose that $\Pi_{\mathbf 1,D}$ | lem:sz-total, lem:line-total, def:protocol | 0 |
| 71 | `rem:total-prior` | total-degree | remark | For some interactive proofs the total degree is the parameter of the soundness statement, and a | rem:total-app | 0 |


**Check against `proofs/dependencies.tex`.** `dependencies.tex` is generated from the same `\uses`
lines (143 edges over 52 targets), and was checked mechanically in Phase 1a: no duplicate label, no
unknown label, no forward edge, no cycle.  Comparing it with the table above:

* no mismatch: every edge of `dependencies.tex` is a `\uses` entry of the table, and conversely;
* 17 labelled environments have no entry in `dependencies.tex` because they have no `\uses` line or
  state `\uses{nothing}`: the seven shared definitions, `lem:roots`, `lem:rootsum`, `lem:subcode`,
  `lem:bad-count`, `lem:avss-bad`, and the five imported items;
* the four environments without a label — the remark in `L07-interleaved.tex`, the remark
  "Individual degrees" in `T1-soundness.tex`, and the two introductory paragraphs — cannot appear
  in either list.

---

## R2. Reuse map

Searched: `qoosmo/kronecker-fri/lean` (namespace `KBFold` and `KroneckerFRI`),
`qoosmo/kbfold/lean` (branch `main` and `bciks-proof`), Mathlib at `/opt/mathlib`, and
`Verified-zkEVM/ArkLib`.

| item | kronecker-fri / kbfold | Mathlib | ArkLib |
|---|---|---|---|
| `def:codes` (`RS[F,L,d]` as a submodule) | **exact match** in shape: `KBFold.RS (d : ℕ) : Submodule F (L → F)` (`Domain.lean:496`), for `L : Subgroup Fˣ` rather than `Finset F`; the degree bound is `degreeLT F d` | none for RS codes | close but different: `rsPolynomial`, `rsEncoder`, `rsErasureDecoder` in `ProofSystem/ToyProblem/Spec/ErasureDecoder.lean`; no `ReedSolomon` code as a submodule |
| `def:agree` (`Δ`, `agree_μ`) | **exact match**: `KBFold.agreeSet`, `hdist`, `relDist`, `DistLE` (`Domain.lean:383–394`), all with `ℚ`-valued distance | none | `ArkLib/Data/CodingTheory/Basic/RelativeDistance.lean` (close: Hamming/relative distance of words, not of a code) |
| `def:kron` (Kronecker map) and `lem:kron` | **exact match**: `KroneckerFRI.kronEnc`, `kronCoeffs`, `kronEnc_eq_subst`, `kronEncLin_bijective` (`KroneckerFRI/Kronecker.lean:149–218`) — the bijection `Table F n ↔ F[X]_{<2^n}` | none (Mathlib has no Kronecker encoding) | none |
| `def:fold` | **close match, restricted to `k = 2`**: `KBFold.wfold (r) (w)` and `wfoldLin` (`WordFold.lean:28,44`), with `lineU0/lineU1` giving the linear structure; no `k`-ary fold | none | none |
| `def:domains` (the tower `L_0, …, L_m`, `k`-to-one fibres) | **close match**: `KBFold.IsSmoothDomain`, `powDom`, `iterDom`, `powHom`, `card_powHom_fibre` (`Domain.lean:38–215`) — subgroups of `Fˣ` with `k`-th power maps | none | none |
| `lem:sz-total`, `cor:box` | `KBFold.LowDegree` has low-degree characterizations but no Schwartz–Zippel | **exact match of the tool**: `MvPolynomial.schwartz_zippel_sup_sum` (`Mathlib/Algebra/MvPolynomial/SchwartzZippel.lean:71`); `cor:box` is a two-line specialization | none |
| `def:wdeg`, `def:poly` (`degreeOf`, total degree) | — | **exact match**: `MvPolynomial.degreeOf_le_iff` (`Degrees.lean:236`), `totalDegree_eq` (`:436`) | — |
| `lem:roots` (root bound) | `KBFold` uses the same fact inside `dec_unique` | **close match**: `Polynomial.card_roots`, `Polynomial.finset_card_roots` (`Mathlib/Algebra/Polynomial/Roots.lean`) | `ArkLib/ToMathlib/Polynomial/DegreeLT.lean` |
| `lem:rootsum` | none | **none** as stated (the sum over `μ_k`); `Polynomial.sum_rootsOfUnity`-style lemmas do not exist | none |
| `lem:subst` (substitution and graded degree) | none | **close match**: `MvPolynomial.degreeOf_eval₂`, `MvPolynomial.degreeOf_bind₁` — the statement has to be assembled | none |
| `lem:subcode` (Vandermonde) | none | **close match**: `Matrix.det_vandermonde`, `Matrix.det_vandermonde_ne_zero_iff` | none |
| `lem:ext`, `lem:ext-agree` | none | **close match**: `Basis.equivFun`, `LinearEquiv.piCongrRight` | none |
| `lem:line-total` | none | **close match**: `MvPolynomial.degreeOf_rename`, `Polynomial.natDegree_eval₂` | none |
| `lem:sz-total` (Schwartz–Zippel) | — | as above | none |
| `ext:bciks72`, `ext:bciks71` (BCIKS, Johnson radius) | **no match on the radius**: `KBFold.bciks_curves` and `bciks_unique` (`BCIKS.lean:39,50`) are the **unique-decoding** regime only (`δ ≤ (1-ρ)/2`); the `bciks-proof` branch adds `BCIKSProof/{Arithmetic,BerlekampWelch}` towards proving `bciks_unique`, still not the Johnson regime | none | none |
| Berlekamp–Welch / GS | **close match**: `KBFold.BCIKSProof.BerlekampWelch` (branch `bciks-proof`) | none | **close match**: `ArkLib/Data/CodingTheory/BerlekampWelch`, `GuruswamiSudan` |

**Why nothing is imported.** `kronecker-fri/lean` pins `lean-toolchain = leanprover/lean4:v4.23.0`
and Mathlib at `37df177aaa770670452312393d4e84aaad56e7b6`; this machine has Lean `v4.33.1` and a
prebuilt Mathlib of that version, and no other Mathlib can be built here (the request's "pinned to
the same version as `qoosmo/kronecker-fri/lean`" cannot be met in this environment — see R4).  The
skeleton therefore redefines the items of the table in the shape the request asks for
(`L : Finset F`, `Submodule F (L → F)`), and the names of KBFold are recorded above so that Phase 2
can either port them or move the whole project to Lean `v4.23.0` and import them.

---

## R3. Axioms

All axioms are in `lean/SymFRI/External.lean`; there are five of them.

1. **`bciks72`** — [BCIKS20, **Theorem 7.2**], p. 33, ePrint 2020/654 (3 July 2021).  The statement
   as printed: witnesses existential.  Not used by the skeleton's theorems.
2. **`bciks72_reading`** — **strengthened reading of [BCIKS20] §7.1** (the axiom `prop:H1` uses):
   the witnesses `P_z` are arbitrary and fixed in advance, `S ⊆ F` is any set of the stated size,
   and the curve identity `Σ_j z^j v_j = P_z` is required for those `P_z` on more than `l` values
   of `z`.  This is `ext:bciks72` with facts (F1) and (F2) of `ext:proof-facts` built in.
3. **`bciks71`** — [BCIKS20, **Theorem 7.1**], version I, unique-decoding range; statement as
   printed.  Not used.
4. **`bciks71_reading`** — **strengthened reading of [BCIKS20] §7.1**, the axiom `prop:H2` uses,
   with (F1)–(F2) built in exactly as in (2).
5. **`claim85`** — [BCIKS20, **Claim 8.5**]: the probability that one query accepts is the `μ^(m)`
   weight of the last domain.

`hyp:ca` is a `def … : Prop` (`SymFRI.CA`), not an axiom, and `prop:H1`/`prop:H2`
(`SymFRI.H_johnson`, `SymFRI.H_unique`) are **proved** from (2) and (4) with no `sorry`.

Full statements, as they appear in `External.lean`:

```lean
axiom bciks72 (kappa : ℕ) (hkappa : 3 ≤ kappa) (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F] (L : Finset F) (d l M : ℕ),
      d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
      ∀ (u : Fin (l + 1) → L → F) (S : Finset F) (alpha : ℝ),
        alpha0 rho kappa ≤ alpha → ThetaJ rho kappa L.card M l < (S.card : ℝ) →
        (∀ z ∈ S, ∃ P ∈ RS L d,
          alpha ≤ ((∑ x : L, if (∑ j : Fin (l + 1), z ^ (j : ℕ) • u j x) = P x then (1 : ℚ) else 0) /
            (L.card : ℚ) : ℝ)) →
        ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧
          alpha ≤ ((∑ x : L, if ∀ j, u j x = v j x then (1 : ℚ) else 0) / (L.card : ℚ) : ℝ)

axiom bciks72_reading (kappa : ℕ) (hkappa : 3 ≤ kappa) (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F] (L : Finset F) (d l M : ℕ),
      d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
      ∀ (u : Fin (l + 1) → L → F) (P : F → L → F) (S : Finset F) (alpha : ℝ),
        alpha0 rho kappa ≤ alpha → ThetaJ rho kappa L.card M l < (S.card : ℝ) →
        (∀ z ∈ S, P z ∈ RS L d ∧ alpha ≤ …) →
        ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧ alpha ≤ … ∧
          (l : ℕ) < (S.filter fun z => ∀ x, (∑ j : Fin (l + 1), z ^ (j : ℕ) • v j x) = P z x).card
```

(`bciks71` and `bciks71_reading` have the same shape with `ThetaU rho` in place of
`ThetaJ rho kappa` and the hypothesis `(1 + rho) / 2 < alpha_star`; `claim85` is a one-line weight
identity.)

---

## R4. Ambiguities and the choices made

These are the places where turning the `.tex` into Lean forced a choice.  Each is a Phase 2 item.

1. **`RS[F,L,d]` and the off-by-one of `d`.**  `defs.tex` defines `RS[F,L,d] = {P|_L : deg P < d}`,
   so `d` is the *dimension* and `d-1` the degree bound; BCIKS's `k` is `d-1` (Step 0's translation
   paragraph).  The Lean `RS L d` is the span of the first `d` monomial evaluations, which agrees
   with the `.tex` for `d ≤ |L|` and is a submodule for every `d` (the literal set is empty for
   `d = 0`).  Alternative: define it by `Polynomial.degree < d` and get the degenerate case wrong.
2. **`d ≤ |L|`.**  Every code-theoretic statement in the `.tex` tacitly assumes `d ≤ |L|` (otherwise
   the code is the whole space and the distance bounds are vacuous).  It is written explicitly in
   `CA` and in the axioms; the `.tex` never states it.
3. **The domain tower.**  `def:domains` builds `L_i = {x^k : x ∈ L_{i-1}}` from a coset `L_0` and
   *derives* `|L_i| = N/k^i` and the fibre properties.  The Lean `Tower` takes those derived
   properties as fields (plus `pow_mem : x ∈ L_i → x^k ∈ L_{i+1}`, needed by `lem:fold-invert`),
   because they are exactly what the proofs use — this is the Phase 1a hypothesis audit, made
   structural.  Alternative: build the coset from `Fˣ` as KBFold does, which needs `N ∣ |F|-1` and
   a `Subgroup` API.
4. **`L` non-empty.**  The `.tex` never says `L ≠ ∅`; Lean's `Finset` allows it and the ratios
   `agree` are `0/0 = 0` by Mathlib's convention.  No theorem of the skeleton divides by `|L|`
   without the `Tower`'s `N_pos`.
5. **The characteristic.**  `prop:H1` inherits a separability hypothesis from [BCIKS20, §5.2.3]
   (`rem:char`).  It is **not** in the Lean statements: it lives inside the axioms, since the axioms
   state the theorem outright.  Alternative: add `p > D_Y` as a hypothesis on `bciks72_reading`.
6. **`agree(u,C)` as a maximum.**  `def:agree` takes the maximum over a code; in Lean the codes are
   submodules (infinite as types) and the proofs only ever need one direction at a time, so the
   skeleton uses `AgreeLe` (`∀ v ∈ C, agree u v ≤ a`) and `AgreeGe` (`∃ v ∈ C, a ≤ agree u v`).
   Alternative: `Finset.sup` over an explicit list of codewords.
7. **Weighted agreement over an extension.**  `ext:bciks72` has coefficients in `F[T]`, `E ⊇ F` and
   `μ` with denominator `M`.  The axioms are stated over a `Finset F` with `ℚ`-valued `μ` and the
   denominator only as a parameter of `Θ`; the extension field of the `.tex` (needed so that
   interleaved words become words over a field) does not appear.
8. **`lem:round`, `lem:sound-fold`, `thm:reduction`.**  The `.tex`'s `S_i` is the set of challenges
   *for the given `u` and `μ^{(i-1)}`*; in Lean `round` is stated with an existential bad set and
   the counting is `bad_count`'s job; `reduction` states the count of `acceptSet` directly, and the
   `α^s` term of the `.tex` (the query repetitions, `ext:claim85`) is **not** included, because the
   counting form of the request covers the challenge vector only.  This is the weakest point of the
   skeleton: `round` and `sound_fold` are placeholders around the real statements.
9. **`def:protocol`.**  A prover is a `structure` giving its messages as a function of the challenge
   prefix; `ChecksAll` says every fold check holds at every point, which is stronger than the
   `.tex`'s "the `s` queries pass".  The honest-prover statements (`prop:complete`) are stated for
   the Kronecker image, not for the `structure Prover`.
10. **The AVSS layer** (`def:avss`, `lem:avss-bits`, `lem:avss-dist`, `prop:avss-sound`,
    `lem:avss-uniform`, `prop:avss-cost`).  The bivariate setting is `MvPolynomial (Fin 2) F` with
    `0 = X`, `1 = Y`; the multilinear representative `f'` is an explicit parameter, because `def:avss`
    defines it by a substitution and only the two degree identities are used.  `lem:avss-uniform`
    is stated as the bijectivity of `e ↦ f + θe` on `V_t`; `avss_dist` and `avss_sound` are
    truncated to their conclusions.  `lem:avss-secret` (simulator), `rem:avss-y`, `rem:avss-leak`
    and `rem:avss-threshold` have **no** Lean statement: they need a PCS/commitment model that the
    `.tex` does not fix.
11. **Remarks.**  `rem:char`, `rem:multi`, `rem:separate`, `rem:total-prior` are remarks;
    `rem:multi` and `rem:separate` get Lean statements (`SymFRI.multi`, `SymFRI.separate`), the
    other two do not.  `rem:proof-facts` and `rem:facts71` are represented by the strengthened
    axioms, not by declarations.
12. **The Lean project root.**  leanblueprint requires `lakefile.toml` at the git root, so the Lake
    package is declared in `symfri-degree/lakefile.toml` with `srcDir = "lean"`; the sources remain
    in `lean/`.  `lean/` therefore has no lakefile of its own.
13. **Naming.**  Definitions are `lowerCamelCase` (`SymFRI.agree`, `SymFRI.wdeg`), following Mathlib,
    rather than the UpperCamelCase of the request; structures and types are `UpperCamelCase`
    (`SymFRI.Tower`, `SymFRI.Prover`), and theorems are `lowerCamelCase` (`SymFRI.fold_subst`).
14. **Two statements of `lem:round-up`'s hypothesis are weakened**: the `agree` conclusion is dropped
    (see 6) and the hypothesis that the `v_j` are the components of `T ^ (w j) u_j` is carried by
    `hcomp`, which is currently vacuous.

---

## R5. Granularity check

Nothing in `proofs/` has a Lean statement or an expected Lean proof that clearly exceeds 50 lines,
**except** the four items below, which are already split in `proofs/` and will still be heavy in
Lean.  Proposed blueprint-only sub-lemmas (not applied):

* **`lem:round`** (L23).  Split off the reduction to `cor:share`:
  `\begin{lemma}[The bad set is enumerated by $\Theta$]\label{lem:round-bad} … \end{lemma}`
  with statement "`|S_i| ≤ Θ(|L_i|, k^i, k-1)` where `S_i = {r : agree_{ν^(i)}(Fold_{rT^{w_i}} u, Gc_i) > β_i}`",
  and the descent already isolated as `lem:round-up`.
* **`thm:reduction`** (T1).  Split the union bound from the query step:
  "`#{r : r_i ∈ S_i for some i} ≤ |F|^(m-1) Σ Θ_i`" (already `lem:bad-count`) and
  "one query accepts with probability `≤ α`" (already `ext:claim85`); the remaining statement is
  the arithmetic `(#bad)/|F|^m + α^s`.
* **`prop:complete`** (P1).  Split the terminal-polynomial claim (cor:terminal's content) from the
  format and query checks; the degree bound `deg g ≤ deg_w f` with probability `1 - m(k-1)/|F|` is
  the Schwartz–Zippel step (`cor:box`).
* **`prop:avss-cost`** (P3).  Split `lem:avss-caps` (already a lemma) from the summation; the
  arithmetic `Σ_{i≤2τ} (d_{i-1}+1) ≤ 2^τ - 1 + τ(t+1)` is a separate 3-line lemma.

For `lem:sound-fold` and `lem:bad-count` the counting form is respected: `bad_count` has the sets
`S i` depending only on the prefix — its hypothesis `hdep` states exactly that
(`∀ j, j < i → r j = r' j → (bad i r ↔ bad i r')`) — and `sound_fold` takes the challenge vector
`r : Fin m → F` and the good-challenge hypothesis `¬ ChecksAll …`.

---

## R6. Suggested proving order for Phase 2

Leaves first; `S`/`M`/`L` is the estimated difficulty (proof length and API gap).

| # | node | Lean name | size |
|---|---|---|---|
| 1 | `def:domains` | `Tower` | S (structure only) |
| 2 | `def:poly`, `def:wdeg`, `def:codes`, `def:agree` | `InBox`, `wdeg`, `RS`, `agree` | S |
| 3 | `lem:roots` | `roots_eq_zero` | S (Mathlib root bound) |
| 4 | `lem:rootsum` | `rootsum` | S |
| 5 | `lem:subst` | `subst_preserves` | M |
| 6 | `cor:box`, `lem:sz-total` | `box_bound`, `sz_total` | S (Mathlib SZ) |
| 7 | `lem:kron` | `kron_bijOn` | M (base-`k` digits) |
| 8 | `lem:inj` | `eval_injective` | S from 3, 7 |
| 9 | `lem:fold-parts` | `components_eq` | M |
| 10 | `lem:fold-sub` | `fold_subst` | M |
| 11 | `lem:fold-invert` | `fold_invert` | M (root-of-unity sum) |
| 12 | `cor:terminal` | `terminal` | S from 10 |
| 13 | `lem:stab`, `lem:stab-cap` | `stab`, `stab_cap` | M |
| 14 | `lem:div` | `divisible` | M |
| 15 | `lem:unfold` | `unfold` | L |
| 16 | `lem:ext`, `lem:ext-agree` | `ext_linear`, `ext_agree` | S |
| 17 | `lem:subcode` | `subcode` | M (Vandermonde) |
| 18 | `lem:gran` | `granularity` | S |
| 19 | `def:fibre-avg`, `lem:lift` | `fibreAvg`, `lift` | S |
| 20 | `lem:bad-count` | `bad_count` | M (prefix counting) |
| 21 | `lem:start`, `lem:no-increase` | `start`, `no_increase` | M |
| 22 | `lem:round-up` | `round_up` | L |
| 23 | `lem:round` | `round` | L (needs `ext:bciks72` at the Johnson radius) |
| 24 | `lem:sound-fold` | `sound_fold` | L |
| 25 | `thm:reduction` | `reduction` | M from 20, 24 |
| 26 | `cor:johnson`, `cor:ud` | `johnson`, `unique_decoding` | S from 25 |
| 27 | `prop:complete` | `complete` | M |
| 28 | `lem:line-total`, `rem:total-app` | `line_total`, `total_app` | S |
| 29 | `prop:H1`, `prop:H2` | `H_johnson`, `H_unique` | done (from the axioms) |
| 30 | `cor:share` | `share` | M from 17, 29 |
| 31 | AVSS chain | `avss_bits` … `avss_cost` | L (needs the PCS layer for secrecy) |

The critical path is 1–3, 5, 9–11, 14, 22–25: everything else is short once those are done.

---

## R7. Commands

```bash
# the Lean skeleton
cd symfri-degree
lake build                      # succeeds, with `sorry` warnings only

# the blueprint
pip install leanblueprint
leanblueprint web               # writes blueprint/web/ (open blueprint/web/index.html)
leanblueprint checkdecls        # checks every \lean{...} against the project's declarations
```

On a machine other than this VM, replace the `[[require]] name = "mathlib" path = "/opt/mathlib"`
block of `lakefile.toml` by a git requirement at your Mathlib revision
(`rev = "<rev>"`), then `lake update && lake build`.  The toolchain is `leanprover/lean4:v4.33.1`
(`lean-toolchain`); to import `qoosmo/kronecker-fri/lean` instead, move the project to
`leanprover/lean4:v4.23.0` and Mathlib `37df177a` as that repository pins them (R2).

To view the blueprint locally, open `blueprint/web/index.html` in a browser; for the PDF,
`leanblueprint pdf` (needs a LaTeX installation with `plastex`'s PDF plugin).

---

# R8. Phase 1c: making the statements faithful

Branch `blueprint`.  `proofs/` was **not** edited.  Every changed proof body is `sorry`; the two
exceptions are `H_johnson` (still a proof from its axiom) and the structure fields of `δ`/`ν`, which
are `sorry`.

Gates: `SYMFRI_LOCAL_MATHLIB=1 lake build` succeeds with `sorry` warnings only;
`leanblueprint web` and `leanblueprint checkdecls` both exit 0.

## R8.1 What was changed, and whether it is faithful

| item | `.tex` | Lean (now) | verdict |
|---|---|---|---|
| A1 weight | `μ : L → [0,1]` with denominator `M`, `1 ≤ M` (`ext:bciks72`) | `structure Weight (L)`: `mu`, `nonneg`, `le_one`, `M`, `M_pos`, `denom : ∀ x, ∃ z : ℤ, mu x * M = z` | faithful |
| A1 agreement | `agree_μ(u,v)`, one notion | `agreeOf (w : Weight L) (u v : L → α)` — one definition, all codomains; `agree` is the case `μ ≡ 1` (`Weight.one`) | faithful |
| A2 characteristic | [BCIKS20, §5.2.3]: no inseparable factors; sufficient if `char > D_Y`, `D_Y < (2κ+1)/(2√ρ)` (`rem:char`) | `Separable F kappa rho := ∃ p, CharP F p ∧ (2κ+1)/(2√ρ) ≤ p`, a hypothesis of all four BCIKS axioms | faithful (sufficient form) |
| A3 `S'` clause | (F1): `Σ_j z^j v_j = P_z` for `z ∈ S' ⊆ S`, `|S'| ≥ (M n + 1) l` | `∃ S' ⊆ S, (w.M * L.card + 1) * l ≤ S'.card ∧ ∀ z ∈ S', ∀ x, Σ_j z^j v_j x = P_z x` | faithful |
| A3 `l ≥ 1` | carried by every use | `(hl : 1 ≤ l)` on all four axioms and inside `CA` | faithful |
| B1 maximum | `agree_μ(u,C) = max_{v∈C}` | `agreeCode w u C := sSup ((fun v => (agreeOf w u v : ℝ)) '' C)`, with `agreeCode_attained` and the two `iff`s `agreeLe_iff`, `agreeGe_iff` | faithful (value in `ℝ`) |
| B7 tower | `def:domains` builds `L_i` from a coset | `Tower.ofCoset (hk) (hkm) (hNF) (h0) (hcoset) : ∃ T, T.N = N ∧ T.L 0 = L₀` (proof `sorry`) | faithful (statement) |
| B2 `lem:round-up` | `v_j(y) = T^{w_ij}u_j(y)` on `A`, `ν(A) > ρ` ⟹ `∃ h ∈ Gc_{i-1}, agree_μ(u,h) ≥ ν(A)` | carries `hcomp : ∀ j y ∈ A, v j y = X^(w(i+1)j) * componentsP … `, but the conclusion is only `∃ h ∈ Gc, True` | **deviates: conclusion dropped** |
| B3 `lem:round` | `S := {r : β_i < agree_ν(Fold_{rT^{w_i}}u, Gc_i)}`, `|S| ≤ Θ(…)` | `∃ bad : Finset F, bad.card ≤ 1 ∧ ∀ r ∉ bad, True` | **deviates: existential bad set** |
| B4 `lem:sound-fold` | `r_i ∉ S_i ∀ i ⟹ agree_{μ^(m)}(u_m, Gc_m) ≤ α` | `(hgood : True)` | **deviates: hypothesis vacuous** |
| B5 protocol | fold checks at the `s` query positions | `Tower.path`, `ChecksAt`, `Accepts`, `acceptSet : Finset ((Fin m → F) × (Fin s → T.L 0))` | faithful |
| B5 `thm:reduction` | `Pr[accept] ≤ (1/|F|) Σ Θ + α^s` | `(acceptSet T w D 0 p).card ≤ Σ Θ / |F|` — no `α^s`, and `s = 0` | **deviates: `α^s` missing** |
| B6 `def:avss` | `f'` defined from `f` | `f'` still a parameter, tied by two degree identities (`hX`, `hY`) | **deviates: hypothesis instead of definition** |
| B6 `lem:avss-dist`, `prop:avss-sound` | full statements | truncated (`True`-valued / `≤ 1`) | **deviates: truncated** |
| B6 secrecy + remarks | — | no Lean statement; `\notready` with a one-line reason in the blueprint | as instructed |

## R8.2 Source map (A5)

| axiom | Lean hypothesis / conclusion | source |
|---|---|---|
| `bciks72`, `bciks72_reading` | `3 ≤ κ` | [BCIKS20, Thm 7.2] hypotheses, p. 33 |
| | `0 < ρ ≤ 1`, `d ≤ |L|`, `ρ = d/|L|` | Thm 7.2 (rate and distance of the code) |
| | `w : Weight L` (`μ`, `M`) | Thm 7.2, "weighted" form; `rem:proof-facts` (F2) |
| | `Separable F κ ρ` | §5.2.3 (quoted in the docstring of `External.lean`); `rem:char` |
| | `1 ≤ l` | §7.1 (`l` is the number of words minus one) |
| | `α₀(ρ,κ) ≤ α` | Thm 7.2 (`α ≥ α₀`) |
| | `Θ_J(ρ,κ)(n,M,l) < |S|` | Thm 7.2, condition `(★)` |
| | premise: `∃ P ∈ V` with agreement `≥ α` for each `z ∈ S` | Thm 7.2's definition of `S` |
| | conclusion: `v_j ∈ V`, `α ≤ jointAgree w u v` | Thm 7.2's conclusion |
| | (`reading` only) `P_z` arbitrary and fixed; `S' ⊆ S`, `(M n+1) l ≤ |S'|`, `Σ_j z^j v_j = P_z` on `S'` | `ext:proof-facts` (F1), p. 33 and Prop. 5.5 eq. (5.10) |
| `bciks71`, `bciks71_reading` | `(1+ρ)/2 < α_*` | Thm 7.1, unique-decoding range |
| | `Θ_U(ρ)(n,M,l) < |S|` | Thm 7.1, second condition of `(★★)` |
| | `l·n < |S|` | Thm 7.1, first condition of `(★★)` with `ε = n/|F|` |
| | conclusion as above, `S' ⊆ S` | `ext:facts71`, p. 34 |
| `claim85` | `∀ y ∈ L_m, μ^(m)(y) ≤ α ⟹ Pr[one query accepts] ≤ α` | [BCIKS20, Claim 8.5] (the equality `Pr = (1/|L_m|)Σ μ^(m)`), used through `μ^(m) ≤ α` |

Every row has a source; nothing in the axioms is asserted without one.

## R8.3 Constants (A4), against `external.tex`

`external.tex`, `(★)`: `|S| > max( (1+1/(2κ))⁷κ⁷/(3ρ^{3/2}) · n² · l , (2κ+1)/√ρ · (Mn+1) · l )`.

```lean
noncomputable def ThetaJ (rho : ℝ) (kappa : ℕ) (n M l : ℕ) : ℝ :=
  (l : ℝ) * max
    ((1 + 1 / (2 * (kappa : ℝ))) ^ 7 * (kappa : ℝ) ^ 7 / (3 * rho ^ (3 / 2 : ℝ)) * (n : ℝ) ^ 2)
    ((2 * (kappa : ℝ) + 1) / Real.sqrt rho * ((M : ℝ) * n + 1))
```
Term by term: `(1+1/(2κ))⁷` ↔ `(1 + 1/(2κ))^7`; `κ⁷` ↔ `kappa^7`; `3ρ^{3/2}` ↔ `3 * rho ^ (3/2)`;
`n²·l` ↔ `l * n^2` (in the product); `(2κ+1)/√ρ` ↔ `(2κ+1)/Real.sqrt rho`; `(Mn+1)·l` ↔
`l * ((M:ℝ)*n + 1)`.  **Faithful.**

`(★★)`: `|S| > l ε |E|` and `|S| ≥ l (Mn+1)(1/η + 3/√ρ)`, `η = min(α-√ρ, √ρ/20)`; in the
unique-decoding range the first is `|S| > l n`.

```lean
noncomputable def etaU (rho : ℝ) : ℝ := min ((1 - Real.sqrt rho) ^ 2 / 2) (Real.sqrt rho / 20)
noncomputable def ThetaU (rho : ℝ) (n M l : ℕ) : ℝ :=
  (l : ℝ) * ((M : ℝ) * n + 1) * (1 / etaU rho + 3 / Real.sqrt rho)
```
`η` at `α = α_* > (1+ρ)/2` is `≥ min((1-√ρ)²/2, √ρ/20) = η_U` (the arithmetic of `prop:H2`), so
`Θ_U` with `η_U` is the weaker (larger) threshold — conservative, hence faithful as a hypothesis.
The first condition is a separate hypothesis `l·n < |S|` in the `bciks71` axioms.  **Faithful.**

`alpha0`:
```lean
noncomputable def alpha0 (rho : ℝ) (kappa : ℕ) : ℝ :=
  Real.sqrt rho * (1 + 1 / (2 * (kappa : ℝ)))
```
↔ `α₀(ρ,κ) = √ρ(1+1/(2κ))`.  **Faithful.**

## R8.4 `#print axioms` (A6)

`lake env lean lean/SymFRI/AxiomCheck.lean`:

```
'SymFRI.H_johnson' depends on axioms: [propext, Classical.choice, Quot.sound, SymFRI.bciks72_reading]
'SymFRI.H_unique' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
'SymFRI.reduction' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
'SymFRI.johnson' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
'SymFRI.unique_decoding' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```

Only the intended axiom, `sorryAx`, and Lean's three standard axioms appear.  `H_unique` now
shows `sorryAx` rather than `bciks71_reading`, because with the `|S| > l·n` hypothesis added to
`bciks71_reading` its textbook proof needs the inequality `(Mn+1)(1/η_U+3/√ρ) > n` of `prop:H2`'s
proof — which is a `sorry` in the `.tex` as well.  Nothing unintended is involved.

## R8.5 Remaining deviations, and why

* **B2, B3, B4, B5 (`α^s`), B6** are **not** done.  The request asks to stop and report an item
  that cannot be translated faithfully; these are reported here rather than half-translated:
  * B2/B3/B4 need `β_i`, `S_i` and the prefix-dependent family `u_{i-1}, μ^(i-1)` with Lean's
    `Fin`-index arithmetic for the prefix `(r_1,…,r_{i-1})`; `Tower.path` and `muChain` (which are
    the hard part) are in place, and the remaining work is the indexing, not the mathematics.
  * B5's `α^s` needs the `s`-fold product `(T.L 0)^s` and the per-query axiom `claim85` raised to
    it; the acceptance model itself (`Accepts`, `acceptSet` over
    `(Fin m → F) × (Fin s → T.L 0)`) is in place.
  * B6 needs the multilinear representative `f'` defined by the substitution
    `x_l = Z^{2^{l-1}}` (a `MvPolynomial.rename`/`aeval` construction) and, for `lem:avss-secret`,
    a commitment model the `.tex` does not fix.
* `CA` carries `κ`, which `hyp:ca` does not: the separability hypothesis it needs is stated in terms
  of `D_Y < (2κ+1)/(2√ρ)`.
* `agreeCode` takes its values in `ℝ` (`ℚ` has no `sSup`).

## R8.6 Mathlib revision, and the build

The local prebuilt Mathlib at `/opt/mathlib` has no `.git`.  It is the release tag

```
v4.33.1 = 0df444a360eaa60ab8c11dca51a86af692955474
```

identified by two independent facts: `/opt/mathlib/lean-toolchain` is `leanprover/lean4:v4.33.1`,
and all **eight** dependency revisions of `/opt/mathlib/lake-manifest.json` equal those of that
tag's manifest.  The tag's hash was read with `git ls-remote` on
`leanprover-community/mathlib4`.

`lakefile.lean` pins that revision:

```lean
require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "0df444a360eaa60ab8c11dca51a86af692955474"
```

Building Mathlib from source is not possible on the machine that prepared this phase, so the same
file uses the prebuilt copy of the *same* tag when the environment variable
`SYMFRI_LOCAL_MATHLIB` is set:

```bash
SYMFRI_LOCAL_MATHLIB=1 lake build        # this machine
lake build                               # anywhere else: fetches the pinned revision
```
