# Restructuring proposals for `proofs/` (Phase 1a)

Read: every file in `proofs/main.tex`'s `\input` order — 30 `.tex` files, 1047 lines, of which 28 are
`\input` (7 + 4 = 11 definitions, 19 lemmas, 1 corollary, 5 propositions, 1 hypothesis, 1 theorem,
3 consequences, 3 imported theorems, 12 remarks). Nothing else was read as a source of claims;
`main.aux` was used only to fix the compiled numbers (L1–L19, D1–D11, P1–P5, P-H1, P-H2, T1, C1–C3,
E1–E3, remarks 1–12).

No `.tex` file is edited by this report. Every proposal below is stated so that it can be accepted or
rejected on its own; where two proposals interact I say so in the proposal itself (only B2/C3,
B6/C1, B9/C5, B7/C4 do, and only in the way described there).

Sizes are counted in non-blank `.tex` lines: *statement* = from `\begin{env}` to the line before
`\begin{proof}`, *proof* = strictly inside the environment. The targets in the request are a
statement of at most 5 lines and a proof of about 20 lines.

**Nothing in `proofs/` has a proof longer than 20 lines** — the longest are 12 (`lem:avss-dist`,
`lem:avss-secret`, `prop:avss-cost`). All granularity problems are in *statements* (multi-part
lemmas) and, in three places, in proofs that are short only because each line carries four steps.

---

## Summary of proposals

Δ lines: negative = shorter.

| ID | type | affected labels | Δ lines | risk |
|----|------|-----------------|---------|------|
| B1 | split | `lem:fold-sub` → `lem:fold-parts`, `lem:fold-sub`, `lem:fold-invert` | +3 | none |
| B2 | split | `lem:stab` → `lem:stab` (substitution), `lem:stab-codes`, `lem:stab-cap` | +2 | none |
| B3 | split | `lem:ext` → `lem:ext`, `lem:ext-agree` | −4 | none |
| B4 | split | `lem:round` → `lem:round-up`, `lem:round` | +1 | none |
| B5 | split | `thm:reduction` → `lem:sound-fold`, `thm:reduction` | +1 | none |
| B6 | split | `lem:avss-dist` → `lem:avss-close`, `lem:avss-dist` | −2 | none |
| B7 | split | `prop:avss-cost` → `lem:avss-caps`, `prop:avss-cost` | −2 | none |
| B8 | split | `lem:avss-secret` → `lem:avss-uniform`, `lem:avss-secret` | −1 | none |
| B9 | split | `lem:sz-total` → `lem:sz-total`, `cor:box` | +1 | none |
| C1 | dedupe | `lem:inj`, `lem:div`, `lem:avss-dist`, `lem:sz-total`, `rem:avss-threshold` + new `lem:roots` | −5 | none |
| C2 | dedupe | `lem:fold-sub`(a),(c) + new `lem:rootsum` | −1 | none |
| C3 | dedupe | `lem:stab`(a) and `lem:line-total` → one `lem:subst` | −3 | changes a statement |
| C4 | dedupe | `def:domains` + 6 sites | −4 | none |
| C5 | dedupe | `prop:complete`(c), `lem:sz-total` → `cor:box` | −2 | none |
| C6 | dedupe | `def:agree` + `lem:avss-dist` + `lem:ext` | −1 | none |
| C7 | cite | `prop:complete`(c) | 0 | none |
| C8 | reorder | `lem:sz-total` | −1 | none |
| C9 | reorder | `rem:avss-threshold` | −4 | none |
| C10 | reorder | `lem:avss-bad` | −2 | none |
| C11 | erratum | `cor:johnson` proof, line 39 | 0 | none |
| C12 | dedupe | `rem:avss-y` | −3 | none |
| D1 | hypothesis | `lem:kron` | 0 | changes a statement |
| D2 | hypothesis | `lem:inj` | 0 | changes a statement |
| D3 | hypothesis | `lem:fold-sub`(a) | 0 | changes a statement |
| D4 | hypothesis | `lem:unfold` | 0 | changes a statement |
| D5 | hypothesis | `lem:ext` | 0 | changes a statement |
| D6 | hypothesis | `lem:subcode` | 0 | changes a statement |
| D7 | hypothesis | `lem:gran` | 0 | changes a statement |
| D8 | hypothesis | `lem:lift` | 0 | changes a statement |
| D9 | hypothesis | `lem:avss-bad` | −0 | changes a statement |
| D10 | hypothesis | `prop:complete` | 0 | changes a statement |
| D11 | hypothesis | `def:domains` | 0 | changes a statement |
| D12 | — | recorded, no proposal: hypotheses used in a weaker form | 0 | none |
| E1 | order | whole file | 0 | none |
| F1 | notation | `cor:share` | −3 | none |
| F2 | notation | `def:domains`, `cor:johnson`, `def:avss` | −2 | none |
| F3 | notation | `lem:stab`(c), `def:protocol`, `defs.tex` | 0 | changes a statement |
| F4 | notation | `lem:ext`, `lem:round`, `rem:multi`, `defs.tex` | 0 | changes a statement |
| F5 | notation | `external.tex` | 0 | none |
| F6 | notation | `rem:multi`, `rem:separate` | 0 | none |
| F7 | notation | `lem:subcode`, `cor:johnson` proof | 0 | none |
| F8 | notation | `lem:div` | 0 | changes a statement |
| F9 | notation | `lem:round` | 0 | changes a statement |
| F10 | notation | `def:avss`, `lem:avss-dist` | +1 | none |
| F11 | hygiene | 6 `\uses`/`\usedby` lines, `dependencies.tex`, `protocol.tex:3` | −6 | none |
| F12 | structure | `L15-bad-challenge.tex` lines 36–42 | 0 | none |

---

## Part A: inventory

`\uses` is transcribed from the file, including entries that are stale (marked †); those are
corrected in F11.

| label | file | type | statement (one line) | `\uses` | proof |
|---|---|---|---|---|---|
| `def:domains` | defs | definition | $\F$ finite, $k\ge2$, $m\ge1$, $k^m\mid N\mid\lvert\F\rvert-1$; $L_0$ a coset of order $N$; $L_i=\{x^k:x\in L_{i-1}\}$; fibres | — | — |
| `def:poly` | defs | definition | $R$ a commutative $\F$-algebra; the box $R[x_i,\dots,x_m]_{<k}$ | — | — |
| `def:kron` | defs | definition | the Kronecker map $U^{(i)}_q(Y)=q(Y,Y^k,\dots,Y^{k^{m-i-1}})$ | — | — |
| `def:fold` | defs | definition | components $u_j=\frac1k\sum_{x\in\fib(y)}x^{-j}u(x)$ and $\Fold_c(u)$ | — | — |
| `def:wdeg` | defs | definition | weighted degree $\deg_w$ and graded degree $\gdeg_w$ | — | — |
| `def:codes` | defs | definition | $\RS[\F,L,d]$, its $t$-interleaving, the graded codes $\Gc_i^{w,D}$, $C_{w,D}$ | — | — |
| `def:agree` | defs | definition | weighted agreement $\agree_\mu(u,v)$, $\agree_\mu(u,C)$ | — | — |
| `lem:kron` (L1) | L01 | lemma | $q\mapsto U^{(i)}_q$ is an $R$-linear bijection onto $R[Y]_{<k^{m-i}}$, $x^\alpha\mapsto Y^{n(\alpha)}$ | `def:kron` | 4 |
| `lem:inj` (L2) | L01 | lemma | over $R=\F[T]$, $q\mapsto U^{(i)}_q\lvert_{L_i}$ is injective | `def:domains, lem:kron` | 4 |
| `lem:fold-sub` (L3) | L03 | lemma | (a) components of a polynomial; (b) $\Fold_c$ equals substitution; (c) inversion | `def:fold, def:kron, lem:kron` | 3 |
| `cor:terminal` (L3.1) | L03 | corollary | the honest $i$-fold fold is the constant $f(r_1T^{w_1},\dots)$ | `lem:fold-sub` | 1 |
| `lem:stab` (L4) | L04 | lemma | (a) substitution keeps the box and $\gdeg_w\le D$; (b) $\Fold_c(\Gc_{i-1}^{w,D})\subseteq\Gc_i^{w,D}$; (c) the $i$-fold fold of $C_{w,D}$ has $T$-degree $\le d_i$ | `def:wdeg, def:codes, lem:fold-sub` | 8 |
| `lem:div` (L5) | L05 | lemma | $T^e\mid v(y)$ on $\lvert A\rvert\ge k^{m-i}$ points $\Rightarrow v=T^ep$, $p\in\Gc_i^{w,D-e}$ | `def:codes, lem:inj, lem:kron`† | 5 |
| `lem:unfold` (L6) | L06 | lemma | $v_j=T^{w_ij}p_j$ on $L_i$ $\Rightarrow$ $h=\sum_jx^jp_j(x^k)\in\Gc_{i-1}^{w,D}$ with components $p_j$ | `def:kron, def:codes, lem:div, lem:inj, lem:fold-sub` | 6 |
| `lem:ext` (L7) | L07 | lemma | interleaved $=$ extension-field code; $\varphi$ preserves agreement sets; $\varphi$ is $\F$-linear | `def:codes, def:agree` | 5 |
| (remark 1) | L07 | remark | item (3) is the only place where challenges in $\F$ rather than in $\E$ matter | — | — |
| `lem:subcode` (L8) | L08 | lemma | $\sum_jz^jv_j\in W$ for $>l$ values of $z$ $\Rightarrow$ $v_j\in W$ | `nothing` | 4 |
| `lem:gran` (L9) | L09 | lemma | $(1/k^i)\Z$-weights give agreement in $(1/N)\Z$; the round-up $\beta^+$ | `def:agree, def:domains` | 6 |
| `lem:lift` (L10) | L10 | lemma | agreement on every fibre over $A$ $\Rightarrow$ $\agree_{\mu^{(i-1)}}\ge\nu^{(i)}(A)$ | `def:agree, def:weights, def:domains` | 4 |
| `lem:start` (L11) | L11 | lemma | $\agree(u_0,\Gc_0^{w,D})=\agree(u_0,C_{w,D})$ | `def:codes, def:agree, lem:kron`† | 5 |
| `lem:no-increase` (L12) | L12 | lemma | $\agree_{\mu^{(i)}}(u_i,C)\le\agree_{\nu^{(i)}}(\Fold_{c_i}(u_{i-1}),C)$ | `def:weights, def:agree` | 6 |
| `ext:bciks72` (E1) | external | imported | [BCIKS20, Thm 7.2]: weighted correlated agreement over curves | — | — |
| `rem:proof-facts` (2) | external | remark | (F1) the witnesses $P_z$ are arbitrary; (F2) only $\lvert S\rvert$ matters | — | — |
| `ext:claim85` (E2) | external | imported | [BCIKS20, Claim 8.5]: one query accepts with probability $\frac1{\lvert L_m\rvert}\sum_y\mu^{(m)}(y)$ | — | — |
| `ext:bciks71` (E3) | external | imported | [BCIKS20, Thm 7.1], version I | — | — |
| `rem:facts71` (3) | external | remark | (F1)–(F2) hold for E3 as well | — | — |
| `hyp:ca` (H) | H | hypothesis | $\mathrm H(\alpha_*,\Theta)$: curve CA with prescribed witnesses above a threshold $\lvert S\rvert>\Theta$ | `ext:bciks72, rem:proof-facts` | — |
| `prop:H1` (P-H1) | H | proposition | $\mathrm H(\alpha_0,\Theta_J)$ holds at the Johnson radius | `ext:bciks72, rem:proof-facts` | 7 |
| `prop:H2` (P-H2) | H | proposition | $\mathrm H(\alpha_*,\Theta_U)$ holds for every $\alpha_*>\frac{1+\rho}2$ | `ext:bciks71, rem:facts71` | 8 |
| `cor:share` (C1) | C1 | consequence | the same conclusion with $v_j\in W$, $W\subseteq V$ an $\F$-linear subcode | `hyp:ca, lem:subcode` | 3 |
| `def:protocol` (D8) | protocol | definition | the degree test $\Pi_{w,D}$: messages, formats, $s$ query repetitions | — | — |
| `def:weights` (D9) | protocol | definition | the query weights $\nu^{(i)}$ (fibre average) and $\mu^{(i)}$ (checked) | — | — |
| `lem:round` (L13) | L13 | lemma | $\lvert\{r:\agree_{\nu^{(i)}}(\Fold_{rT^{w_i}}(u),\Gc_i^{w,D})>\beta_i\}\rvert\le\Theta(\lvert L_i\rvert,k^i,k-1)$ | `hyp:ca`†, `cor:share, lem:div, lem:ext, lem:fold-sub, lem:gran, lem:lift, lem:unfold` | 8 |
| `thm:reduction` (T1) | T1 | theorem | acceptance $\le\frac1{\lvert\F\rvert}\sum_i\Theta(\lvert L_i\rvert,k^i,k-1)+\alpha^s$ | `lem:start, lem:round, lem:no-increase, ext:claim85` | 6 |
| `cor:johnson` (C2) | T1 | consequence | $\varepsilon_C+\alpha^s$ at the Johnson radius, with $\varepsilon_C$ displayed | `prop:H1, thm:reduction` | 7 |
| `cor:ud` (C3) | T1 | consequence | $\varepsilon_U+\alpha^s$ for $\alpha>\frac{1+\rho}2$ | `prop:H2, thm:reduction` | 3 |
| (remark 4) | T1 | remark | $C_{w,D}\subseteq\RS[\F,L_0,k^m]$; $w=e_l$, $D=b$ certifies $\deg_{x_l}f\le b$ | — | — |
| `rem:char` (5) | T1 | remark | the separability convention inherited from E1 | — | — |
| `prop:complete` (P1) | completeness | proposition | honesty: formats and checks hold, $g=f(r_1T^{w_1},\dots)$, $\deg g=\deg_wf$ w.h.p. | `def:protocol, lem:stab, cor:terminal` | 8 |
| `rem:multi` (6) | variants | remark | $p$ degree constraints in one run ($\F[T_1,\dots,T_p]$, vector graded degree) | — | — |
| `rem:separate` (7) | variants | remark | $p$ separate runs on one commitment: same statement below unique decoding | — | — |
| `def:avss` (D10) | L14 | definition | the bivariate instantiation $k=2$, $m=2\tau$, $f'$, $\hat f$, $w^X$, $w^Y$, $V_t$, $\delta_0$ | `def:domains, def:kron, def:codes` | — |
| `lem:avss-bits` (L14) | L14 | lemma | $\deg_Xf=\deg_{w^X}f'$, $\deg_Yf=\deg_{w^Y}f'$ | `def:avss, def:wdeg` | 10 |
| `rem:avss-y` (8) | L14 | remark | $\deg_Yf\le t\iff\deg\hat f<2^\tau(t+1)$ | — | — |
| `con:avss-mask` (D11) | L15 | definition | the masked degree test: commit $\hat e$ with salted leaves, run $\Pi_{w^X,t}$ on $u_f+\theta u_e$ | `def:avss, def:protocol` | — |
| `rem:avss-threshold` (9) | L15 | remark | [PolyFRIM]'s binding does not bind a malicious dealer to one secret; two cases | `def:avss` | — |
| (orphan text) | L15:36–40 | text | "This does not contradict [PolyFRIM, Thm 4.1] …" | — | — |
| `lem:avss-bad` (L15) | L15 | lemma | at most one $\theta\in\F$ has $\deg_X(f+\theta e)\le t$ | `def:avss, con:avss-mask`† | 5 |
| `lem:avss-dist` (L16) | L16 | lemma | $\deg_Xh>t\Rightarrow\agree(u_h,C_{w^X,t})\le\rho+2\delta_0$ | `def:avss, con:avss-mask, lem:avss-bits, lem:inj, def:codes, def:agree` | 12 |
| `prop:avss-sound` (P2) | P2 | proposition | the masked test accepts with probability $\le\frac1{\lvert\F\rvert}+\varepsilon_U+\alpha_*^s$ | `def:avss, con:avss-mask, lem:avss-bad, lem:avss-dist, cor:ud` | 8 |
| `lem:avss-secret` (L17) | L17 | lemma | (a) $h$ is uniform; (b) the messages are functions of $h,\theta,r$,positions; (c) a simulator | `def:avss, con:avss-mask, def:protocol` | 12 |
| `rem:avss-leak` (10) | L17 | remark | if queries are not commitment positions, $2s$ evaluations leak | `con:avss-mask` | — |
| `prop:avss-cost` (P3) | P3 | proposition | one repetition reads $\le2(2^\tau-1+\tau(t+1))$ elements, $O(t\log t)$ | `def:avss, con:avss-mask, def:protocol` | 12 |
| `lem:sz-total` (L18) | total-degree | lemma | Schwartz–Zippel in the total degree, plus the box bound $m(k-1)/\lvert\F\rvert$ | `def:wdeg` | 5 |
| `lem:line-total` (L19) | total-degree | lemma | $\deg f(\mathbf a+T\mathbf b)\le\deg_{\mathbf 1}f$ | `def:wdeg` | 3 |
| `rem:total-app` (11) | total-degree | remark | two evaluation claims reduced to one, at error $D/\lvert\F\rvert$ | `lem:sz-total, lem:line-total, def:protocol` | — |
| `rem:total-prior` (12) | total-degree | remark | Fold-DCS and GKR state soundness in the total degree | `rem:total-app` | — |
| (dependencies) | dependencies | section | prose dependency graph | — | — |

Three structural facts that the table makes visible, and that Part A is entitled to report:

1. **`def:poly` is referenced once in the whole file** (`total-degree.tex:11`), although every
   lemma of L01–L06 and L13 uses the box $R[x_i,\dots,x_m]_{<k}$ that it defines.
2. **`def:weights` is defined after three of its users.** `lem:lift` (main.tex:24),
   `lem:no-increase` (main.tex:26) and `ext:claim85` (main.tex:27) all quote `def:weights`, which is
   `\input` at main.tex:30. A forward reference in the compiled file, not only in the graph.
3. **`d_i` is defined twice** — in `lem:stab`(c) (`L04-stability.tex:12`) and in `def:protocol`
   (`protocol.tex:6`) — and `lem:stab` precedes `def:protocol`, so the second definition is the one
   the reader is expected to use, six pages after the first.

---

## Part B: granularity

Every split below is a decomposition of what the file already proves: the concatenation of the
sub-proofs is the present proof, statement for statement. No sub-lemma asserts anything the present
proof does not establish. Where a label survives the split, the surviving label is named first, so
that the six `\cref`s from outside are untouched unless stated.

### B1 — `lem:fold-sub` (statement 16 lines, three items) → three lemmas

The present lemma is three results: a computation (§a), its use with `lem:kron` (§b), and the
inverse identity (§c). Only (b) is used by `cor:terminal` and `lem:stab`; only (a) by `lem:unfold`;
only (c) by `lem:round`, step 7.

**B1a — paper.**

```latex
\begin{lemma}[Components of a polynomial]\label{lem:fold-parts}
Let $0\le i\le m$, let $R$ be a commutative ring in which $k$ is invertible, and let
$P(Y)=\sum_{j<k}Y^jP_j(Y^k)$ with $P_j\in R[Y]$. Then the components of $u:=P|_{L_{i-1}}$
(\cref{def:fold}) are $u_j=P_j|_{L_i}$ for $0\le j<k$.
\end{lemma}
```

*Proof.* Fix $y\in L_i$ and $x_0\in\fib(y)$, so $\fib(y)=x_0\Omega_k$. Then
$\sum_{x\in\fib(y)}x^{-j}P(x)=\sum_{j'<k}P_{j'}(y)\,x_0^{\,j'-j}\sum_{\zeta\in\Omega_k}\zeta^{\,j'-j}
=kP_j(y)$ by `lem:rootsum` (C2), and $k$ is invertible. ∎
Uses: `def:fold`, `def:domains`, and `lem:rootsum` if C2 is accepted, otherwise the one-line root-of-unity
sum inline as today.

**B1b — paper, keeps the label `lem:fold-sub`.**

```latex
\begin{lemma}[Fold equals substitution]\label{lem:fold-sub}
Let $1\le i\le m$, $q\in R[x_i,\dots,x_m]_{<k}$ and $u:=U^{(i-1)}_q|_{L_{i-1}}$. Then for every
$c\in R$,
\[
\Fold_c(u)=U^{(i)}_{q(c,\,x_{i+1},\dots,x_m)}\big|_{L_i}.
\]
\end{lemma}
```

*Proof.* Write $q=\sum_{j<k}x_i^jq_j$; by `def:kron`,
$U^{(i-1)}_q(Y)=\sum_jY^jU^{(i)}_{q_j}(Y^k)$, so (B1a) gives $u_j=U^{(i)}_{q_j}|_{L_i}$, and
$\Fold_c(u)=\sum_jc^jU^{(i)}_{q_j}|_{L_i}=U^{(i)}_{\sum_jc^jq_j}|_{L_i}$ by linearity of $U^{(i)}$.
∎
Uses: `lem:fold-parts`, `def:kron`, `lem:kron`.

**B1c — paper, new label.**

```latex
\begin{lemma}[Inversion]\label{lem:fold-invert}
Let $1\le i\le m$ and let $u:L_{i-1}\to R$ be a word with components $u_0,\dots,u_{k-1}$
(\cref{def:fold}). Then $u(x)=\sum_{j<k}x^j\,u_j(x^k)$ for every $x\in L_{i-1}$.
\end{lemma}
```

*Proof.* Put $y:=x^k$ and $\zeta:=x/x'\in\Omega_k$ for $x'\in\fib(y)$; then
$\sum_{j<k}x^ju_j(y)=\frac1k\sum_{x'\in\fib(y)}u(x')\sum_{j<k}\zeta^j=u(x)$, the inner sum being $k$
for $x'=x$ and $0$ otherwise (`lem:rootsum`). ∎
Uses: `def:fold`, `def:domains`.

Rewiring: `lem:unfold` cites `lem:fold-parts` instead of `lem:fold-sub`(a); `lem:round` step 7 cites
`lem:fold-invert` instead of `lem:fold-sub`(c); `lem:stab`, `cor:terminal` keep `lem:fold-sub`.
Internal edges: `lem:fold-parts -> def:fold`, `def:domains`; `lem:fold-sub -> lem:fold-parts`,
`def:kron`, `lem:kron`; `lem:fold-invert -> def:fold`, `def:domains`.
Marking: all three are **paper** — (c) is cited from `lem:round`, (b) from two proofs, (a) from
`lem:unfold`, so none of them can be blueprint-only.

Δ +3 lines (16 + 3 = 19 becomes 4+3, 4+4, 3+2 plus three environment pairs). Risk: none.

### B2 — `lem:stab` (statement 12 lines, three items) → three lemmas

(a) is a pure degree computation, (b) is its use with `lem:fold-sub`(b), (c) is the iteration of (b)
with (a). Three different users: (a) is the substitution law that `lem:line-total` also proves (C3);
(b) is cited by nothing but the paper; (c) is cited by `prop:complete`(a).

**B2a — paper, keeps the label `lem:stab`.**

```latex
\begin{lemma}[Substitution keeps the box and the graded degree]\label{lem:stab}
Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, $q\in\F[T][x_i,\dots,x_m]_{<k}$ with $\gdeg_wq\le D$,
$r\in\F$ and $c:=rT^{w_i}$. Then $q(c,x_{i+1},\dots,x_m)\in\F[T][x_{i+1},\dots,x_m]_{<k}$ and its
graded degree is $\le D$.
\end{lemma}
```

*Proof.* A monomial $T^ax_i^{\,j}x^\beta$ maps to $r^jT^{a+w_ij}x^\beta$. The exponents of
$x_{i+1},\dots,x_m$ are unchanged, hence $<k$; the graded degree $a+w_ij+\sum_{l>i}w_l\beta_l$ is
unchanged, hence $\le D$. ∎
Uses: `def:wdeg`.

**B2b — paper, new label.**

```latex
\begin{lemma}[Stability]\label{lem:stab-codes}
Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, $r\in\F$ and $c:=rT^{w_i}$. Then
$\Fold_c\big(\Gc_{i-1}^{w,D}\big)\subseteq\Gc_i^{w,D}$.
\end{lemma}
```

*Proof.* Let $v=U^{(i-1)}_q|_{L_{i-1}}\in\Gc_{i-1}^{w,D}$ with $\gdeg_wq\le D$. By
`lem:fold-sub`(b), $\Fold_c(v)=U^{(i)}_{q(c,\dots)}|_{L_i}$, and $q(c,\dots)$ is in the box with
graded degree $\le D$ by `lem:stab`. ∎
Uses: `lem:fold-sub`, `lem:stab`, `def:codes`.

**B2c — paper, new label.**

```latex
\begin{lemma}[The honest $T$-degree]\label{lem:stab-cap}
Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, $c_l:=r_lT^{w_l}$ for $1\le l\le i$, and let
$f\in\F[x_1,\dots,x_m]_{<k}$ have $\gdeg_wf\le D$. Then
$\Fold_{c_i}\circ\cdots\circ\Fold_{c_1}\big(U_f|_{L_0}\big)$ is a word of $\Gc_i^{w,D}$ whose values
have $T$-degree at most $d_i=\min\big(D,(k-1)\sum_{l\le i}w_l\big)$.
\end{lemma}
```

*Proof.* By `lem:fold-sub`(b) applied $i$ times the word is $U^{(i)}_q$ with
$q=f(c_1,\dots,c_i,x_{i+1},\dots,x_m)$, which lies in $\Gc_i^{w,D}$ by `lem:stab`. A monomial
$x^\alpha$ of $f$ contributes the $T$-exponent $\sum_{l\le i}w_l\alpha_l\le(k-1)\sum_{l\le i}w_l$,
and this exponent is at most the graded degree, hence $\le D$. ∎
Uses: `lem:fold-sub`, `lem:stab`, `def:codes`, `def:protocol` (for $d_i$, once F4 is accepted).

Rewiring: `prop:complete`(a) cites `lem:stab-cap` instead of `lem:stab`(c). `lem:stab`'s statement
loses two items but keeps its label and its `\uses`.
Internal edges: `lem:stab -> def:wdeg`; `lem:stab-codes -> lem:fold-sub, lem:stab, def:codes`;
`lem:stab-cap -> lem:fold-sub, lem:stab, def:codes`.

**Coupling with C3.** If both B2 and C3 are accepted, `lem:stab` *is* `lem:subst` specialised to
$I=\{i\}$, $g_i=rT^{w_i}$: accept one label and use it twice. If only one is accepted, both texts
stand as written above; nothing else changes.

Δ +2 lines. Risk: none.

### B3 — `lem:ext` (statement 11 lines, three items) → two lemmas

Items (1) and (3) are one fact about the map $\varphi$; item (2) is a different fact, with a
one-line proof, used only to move agreement between $L$-words and $\E$-words.

**B3a — paper, keeps the label `lem:ext`.**

```latex
\begin{lemma}[Interleaved code $=$ extension-field code]\label{lem:ext}
Let $\E\supseteq\F$ be an extension of degree $t$, let $e_0,\dots,e_{t-1}$ be an $\F$-basis of $\E$
and $\varphi:\F^t\to\E$, $a\mapsto\sum_sa_se_s$, applied pointwise to words on $L\subseteq\F$. Then
$\varphi$ is an $\F$-linear bijection $\RS[\F,L,d]^t\to\RS[\E,L,d]$, and
$\varphi\big(\sum_{j\le l}z_ju_j\big)=\sum_{j\le l}z_j\varphi(u_j)$ for $z_0,\dots,z_l\in\F$.
\end{lemma}
```

*Proof.* Every $P\in\E[X]_{<d}$ is uniquely $\sum_se_sP_s$ with $P_s\in\F[X]_{<d}$, and for
$x\in L\subseteq\F$, $P(x)=\varphi\big((P_s(x))_s\big)$: this is (1). Item (3) is the $\F$-linearity
of $\varphi$. ∎
Uses: `def:codes`.

**B3b — paper, new label.**

```latex
\begin{lemma}[$\varphi$ preserves agreement]\label{lem:ext-agree}
Let $\varphi:\F^t\to\E$ be an injective $\F$-linear map, applied pointwise to words on a set $L$.
Then $\{x:u(x)=v(x)\}=\{x:\varphi(u(x))=\varphi(v(x))\}$ for all words $u,v$; hence $\varphi$
preserves $\Delta$ and $\agree_\mu$.
\end{lemma}
```

*Proof.* $\varphi$ is injective, so $u(x)=v(x)\iff\varphi(u(x))=\varphi(v(x))$; the agreement set is
unchanged, and $\Delta,\agree_\mu$ are functions of it. ∎
Uses: `def:agree`.

Rewiring: `lem:round` step 3 uses `lem:ext` (unchanged label). The unlabelled remark (1) in
`L07-interleaved.tex:24` is about item (3) and stays with `lem:ext`.
Internal edge: `lem:ext-agree -> def:agree`. Note that `lem:ext-agree` carries no hypothesis on the
basis and no degree $t$ — see D5.

Δ −4 lines. Risk: none.

### B4 — `lem:round` (statement 10 lines, proof 8 numbered steps ≈ 40 steps of content) → two lemmas

Steps 1–4 reduce the bad set $S$ to an application of H through `cor:share`, and steps 5–8 turn the
$H$-conclusion into a better approximant of $u$, which contradicts the definition of $\beta_i$. The
second half is a statement about a *single good challenge*, not about the set $S$.

**B4a — blueprint-only, new label.**

```latex
\begin{lemma}[Descent]\label{lem:round-up}
Let $1\le i\le m$, $w\in\N^m$, $D\in\N$, let $u:L_{i-1}\to\F[T]_{\le d_{i-1}}$ have components
$u_0,\dots,u_{k-1}$ (\cref{def:fold}), let $\mu$ be a weight on $L_{i-1}$ with fibre average
$\nu$ (\cref{def:weights}) and let $A\subseteq L_i$. If $T^{w_ij}u_j\in\Gc_i^{w,D}$ for every
$j<k$ and $\nu(A)>\rho$, then there is $h\in\Gc_{i-1}^{w,D}$ with
$\agree_\mu(u,h)\ge\nu(A)$.
\end{lemma}
```

*Proof.* (1) Apply `lem:div` with $e=w_ij$, $v=T^{w_ij}u_j$ and this $A$: it gives
$T^{w_ij}u_j=T^{w_ij}p_j$ with $p_j\in\Gc_i^{w,D-w_ij}$, and cancelling in $\F[T]$ gives $u_j=p_j$ on
$A$. (2) By `lem:unfold`, $h:=\sum_{j<k}x^jp_j(x^k)$ lies in $\Gc_{i-1}^{w,D}$ with components $p_j$.
(3) By `lem:fold-invert`, $u(x)=\sum_jx^ju_j(x^k)=h(x)$ for every $x\in\fib(y)$, $y\in A$. (4) By
`lem:lift`, $\agree_\mu(u,h)\ge\nu(A)$. ∎
Uses: `lem:div`, `lem:unfold`, `lem:fold-invert`, `lem:lift`, `def:weights`, and the identity
$\rho\lvert L_i\rvert=k^{m-i}$ (C4) to know $\lvert A\rvert\ge k^{m-i}$ from $\nu(A)>\rho$.
Blueprint-only: its only user is `lem:round`; in the paper it is the second half of that proof.

**B4b — paper, keeps the label `lem:round` (statement unchanged).**

*Proof.* Assume $\lvert S\rvert>\Theta(\lvert L_i\rvert,k^i,k-1)$. Steps 1–4 of the present proof
give $v_0,\dots,v_{k-1}\in\Gc_i^{w,D}$ and $A\subseteq L_i$ with $\nu^{(i)}(A)\ge\beta_i^+$, and
$T^{w_ij}u_j=v_j$ on $A$; since $\beta_i^+\ge\alpha_*>\rho$, `lem:round-up` gives
$h\in\Gc_{i-1}^{w,D}$ with $\agree_{\mu^{(i-1)}}(u,h)\ge\beta_i^+>\beta_i$, contradicting the
definition of $\beta_i$ as a maximum over $\Gc_{i-1}^{w,D}$. ∎
Uses: as today, plus `lem:round-up`.

Internal edge: `lem:round -> lem:round-up`. Steps 1–4 stay verbatim inside `lem:round`'s proof, with
step 5–8's conclusion quoted from `lem:round-up`.

Δ +1 line. Risk: none — `lem:round`'s statement, label and users are untouched.

### B5 — `thm:reduction` (statement 8 lines, proof 4 steps) → one lemma and the theorem

Steps 1–3 are pure folding analysis (the agreement at the last level is $\le\alpha$ away from a union
bound); step 4 is the query/acceptance step, which is the only place `ext:claim85` enters.

**B5a — blueprint-only, new label.**

```latex
\begin{lemma}[The folds do not increase the agreement]\label{lem:sound-fold}
Assume $\mathrm H(\alpha_*,\Theta)$ with $\alpha_*>\rho$, and let $\alpha\ge\alpha_*$. Then for
every prover, outside an event of probability at most
$\frac1{|\F|}\sum_{i=1}^m\Theta(\lvert L_i\rvert,k^i,k-1)$,
\[
\agree_{\mu^{(m)}}\big(u_m,\Gc_m^{w,D}\big)\le\alpha .
\]
\end{lemma}
```

*Proof.* (1) $\agree(u_0,\Gc_0^{w,D})=\agree(u_0,C_{w,D})\le\alpha$ by `lem:start`. (2) For
$1\le i\le m$ let $B_i$ be the event $r_i\in S_i$ of `lem:round`: $\Pr[B_i]\le\Theta(\lvert
L_i\rvert,k^i,k-1)/\lvert\F\rvert$, so $\Pr[\bigcup_iB_i]$ is at most the stated sum. (3) Outside
$B_i$, `lem:no-increase` and the definition of $S_i$ give
$\agree_{\mu^{(i)}}(u_i,\Gc_i^{w,D})\le\max(\agree_{\mu^{(i-1)}}(u_{i-1},\Gc_{i-1}^{w,D}),\alpha_*)$,
so induction from (1), using $\alpha\ge\alpha_*$, gives the claim. ∎
Uses: `lem:start`, `lem:round`, `lem:no-increase`.

**B5b — paper, keeps the label `thm:reduction` (statement unchanged).**

*Proof.* By `lem:sound-fold`, outside an event $E$ of the stated probability
$\agree_{\mu^{(m)}}(u_m,\Gc_m^{w,D})\le\alpha$. Since $u_m=g\in\Gc_m^{w,D}$, `ext:claim85` bounds the
probability that one query accepts by $\agree_{\mu^{(m)}}(g,g)\le\alpha$ and the $s$ repetitions by
$\alpha^s$; adding $\Pr[E]$ gives the bound. ∎
Uses: `lem:sound-fold`, `ext:claim85`. (`ext:claim85` and $\alpha^s$ now appear in exactly one place.)

Δ +1 line. Risk: none.

### B6 — `lem:avss-dist` (statement 9, proof 12 lines in 4 steps) → two lemmas

Step 1 is the commitment arithmetic ($u_f+\theta u_e$ is close to $\hat f+\theta\hat e$) and steps 2–4
are the coding-theory argument. Step 1 is the only place where $\delta_0$ is used, and it also fixes
the meaning of $\hat h$, which the present proof uses at line 21 without ever defining it.

**B6a — blueprint-only, new label. It defines $\hat h$.**

```latex
\begin{lemma}[The commitments add up]\label{lem:avss-close}
Let $f,e\in\F[X,Y]$ with $\deg_Xf,\deg_Xe,\deg_Yf,\deg_Ye<2^\tau$, let $\theta\in\F$, put
$h:=f+\theta e$ and $\hat h:=U_{h'}$ with $h'$ as in \cref{def:avss}, and let $u_f,u_e:L_0\to\F$. If
$\Delta(u_f,\hat f|_{L_0})\le\delta_0$ and $\Delta(u_e,\hat e|_{L_0})\le\delta_0$, then, with
$u_h:=u_f+\theta u_e$, one has $\agree(u_h,\hat h|_{L_0})\ge1-2\delta_0$.
\end{lemma}
```

*Proof.* Outside the union of the two disagreement sets, of size at most $2\delta_0N$, one has
$u_h(x)=u_f(x)+\theta u_e(x)=\hat f(x)+\theta\hat e(x)=\hat h(x)$. ∎
Uses: `def:avss`, `def:agree`.
Blueprint-only: only `lem:avss-dist` uses it.

**B6b — paper, keeps the label `lem:avss-dist` (statement unchanged).**

*Proof.* (1) `lem:avss-close` gives $\agree(u_h,\hat h|_{L_0})\ge1-2\delta_0$. (2) Let
$c=U_q|_{L_0}\in C_{w^X,t}$, so $\deg_{w^X}q\le t<\deg_Xh=\deg_{w^X}h'$ by `lem:avss-bits`; hence
$q\ne h'$, and `lem:inj` applied to the $T$-free polynomials $q,h'$ gives $\hat q\ne\hat h$. (3) Two
distinct polynomials of degree $<2^{2\tau}$ agree on fewer than $2^{2\tau}=\rho N$ points of $L_0$,
so $\Delta(\hat h|_{L_0},c)>\rho$. (4) Since
$\Delta(u_h,c)\ge\Delta(\hat h|_{L_0},c)-\Delta(u_h,\hat h|_{L_0})$ and $\agree=1-\Delta$, step 1
gives $\agree(u_h,c)<1-\rho+2\delta_0$; the maximum over $c$ gives the claim. ∎
Uses: `lem:avss-close`, `lem:avss-bits`, `lem:inj`, `def:codes`, `def:agree`.

Δ −2 lines. Risk: none. It also removes an undefined symbol from `L16-distance.tex:21` (see F10).

### B7 — `prop:avss-cost` (statement 12, proof 12 lines in 5 steps) → lemma and proposition

Step 1 computes the caps $d_i$ for $w=w^X$ and $D=t$; steps 2–5 sum and estimate. Step 1 is the only
use of the hypothesis $2^\tau\ge t+1$ (see D14) and the only piece that a different $w$ would change.

**B7a — blueprint-only, new label.**

```latex
\begin{lemma}[The caps for $w^X$]\label{lem:avss-caps}
Let $k=2$, $w=w^X$, $D=t$ and $t\le2^\tau-1$, and let
$d_i=\min\big(D,(k-1)\sum_{l\le i}w_l\big)$. Then $d_i=\min(t,2^i-1)$ for $0\le i\le\tau$ and
$d_i=t$ for $\tau<i\le2\tau$.
\end{lemma}
```

*Proof.* For $i\le\tau$, $(k-1)\sum_{l\le i}w_l=\sum_{l\le i}2^{l-1}=2^i-1$; for $i>\tau$ the sum is
$2^\tau-1$, so $t\le2^\tau-1$ gives $d_i=\min(t,2^\tau-1)=t$. ∎
Uses: `def:protocol`, `def:avss`.

**B7b — paper, keeps the label `prop:avss-cost` (statement unchanged).**

*Proof.* (1) By `lem:avss-caps`, $d_j+1=\min(t+1,2^j)\le2^j$ for $j<\tau$ and $d_j=t$ for
$j\ge\tau$. (2) Splitting at $\tau$,
$\sum_{i=1}^{2\tau}(d_{i-1}+1)\le\sum_{j=0}^{\tau-1}2^j+\sum_{j=\tau}^{2\tau-1}(t+1)
=2^\tau-1+\tau(t+1)$. (3) One repetition reads $k\sum_i(d_{i-1}+1)$, twice the sum, and the
asymptotics follow as today. ∎
Uses: `lem:avss-caps`, `def:protocol`, `con:avss-mask`.

Δ −2 lines. Risk: none.

### B8 — `lem:avss-secret` (statement 11 lines, three items) → two lemmas

(a) is the uniformity of the mask, (b)+(c) are secrecy. (a) has a hypothesis no clause of (b) or (c)
shares: the independence of $e$ from $f$ and $\theta$.

**B8a — blueprint-only, new label.**

```latex
\begin{lemma}[The masked value is uniform]\label{lem:avss-uniform}
Let $f,e\in V_t$ with $e$ uniform and independent of $f$ and of $\theta\in\F^*$. Then $h:=f+\theta e$
is uniform on $V_t$ and independent of $f$ and of $\theta$.
\end{lemma}
```

*Proof.* $e\mapsto f+\theta e$ is a translation composed with a scaling by $\theta\ne0$, hence a
bijection of $V_t$; a uniform variable pushed through a bijection stays uniform, and as a function of
$e$ alone $h$ is independent of $f$ and $\theta$. ∎
Uses: `def:avss`.

**B8b — paper, keeps the label `lem:avss-secret`.**

```latex
\begin{lemma}[Secrecy]\label{lem:avss-secret}
Let $f\in V_t$, $\theta\in\F^*$ and let $e$ be uniform on $V_t$, independent of $f$, of $\theta$ and
of the randomness of the PCS. Then
\begin{enumerate}
\item[(a)] every message of \cref{con:avss-mask} is a function of $h=f+\theta e$, $\theta$, the
challenges $r_1,\dots,r_m$ and the query positions;
\item[(b)] given $\theta$, the challenges, the positions and the values of $\hat f$ at those
positions, a simulator produces a transcript distributed exactly as the honest one.
\end{enumerate}
\end{lemma}
```

*Proof.* Item (a) is step 2 of today's proof, unchanged. Item (b) is today's steps 3–4, unchanged:
sample $h$ uniform on $V_t$ (legitimate by `lem:avss-uniform`), output the transcript, and note that
opening $\hat e$ reveals $\hat e(x)=(\hat h(x)-\hat f(x))/\theta$, which needs $\theta\ne0$ — the one
use of $\theta\in\F^*$ besides `lem:avss-uniform`. ∎
Uses: `lem:avss-uniform`, `con:avss-mask`, `def:protocol`.

Rewiring: nothing cites (a) elsewhere. If the author prefers, (b) can be split off as well, but it is
three lines and shares all its hypotheses with (a), so that split buys nothing.

Δ −1 line. Risk: none.

### B9 — `lem:sz-total` (statement 11 lines) → lemma and corollary

The statement's last two sentences are a corollary: the box bound $m(k-1)/|\F|$, which is what
`prop:complete`(c) uses.

**B9a — paper, keeps the label `lem:sz-total`.**

```latex
\begin{lemma}[Schwartz--Zippel in the total degree]\label{lem:sz-total}
Let $m\ge1$, $D\in\N$ and let $0\ne f\in\F[x_1,\dots,x_m]$ have $\deg_{\mathbf 1}f\le D$, where
$\deg_{\mathbf 1}:=\deg_w$ for $w=\mathbf 1$ (\cref{def:wdeg}). Then for a uniform $r\in\F^m$,
$\Pr[f(r)=0]\le D/|\F|$.
\end{lemma}
```

*Proof.* As today, with the case analysis removed (C8). ∎
Uses: `def:wdeg`.

**B9b — paper, new label.**

```latex
\begin{corollary}[The box bound]\label{cor:box}
Let $0\ne f\in\F[x_1,\dots,x_m]$ with $\deg_{x_l}f<k$ for every $l$. Then $\deg_{\mathbf 1}f\le
m(k-1)$, and for a uniform $r\in\F^m$, $\Pr[f(r)=0]\le m(k-1)/|\F|$.
\end{corollary}
```

*Proof.* $\deg_{\mathbf 1}f=\max\{\sum_l\alpha_l:f_\alpha\ne0\}\le m(k-1)$; apply `lem:sz-total` with
$D=m(k-1)$. ∎
Uses: `lem:sz-total`, `def:wdeg`.

Rewiring: `prop:complete`(c) cites `cor:box`; `rem:total-app` (line 49) keeps `lem:sz-total` with
$m=1$. Internal edge: `cor:box -> lem:sz-total`.
Coupling with C5: C5 *is* this deduplication; accept either C5 or B9b, not both.

Δ +1 line. Risk: none (the trailing sentence of today's statement is removed from the statement and
becomes a numbered corollary — this is a statement change in form only; see "Statements that change").

### Results above target for which no split is proposed

| label | statement lines | why not |
|---|---|---|
| `hyp:ca` | 13 | one assertion of two conclusions; splitting it into two hypotheses forces every user to cite both and `prop:H1`/`prop:H2` to prove both. The length is preamble: F1 removes 4 lines. |
| `cor:share` | 12 | one idea (CA for subcodes). The length is `hyp:ca`'s preamble repeated; F1 removes 5 lines. |
| `prop:avss-sound` | 12 | one idea; the length is `def:avss` restated. F1/F2/T1 remove 4 lines. |
| `prop:H1`, `prop:H2` | 8, 7 | one idea each; the length is $\Theta_J,\Theta_U$ displayed. Nothing to split. |
| `cor:johnson`, `cor:ud` | 9, 8 | one idea each. |
| `prop:complete` | 9 | three clauses, but (a),(b),(c) share all hypotheses and are proved in 8 lines total; a split would create three one-line lemmas. D10 adds one guard to (c). |
| `lem:avss-bits` | 7 | one idea (binary digits are the weights); the 3 proof steps are 10 lines and each is one line of content. |
| `def:protocol` | 14 | a definition; see F1 and F4. |
| `def:avss` | 19 | a definition of six objects; see F10 and D14. |
| `rem:avss-threshold` | 20 | a remark containing a proof with two cases; C9 removes the case analysis, which is the real excess. |
| `rem:multi` | 15 | a remark whose content is a list of substitutions; F5, F6 and D2 change its clauses. |
| `ext:*`, `rem:proof-facts`, `rem:facts71` | 14, 21, 12, 6 | imported statements, quoted from [BCIKS20]; not ours to restructure. |

---

## Part C: simplification

### C.0 The duplicated arguments

| # | argument | occurrences |
|---|---|---|
| 1 | a nonzero polynomial of degree $<D$ cannot vanish on $\ge D$ points, and dually two distinct words of $\RS[\F,L,D]$ agree on fewer than $D$ points | `L01:26–28` (`lem:inj`), `L05:11–13` (`lem:div`), `L16:21–22` (`lem:avss-dist`), `total-degree:16` (`lem:sz-total`, $m=1$), `L15:25–26` and `L15:28–30` (`rem:avss-threshold`, twice) |
| 2 | $\sum_{\zeta\in\Omega_k}\zeta^j=k$ if $k\mid j$, else $0$ | `L03:21` (item a), `L03:25` (item c) |
| 3 | the $T$-degree of a monomial under a substitution is $\langle\delta,\alpha\rangle$ | `L04:17–19` (`lem:stab`a), `total-degree:33–34` (`lem:line-total`), `L14:34–38` (`lem:avss-bits`, in the binary case) |
| 4 | $k^i\lvert L_i\rvert=N$, and $\rho=k^{m-i}/\lvert L_i\rvert=k^m/N$ | `L09:14`, `L13:17` (implicitly), `L13:19`, `T1:35` ($Mn=N$), `T1:54–55`, `L14:5`, `protocol:27–28` |
| 5 | $\Delta=1-\agree$ and $\Delta(u,w)\ge\Delta(v,w)-\Delta(v,u)$ | `L16:23`, `L16:24`, `L07:9` ($\Delta$ named but never defined) |
| 6 | the box bound $m(k-1)/\lvert\F\rvert$ from Schwartz–Zippel | `completeness:19–22` and `total-degree:10–12`, where the second says in words that it is the first |
| 7 | two distinct polynomials of degree $\le d$ differ outside at most $d$ points | `L15:25–26` and `L15:29–30`, within one remark |
| 8 | $\lvert A\rvert\ge\nu(A)\lvert L_i\rvert>\rho\lvert L_i\rvert=k^{m-i}$ | `L13:18` (from $\beta_i^+\ge\alpha_*>\rho$) and `L13:19` (the conclusion), two lines of the same chain |

### C1 — `lem:roots`: the root bound and the RS distance

Occurrences 1 and 7 above. One lemma, three lines, replaces the argument in five proofs.

```latex
\begin{lemma}[Vanishing on many points]\label{lem:roots}
Let $L\subseteq\F$, $D\ge1$ and $P\in\F[Y]$ with $\deg P<D$. If $P(y)=0$ for every $y\in A$ and
$A\subseteq L$ with $\lvert A\rvert\ge D$, then $P=0$. Consequently, for $D\le\lvert L\rvert$, two
distinct $P,Q\in\F[Y]_{<D}$ agree on fewer than $D$ points of $L$.
\end{lemma}
```

*Proof.* A nonzero $P$ of degree $d<D$ has at most $d$ roots in the field $\F$ (an integral domain),
and $d<\lvert A\rvert$. The consequence is the first part applied to $P-Q$. ∎
Uses: nothing.

Rewiring, one line each: `lem:inj` (line 26–28) becomes "each $P_a$ vanishes on $L_i$, and
$\lvert L_i\rvert\ge k^{m-i}>\deg P_a$, so $P_a=0$ by `lem:roots`"; `lem:div` (11–13) the same with
$A$ in place of $L_i$; `lem:avss-dist` step 3 becomes "`lem:roots` with $D=2^{2\tau}$";
`rem:avss-threshold` (25–26, 28–30) becomes two applications. The hypothesis $\lvert A\rvert\ge D$
is exactly what each site proves today (`L05:4` assumes it, `L01:26` derives it, `L16:21` uses
$2^{2\tau}$). Δ −5 lines. Risk: none.

### C2 — `lem:rootsum`: the sum over the $\Omega_k$

Occurrence 2. Only `lem:fold-sub` uses it, twice; after B1 the two uses are in two different lemmas,
which is precisely the duplication.

```latex
\begin{lemma}[Sum over the $k$-th roots of unity]\label{lem:rootsum}
Let $\F$ be a field, $k\ge1$ invertible in $\F$, and $\Omega_k=\{\zeta\in\F:\zeta^k=1\}$, a group of
order $k$. Then for every integer $j$, $\sum_{\zeta\in\Omega_k}\zeta^j=k$ if $k\mid j$, and $0$
otherwise.
\end{lemma}
```

*Proof.* A finite subgroup of $\F^*$ is cyclic; let $\omega$ generate $\Omega_k$. If $k\mid j$ every
term is $1$ and the sum is $k$; otherwise $\omega^j\ne1$ and
$\sum_{i<k}\omega^{ij}=(\omega^{jk}-1)/(\omega^j-1)=0$, the case $k\mid j$ being the other
alternative. ∎
Uses: nothing. Δ −1 line. Risk: none; it is also the fact behind $\lvert\fib(y)\rvert=k$ in
`def:domains` (where $k\mid N\mid\lvert\F\rvert-1$, so $\lvert\Omega_k\rvert=k$).

### C3 — `lem:subst`: one substitution lemma for `lem:stab`(a) and `lem:line-total`

Occurrence 3: `lem:stab`(a) computes the graded degree of a monomial after substituting
$x_i\mapsto rT^{w_i}$, and `lem:line-total` computes the $T$-degree after substituting
$x_l\mapsto a_l+Tb_l$. Both are the same monomial computation, and the second proof is that
computation with the labels changed.

```latex
\begin{lemma}[Degree of a substitution]\label{lem:subst}
Let $R$ be a commutative ring, $w\in\N^m$, $D\in\N$ and $I\subseteq[m]$. For $l\in I$ let
$g_l\in R[T]$ with $\deg g_l\le w_l$, and substitute $x_l\mapsto g_l$ for $l\in I$ and
$x_l\mapsto x_l$ for $l\notin I$. If $q\in R[T][x_1,\dots,x_m]$ has $\gdeg_wq\le D$ and
$\deg_{x_l}q<k$ for every $l\notin I$, then the substituted polynomial has the same two properties.
\end{lemma}
```

*Proof.* The monomial $T^ax^\alpha$ maps to $T^a\prod_{l\in I}g_l^{\alpha_l}\prod_{l\notin I}
x_l^{\alpha_l}$, of $T$-degree at most $a+\sum_{l\in I}w_l\alpha_l$ and of $x_l$-degree $\alpha_l<k$
for $l\notin I$. Hence the graded degree $a+\sum_{l\in I}w_l\alpha_l+\sum_{l\notin I}w_l\alpha_l
=\langle w,\alpha\rangle$ is unchanged and $\le D$. ∎
Uses: `def:wdeg`.

Both users become one line:
`lem:stab`(a) is $I=\{i\}$, $g_i=rT^{w_i}$, $w_i=w_i$;
`lem:line-total` is $R=\F$, $w=\mathbf 1$, $I=[m]$, $g_l=a_l+Tb_l$ of degree $\le1=w_l$, giving
$\deg f(\mathbf a+T\mathbf b)\le\deg_{\mathbf 1}f$; for $a_l=b_l=0$ the monomial maps to $0$ and the
bound is unchanged.
Risk: this replaces two statements by one more general one, so it is listed under "Statements that
change". The proof is the union of `L04:17–19` and `total-degree:33–34`, no new argument.
Δ −3 lines.

### C4 — the bookkeeping identity $\lvert L_i\rvert=N/k^i$

Occurrence 4: six proofs write out "$k^i\lvert L_i\rvert=N$" or "$Mn=N$" at the point of use.

Proposal: one sentence at the end of `def:domains`, which costs no numbering:

```latex
\noindent Consequently $k^i\lvert L_i\rvert=N$ for $0\le i\le m$, the rate of
$\RS[\F,L_i,k^{m-i}]$ is $\rho:=k^m/N=k^{m-i}/\lvert L_i\rvert$ for every $i$, and $\lvert
L_i\rvert\ge k^{m-i}$.
```

Then `L09:14`, `L13:17`, `L13:19`, `T1:35`, `T1:54–55`, `L14:5` each lose their local derivation
(and `protocol:27–28` loses its two-line justification). This is also F2's definition of $\rho$ and
the hypothesis used in D-proposals. Δ −4 lines. Risk: none.

### C5 — the box bound stated once (`lem:sz-total` trailer vs `prop:complete`(c))

Occurrence 6. `total-degree:10–12` derives $m(k-1)/|\F|$ and says it "is the bound used in
`prop:complete`(c)"; `completeness:19–22` derives it a second time from the top form. **This is the
same edit as B9b**: the corollary `cor:box` above. Accept C5 or B9, not both; they differ only in
whether the surviving label is a corollary of `lem:sz-total` (B9) or a plain replacement of the
trailer (C5). Δ −2 lines. Risk: none.

### C6 — $\Delta$: define it and use the difference bound once

Occurrence 5. `\Delta` is used in four places and defined nowhere; `L16:23` uses
$\Delta(u,w)\ge\Delta(v,w)-\Delta(v,u)$.

Proposal: two clauses in `def:agree` (which is already numbered, so no counter moves):

```latex
\noindent Put $\Delta(u,v):=1-\agree(u,v)$; then $\Delta(u,w)\ge\Delta(v,w)-\Delta(v,u)$, because
$\{x:u(x)=w(x)\}\supseteq\{x:v(x)=w(x)\}\cap\{x:v(x)=u(x)\}$.
```

`L16:23–24` then cites it instead of writing the set inclusion a second time. Δ −1 line, and it
removes one undefined symbol. Risk: none.

### C7 — cite the named lemma instead of naming the theorem

`completeness:21–22` says "by Schwartz–Zippel" while the file's own proof of Schwartz–Zippel is
`lem:sz-total` at `total-degree:3`. Two ways to make this a citation:

1. after E1 (which puts `lem:sz-total` before `prop:complete`), write `by \cref{cor:box}`;
2. keep the name and add `[SZ]` to the bibliography of the paper, treating `lem:sz-total` as the
   self-contained proof of the cited fact.

Either is one line. The same applies at `total-degree:49` (`lem:sz-total` with $m=1$ is cited
correctly there). Δ 0. Risk: none.

The other standard facts in the file are already cited by name and need nothing: the Vandermonde
invertibility (`L08:11`), the union bound (`T1:15`), the degree of a product (`total-degree:20`), the
RS distance (becomes `lem:roots`, C1).

### C8 — `lem:sz-total`: delete the case $d=0$

The present proof splits off $d=0$ ("if $d=0$ then $f=f_0$ does not involve $x_m$ and the claim is the
induction hypothesis, so let $d\ge1$", `total-degree:17`). The split is unnecessary: for $d=0$ steps
3–5 are still valid — $\deg_{\mathbf 1}f_d=\deg_{\mathbf 1}f$, the induction hypothesis applies to
$f_d$, and step 4 ("conditioned on $f_d(r')\ne0$ the polynomial $T\mapsto f(r',T)$ has degree $d$")
gives the bound $0/\lvert\F\rvert$ for the uniform $r_m$. Shorter proof:

```latex
\begin{proof}
Induction on $m$. For $m=1$ a nonzero $f\in\F[T]$ of degree $\le D$ has at most $D$ roots.
For $m\ge2$ write $f=\sum_{j\le d}f_j(x_1,\dots,x_{m-1})x_m^j$ with $f_d\ne0$ and $d\ge0$, and
$r=(r',r_m)$. By induction $\Pr[f_d(r')=0]\le(\deg_{\mathbf 1}f-d)/|\F|$; conditioned on
$f_d(r')\ne0$ the polynomial $T\mapsto f(r',T)$ is nonzero of degree $d$ (for $d=0$ it is the
nonzero constant $f_0(r')$), so it vanishes at the uniform $r_m$ with probability at most
$d/|\F|$. Adding the two bounds gives $\deg_{\mathbf 1}f/|\F|$.
\end{proof}
```

Δ −1 line, one fewer case. Risk: none.

### C9 — `rem:avss-threshold`: two cases, one fact

Both cases end with the same argument — two distinct polynomials of degree $<m$ agree at fewer than
$m$ points — applied with $m=t+1$ (`L15:25–26`) and $m=2^\tau$ (`L15:28–30`). Write the fact once
(`lem:roots`, C1) and let the two cases be two applications:

```latex
\begin{enumerate}
\item If $P_A\ne P_B$ for two sets $A,B$ of $t+1$ parties, then $P_A,P_B$ are distinct of degree
$\le t$, so by \cref{lem:roots} $P_A(z)\ne P_B(z)$ outside at most $t$ values of $z$: the parties may
output different secrets.
\item If $P_A=P$ for every $A$, then $P$ agrees with $f(\cdot,0)$ on every $\omega_i$ while
$P\ne f(\cdot,0)$; both have degree $\le2^\tau-1$, so by \cref{lem:roots} $P(z)\ne\sigma$ outside at
most $2^\tau-1$ values of $z$.
\end{enumerate}
```

Δ −3 lines and one repeated root-count removed. Risk: none. If C1 is rejected, this proposal keeps the
root count inline and saves only the duplication of wording.

### C10 — `lem:avss-bad`: one sentence instead of three numbered steps

```latex
\begin{proof}
Let $\theta\ne\theta'$ and suppose $\deg_X(f+\theta e),\deg_X(f+\theta'e)\le t$. Then
$\deg_X\big((\theta-\theta')e\big)\le t$, and $\theta-\theta'\ne0$ is a scalar, so $\deg_Xe\le t$;
hence $\deg_Xf=\deg_X\big((f+\theta e)-\theta e\big)\le t$, contradicting $\deg_Xf>t$.
\end{proof}
```

Same three implications, no numbered list, and the last line states the contradiction where the
present proof states it last as well. Δ −2 lines. Risk: none; it is cosmetic.

### C11 — a line that should read $\le$, not $=$

`T1-soundness.tex:39`, the last line of `cor:johnson`'s proof:

```latex
$\sum_i(k-1)|L_i|^2=(k-1)N^2\sum_ik^{-2i}=\frac{N^2}{k+1}$
```

The middle sum is $\sum_{i=1}^mk^{-2i}=\frac{1-k^{-2m}}{k^2-1}$, so
$\sum_i(k-1)\lvert L_i\rvert^2=\frac{N^2(1-k^{-2m})}{k+1}<\frac{N^2}{k+1}$ for $m\ge1$. Witness at
$k=2$, $m=2$: the left side is $\frac{5N^2}{16}=0.3125N^2$ and $\frac{N^2}{k+1}=0.3333N^2$. The
displayed $\varepsilon_C$ (lines 27–28) uses $\frac{N^2}{k+1}$ as an upper bound, so **the
proposition's statement is correct and only this line is wrong**: it should read
$(k-1)N^2\sum_ik^{-2i}\le\frac{N^2}{k+1}$. Δ 0. Risk: none — no statement changes.

### C12 — `rem:avss-y` is `lem:avss-bits` plus a degree comparison

`rem:avss-y` (`L14:47–53`) re-derives the base-$2^\tau$ expansion of $\hat f$ that `lem:avss-bits`
already established. Shorter:

```latex
By \cref{lem:avss-bits} $\deg_Yf=\deg_{w^Y}f'$, and by \cref{def:kron}
$\hat f(Z)=f(Z,Z^{2^\tau})=\sum_{a,b}f_{a,b}Z^{a+2^\tau b}$ with $0\le a<2^\tau$; hence
$\deg\hat f=\max\{a+2^\tau b:f_{a,b}\ne0\}$ and $b\le t\iff a+2^\tau b<2^\tau(t+1)$ for
$0\le a<2^\tau$.
```

Δ −3 lines. Risk: none. (Whether this remark belongs in the results file at all is E1's business: it
is used by nothing in `proofs/`.)

---

## Part D: hypothesis audit

Every hypothesis of every numbered result, with the proof line where it is used. A dagger † marks
the ones that are not used as stated; those are the numbered proposals D1–D11 below, and D12 records
the ones that are used in a weaker form with no weakening available. The imported statements E1–E3
are quoted from [BCIKS20] and are not audited.

**The definitions that carry hypotheses.** `def:poly`, `def:kron`, `def:fold`, `def:wdeg`,
`def:codes` and `def:agree` carry none (they name objects), so they are absent from the table.

| definition | hypothesis (as printed) | used at | verdict |
|---|---|---|---|
| `def:domains` | $k\ge2$ | `L01:13–14` (the base-$k$ digits of $n(\alpha)$ are unique) | used, and only there |
| `def:domains` | $m\ge1$ | — | † D11: unused |
| `def:domains` | $k^m\mid N$ | `L01:27`, `L05:12`, `L13:19` (all through $\lvert L_i\rvert=N/k^i\ge k^{m-i}$) | used; this is the form in which it is used |
| `def:domains` | $N\mid\lvert\F\rvert-1$ | `L03:21` ("$k$ is invertible since $k\mid N\mid\lvert\F\rvert-1$"); `L03:25` ($\lvert\Omega_k\rvert=k$) | used only through $k\mid\lvert\F\rvert-1$, plus the existence of $L_0$ in the definition itself (D12.1) |
| `def:domains` | $L_0$ a coset of the subgroup of order $N$ | `L03:21`, `L03:25` (via $\fib(y)=x_0\Omega_k$) | used only through the fibres (D12.2) |
| `def:protocol` | $s\ge1$ | `T1:17` ($\alpha^s$) | used |
| `def:protocol` | $d_i=\min(D,(k-1)\sum_{l\le i}w_l)$ | `L04:12`, `L13:17`, `L13:19`, `P3:5–9` | used; defined twice (F3) |
| `def:avss` | $2^\tau\ge t+1$ | `P3:19` | used once (D12.6) |
| `def:avss` | $\delta_0\in[0,1]$ | `P2:21` | used |

| result | hypothesis (as printed) | used at | verdict |
|---|---|---|---|
| `lem:kron` | $R$ a commutative $\F$-algebra (from `def:poly:30`) | `L01:12` "substitution is $R$-linear"; `L01:15` "a basis is sent to a basis" | † D1: only the ring structure is used |
| `lem:inj` | $R=\F[T]$ | `L01:25` "write $U=\sum_aT^aP_a$"; `L01:28` | † D2: only $R$ a polynomial ring over a field |
| `lem:inj` | $0\le i\le m$ | `L01:26–27` ($\lvert L_i\rvert=N/k^i\ge k^{m-i}$) | used |
| `lem:fold-sub`(a) | $P_j\in R[Y]_{<k^{m-i}}$ | — | † D3: never used in (a) |
| `lem:fold-sub`(a),(c) | $k$ invertible in $R$ (from $k\mid N\mid\lvert\F\rvert-1$) | `L03:21` "$k$ is invertible since $k\mid N\mid\lvert\F\rvert-1$"; `L03:25` (factor $\frac1k$) | used |
| `lem:fold-sub`(b) | $q\in R[x_i,\dots,x_m]_{<k}$ | `L03:23` (via `lem:kron`, which needs the box) | used |
| `cor:terminal` | $f\in\F[x_1,\dots,x_m]_{<k}$, $w$, $r$, $c_i=r_iT^{w_i}$ | `L03:36` | used |
| `lem:stab`(a) | $r\in\F$ | `L04:17` ($r^jT^{a+w_ij}$) | typing only: no property of $r$ is used, $r=0$ allowed (see D.12) |
| `lem:stab`(a) | $q$ in the box, $\gdeg_wq\le D$ | `L04:18` "exponents of $x_{i+1},\dots,x_m$ unchanged, hence $<k$"; `L04:19` | used |
| `lem:stab`(c) | $c_l=r_lT^{w_l}$, $1\le l\le i$ | `L04:23–26` | used |
| `lem:div` | $v\in\Gc_i^{w,D}$ | `L05:10` ($v=U_q$ with $\gdeg_wq\le D$) | used |
| `lem:div` | $e\in\N$ | `L05:10–13` ($T^e$-coefficient bookkeeping) | used |
| `lem:div` | $A\subseteq L_i$, $\lvert A\rvert\ge k^{m-i}$ | `L05:11–12` "vanishes on $A$; since $\lvert A\rvert\ge k^{m-i}>\deg U_{q_a}$" | used, and sharp |
| `lem:div` | $e>D$ (case) | `L05:14` | derived, not assumed |
| `lem:unfold` | $v_j=T^{w_ij}p_j$ on $L_i$ | `L06:11–12` | for $j=0$ vacuous † D4 |
| `lem:unfold` | $v_j\in\Gc_i^{w,D}$ | `L06:11` (via `lem:div`) | used |
| `lem:ext`(1) | $\E\supseteq\F$ of degree $t$, $e_s$ an $\F$-basis | `L07:16–18` "decomposes uniquely as $P=\sum_se_sP_s$" | used only in (1) † D5 |
| `lem:ext`(1) | $L\subseteq\F$ | `L07:17` "$P_s(x)\in\F$ for $x\in L$" | used only in (1) |
| `lem:ext`(2) | — | `L07:19` (injectivity of $\varphi$) | only injectivity † D5 |
| `lem:ext`(3) | $z_j\in\F$ | `L07:20` "$\varphi$ is $\F$-linear" | used; this is the one place where challenges in $\F$ matter (the remark at `L07:24`) |
| `lem:subcode` | $V$ an $\E$-linear code, $v_0,\dots,v_l\in V$ | — | † D6: never used |
| `lem:subcode` | $S'\subseteq\F$, $\lvert S'\rvert>l$ | `L08:10` "pick distinct $z_0,\dots,z_l\in S'$" | used |
| `lem:subcode` | $W$ an $\F$-linear subspace | `L08:12–13` "$(A^{-1})_{j,a}\in\F$; since $W$ is $\F$-linear" | used |
| `lem:gran` | $\mu:L_i\to\frac1{k^i}\Z\cap[0,1]$ | `L09:11–13` ($\mu(x)=m_x/k^i$, $m_x\in\Z$) | integrality used; $[0,1]$ unused † D7 |
| `lem:gran` | $k^i\lvert L_i\rvert=N$ (from `def:domains`) | `L09:14` "using $k^i\lvert L_i\rvert=N$" | used |
| `lem:lift` | $\mu^{(i-1)}$ a weight, $\nu^{(i)}$ its fibre average | `L10:15–16` | used |
| `lem:lift` | $u,h:L_{i-1}\to R$ agree on every $\fib(y)$, $y\in A$ | `L10:13–14` | used; $R$ itself unused † D8 |
| `lem:start` | $u_0:L_0\to\F$ | `L11:12` "wherever it equals $u_0(x)\in\F$" (a $T$-free value) | used |
| `lem:no-increase` | $1\le i\le m$ | `L12:12` (the fibre structure of $\mu^{(i)},\nu^{(i)}$) | used |
| `hyp:ca` | $\alpha_*\in(0,1]$ | — | no explicit use; $\alpha_*\le1$ only keeps $\beta_i^+$ a probability in `lem:round` (D.12) |
| `hyp:ca` | $\mu$ with denominator $M$ | `H:9` (through $\Theta(n,M,l)$) | used |
| `hyp:ca` | every $\E\supseteq\F$ | `H:5`, applied at `L13:17` | used |
| `hyp:ca` | $\alpha\ge\alpha_*$ | `C1:17`, `L13:18` | used |
| `prop:H1` | $\kappa\ge3$ | `H:21–25` ($\alpha_0$, $\Theta_J$) | used |
| `prop:H1` | (F2) of `rem:proof-facts` | `H:31–33`: $\lvert S\rvert\le\lvert\F\rvert\le\lvert\E\rvert$, same characteristic | used, exactly as stated |
| `prop:H2` | $\alpha_*>\frac{1+\rho}2$ | `H:54` "gives $\varepsilon=n/\lvert\F\rvert$ in $(\star\star)$" | used once, in a bound (D.12) |
| `cor:share` | $W\subseteq V$ $\F$-linear | `C1:19` (via `lem:subcode`) | used |
| `cor:share` | $\lvert S\rvert>\Theta(n,M,l)$ | `C1:17` | used |
| `lem:round` | $\mathrm H(\alpha_*,\Theta)$ | `L13:18` (through `cor:share`) | used |
| `lem:round` | $\alpha_*>\rho$ | `L13:19` "$\nu^{(i)}(A)\ge\beta_i^+>\rho$, hence $\lvert A\rvert>\rho\lvert L_i\rvert$" | used |
| `lem:round` | $1\le i\le m$ | `L13:17`, `L13:19` ($k^{m-i}\ge1$) | used |
| `lem:round` | $u:L_{i-1}\to\F[T]_{\le d_{i-1}}$ | `L13:17` "$t:=1+\max(D,d_{i-1}+w_i(k-1))$" | used: only through the dimension $d_{i-1}$ |
| `lem:round` | $\mu^{(i-1)}$ with values in $\frac1{k^{i-1}}\Z$ | `L13:16` (via `lem:gran`), `L13:18` ($M=k^i$) | used |
| `thm:reduction` | $\mathrm H(\alpha_*,\Theta)$, $\alpha_*>\rho$ | `T1:15` (via `lem:round`) | used |
| `thm:reduction` | $\alpha\ge\alpha_*$ | `T1:16` ($\max(\cdot,\alpha_*)$ in the induction) | used, once |
| `thm:reduction` | $\agree(u_0,C_{w,D})\le\alpha$ | `T1:14` (via `lem:start`) | used |
| `cor:johnson` | $\kappa\ge3$ | `T1:34–39` | used |
| `cor:ud` | $\alpha>\frac{1+\rho}2$ | `T1:53` (via `prop:H2`) | used |
| `prop:complete` | $f\in\F[x_1,\dots,x_m]_{<k}$, $\deg_wf\le D$ | `L15` (a), `L19–22` (c) | used; $(c)$ also needs $f\ne0$ † D10 |
| `def:avss` | $2^\tau\ge t+1$ | `P3:19` "since $t\le2^\tau-1$" | used once, in P3 (D.12) |
| `def:avss` | $\delta_0\in[0,1]$ | `P2:21` with $\delta_0\le(1-\rho)/4$ | used |
| `lem:avss-bits` | $\deg_Xf,\deg_Yf<2^\tau$ | `L14:39–41` (the bijection $\{0,1\}^{2\tau}\to\{0,\dots,2^\tau-1\}^2$) | used |
| `lem:avss-bad` | $\deg_Xf,\deg_Xe,\deg_Yf,\deg_Ye<2^\tau$ | `L15:52–54`: only $\deg_Xe<\infty$ and $\deg_Xf>t$ | † D9: three of the four unused |
| `lem:avss-dist` | $\deg_Xf,\deg_Xe,\deg_Yf,\deg_Ye<2^\tau$ | `L16:17–22` | used, but only for well-posedness of $\hat f,\hat e$ (D.12) |
| `lem:avss-dist` | $\Delta(u_f,\hat f)\le\delta_0$, $\Delta(u_e,\hat e)\le\delta_0$ | `L16:14` "of size at most $2\delta_0N$" | used |
| `lem:avss-dist` | $\deg_Xh>t$ | `L16:18` "$t<\deg_Xh=\deg_{w^X}h'$" | used |
| `prop:avss-sound` | $\delta_0\le(1-\rho)/4$ | `P2:21` | used |
| `prop:avss-sound` | $\deg_Xf>t$ | `P2:18` (via `lem:avss-bad`, `lem:avss-dist`) | used |
| `prop:avss-sound` | $\alpha_*>\frac{1+\rho}2$ | `P2:22` | used |
| `lem:avss-secret` | $f\in V_t$, $\theta\in\F^*$ | `L17:16–17` (bijection), `L17:22` (division by $\theta$) | used, both times |
| `lem:avss-secret` | $e$ uniform, independent of $f,\theta$, PCS randomness | `L17:16–18`, `L17:24–26` | used |
| `prop:avss-cost` | $w=w^X$, $D=t$, $k=2$, $m=2\tau$ | `P3:18–23` | used |
| `lem:sz-total` | $m\ge1$, $0\ne f$, $\deg_{\mathbf 1}f\le D$ | `total-degree:16–20` | used |
| `lem:line-total` | $\mathbf a,\mathbf b\in\F^m$ | `total-degree:33` | no property is used; $\mathbf a=\mathbf b$ and $\mathbf a=\mathbf 0$ are allowed |
| `rem:total-app` | $\Pi_{\mathbf 1,D}$ certifies $\deg_{\mathbf 1}f\le D$ | `total-degree:47–49` | used |

### D1 — `lem:kron`: "$R$ a commutative $\F$-algebra" is used only as a commutative ring

The statement and the proof never mention $\F$; `L01:12` uses only that substitution is $R$-linear
and `L01:15` only that the monomials $x^\alpha$ with $\alpha$ in the box are an $R$-basis.
Weakened: in `def:poly:30`, "let $R$ denote a commutative $\F$-algebra" → "let $R$ denote a
commutative ring"; and in `lem:fold-sub`(a) add "$k$ invertible in $R$", which is the only place
$\F$-algebra structure is actually used (`L03:21`). Proof: unchanged, 0 lines.

### D2 — `lem:inj`: $R=\F[T]$ is used only as a polynomial ring over a field

`L01:25` expands $U^{(i)}_q$ in the monomials $T^a$; nothing needs a single variable, and
`rem:multi` (`variants:12`) already claims that `lem:inj` extends to $\F[T_1,\dots,T_p]$ verbatim.
Weakened: "Let $R=\F[T_1,\dots,T_p]$ and $0\le i\le m$", with `L01:25` read as
$U^{(i)}_q=\sum_\alpha T^\alpha P_\alpha(Y)$ and `L01:26–27` with $\alpha$ in place of $a$. Two
lines touched (indices only), no argument changed. This also makes `rem:multi`'s claim literally
true rather than a transport the reader must check.

### D3 — `lem:fold-sub`(a): the degree bound on $P_j$ is never used

The proof of (a) (`L03:21`) sums $P_{j'}(y)$ over $j'<k$ and never uses $\deg P_j<k^{m-i}$. The
bound is needed only in (b), where it comes from `lem:kron`. Weakened: in (a), "with
$P_j\in R[Y]_{<k^{m-i}}$" → "with $P_j\in R[Y]$" (and keep the bound in (b), where `lem:kron`
supplies it). Proof unchanged, 0 lines.

### D4 — `lem:unfold`: the hypothesis is vacuous for $j=0$

`L06:5` assumes $v_j(y)=T^{w_ij}p_j(y)$ for $0\le j<k$; for $j=0$ this is $v_0=p_0$, no condition on
$v_0$ at all. Weakened: "let $v_1,\dots,v_{k-1}\in\Gc_i^{w,D}$ and $p_1,\dots,p_{k-1}$ satisfy
$v_j=T^{w_ij}p_j$; put $p_0:=v_0$". Proof: the same, with the $j=0$ instance of `lem:div` deleted
from the quantifier — one line (`L06:11`) reads "for $1\le j<k$". Risk: changes a statement.

### D5 — `lem:ext`: items (2) and (3) need neither the basis nor the degree

`L07:19` uses injectivity only; `L07:20` uses $\F$-linearity only. Weakened for item (2): "let
$\varphi:\F^t\to\E$ be an injective $\F$-linear map"; for item (3), "$\varphi$ $\F$-linear". This is
exactly the split B3b, so accept B3 and D5 together (B3b's statement above already carries the
weakened hypothesis). Proof unchanged.

### D6 — `lem:subcode`: $V$ and $v_j\in V$ are never used

The proof (`L08:10–13`) needs only: $P_a:=\sum_jz_a^jv_j\in W$, the Vandermonde matrix invertible,
$(A^{-1})_{j,a}\in\F$, and $W$ $\F$-linear. $V$'s $\E$-linearity and $v_j\in V$ appear nowhere.
Weakened: "let $W$ be an $\F$-vector space of words on $L$ and $v_0,\dots,v_l$ words with
$\sum_{j\le l}z^jv_j\in W$ for every $z\in S'$, $\lvert S'\rvert>l$; then $v_j\in W$". Proof
unchanged, 0 lines. Safe for its only user: in `lem:round` step 4, $W=\Gc_i^{w,D}\subseteq
\RS[\E,L_i,k^{m-i}]$ anyway.

### D7 — `lem:gran`: $\mu(x)\in[0,1]$ is never used

`L09:11–13` uses only $\mu(x)=m_x/k^i$ with $m_x\in\Z$. Weakened: "$\mu:L_i\to\frac1{k^i}\Z$".
Proof unchanged, 0 lines. (The bound $\beta^+$ is then read on the lattice $\frac1N\Z$, which is all
the second sentence uses.)

### D8 — `lem:lift`: the codomain $R$ is arbitrary

`L10:13–16` compares sets and adds weights; nothing about $R$ is used. Weakened: "let $u,h:L_{i-1}\to
A$ be maps into any set $A$". Proof unchanged, 0 lines. (Worth doing only because a formalization
then does not need a ring instance for this node.)

### D9 — `lem:avss-bad`: three of the four degree bounds are unused

The proof (`L15:50–54`) uses $\deg_Xf>t$ and nothing but the finiteness of $\deg_Xe$; $\deg_Xe<2^\tau$
and both $\deg_Y$ bounds appear only in the statement. Weakened: "let $f,e\in\F[X,Y]$ with
$\deg_Xf>t$; then $\deg_X(f+\theta e)\le t$ for at most one $\theta\in\F$". Proof unchanged: line 53
("so $\deg_Xe\le t$") already reads correctly for $e=0$, where $\deg_X0=-\infty\le t$. Note this
strengthens the lemma in a way the paper may want: the mask need not be in the box for the
one-bad-challenge step.

### D10 — `prop:complete`(c): the hypothesis $f\ne0$ is missing

`L19–22` speaks of "the coefficient of $T^{\deg_wf}$ in $g$", of $f^{\mathrm{top}}$, and of "no larger
power of $T$ occurring". For $f=0$, `defs:6` gives $\deg_w0=\max\emptyset=-\infty$ and there is no such
coefficient. The three claims are still true ($g=0$, both probabilities $0$, and the inequality
$0\le m(k-1)/\lvert\F\rvert$), so the repair is a guard, not a change of content: prepend "Let
$0\ne f\in\F[x_1,\dots,x_m]_{<k}$ …" (for $f=0$ all three items hold vacuously). One line; the proof
is unchanged.

### D11 — `def:domains`: $m\ge1$ is never used

No proof line uses $m\ge1$: for $m=0$ the statements of `thm:reduction`, `cor:johnson`, `cor:ud` are
true with an empty sum, and every other result quantifies over $1\le i\le m$ internally. (`lem:sz-total`
has its own $m\ge1$, which *is* used.) Proposed: drop "$m\ge1$" from `def:domains:22`, or keep it and
record that it is unused. 0 lines either way; it changes only whether the definition reads
"$m\ge1$" or "$m\ge0$".

### D.12 — Hypotheses used in a weaker form, where no weakening is available (recorded, no proposal)

These are recorded because the audit asked for them, and because each one tells a formalizer where
an assumption is *not* needed.

1. **`def:domains`: $N\mid\lvert\F\rvert-1$.** Used (i) to make "$L_0$ a coset of the subgroup of
   order $N$" meaningful — the definition needs it — and (ii) in the proofs only through
   $k\mid\lvert\F\rvert-1$, i.e. through $k$ invertible in $\F$ (`L03:21`) and $\lvert\Omega_k\rvert=k$
   (`L03:21`, `L03:25`). No proof uses the full divisibility. A weaker definition is possible
   (fix $L_0\subseteq\F^*$ of size $N$ and require $x\mapsto x^k$ to be $k$-to-1 on each $L_{i-1}$),
   but it would have to be re-verified that $L_i$ is then still the domain one needs; not proposed,
   the gain is nil.
2. **`def:domains`: "coset of the subgroup of order $N$".** Every proof uses only: for $y\in L_i$ and
   $x_0\in\fib(y)$, $\fib(y)=x_0\Omega_k$ and $\lvert\Omega_k\rvert=k$ (`L03:21`, `L03:25`). No proof
   multiplies two elements of $L_0$. The group structure of $L_0$ is therefore never used beyond the
   fibres.
3. **`lem:stab`(a): $r\in\F$** is a typing constraint: $r$ must be a scalar for $r^jT^{a+w_ij}$ to
   have $T$-degree $a+w_ij$. No property of $r$ is used, in particular $r$ may be $0$.
4. **`lem:avss-dist`: the four degree bounds** are used in the proof only through $\deg_Xh,\deg_Yh<
   2^\tau$ (`L16:17–21`), but they are needed *as stated* for well-posedness: the hypothesis
   $\Delta(u_f,\hat f)\le\delta_0$ mentions $\hat f$, which `def:avss` defines only for polynomials of
   individual degree $<2^\tau$. No weakening.
5. **`prop:H2`: $\alpha_*>\frac{1+\rho}2$** is used exactly once, at `H:54`, to read
   $\varepsilon=n/\lvert\F\rvert$ in $(\star\star)$. That is not a weaker form of the hypothesis but
   the whole content of the unique-decoding regime; no weakening.
6. **`def:avss`: $2^\tau\ge t+1$** is used once, at `P3:19` ($t\le2^\tau-1$), and nowhere in the
   soundness chain. Recorded so that a formalization of P2 does not have to carry it.
7. **`hyp:ca`: $\alpha_*\le1$** has no explicit use; it is what keeps $\beta_i^+$ a probability in
   `lem:round:16`.
8. **`lem:div`: $\lvert A\rvert\ge k^{m-i}$** is used at `L05:12` in the strict form
   $k^{m-i}>\deg U_{q_a}$; the hypothesis is sharp (with $\lvert A\rvert=k^{m-i}-1$ the conclusion
   fails for the polynomial vanishing exactly on $A$).

---

## Part E: flow

### E1 — the section order of the results file

The suggested six groups are almost what the file already does: the current order is
encoding (L01–L06), coding theory (L07–L10), imported and H (external, H), the protocol
(`protocol`), rounds and soundness (L13, T1, completeness), variants, applications (L14–P3,
total-degree). Four moves are needed; the rest is confirmation.

**Proposed order.** Compiled numbers are the present ones, so the moves can be read off.

*Block 1 — Encoding and degree bookkeeping.*
`def:domains` (D1), `def:poly` (D2), `def:kron` (D3), `def:wdeg` (D5), `def:codes` (D6),
`def:agree` (D7), `def:fold` (D4) — unchanged, in this order —, `lem:kron` (L1), `lem:inj` (L2),
**`lem:sz-total` (L18, moved here)**.

*Block 2 — Folding algebra.*
`lem:fold-sub` (L3), `cor:terminal` (L3.1), `lem:stab` (L4), `lem:div` (L5), `lem:unfold` (L6).

*Block 3 — Coding theory.*
`lem:ext` (L7), `lem:subcode` (L8), `lem:gran` (L9).

*Block 4 — Imported results and the hypothesis.*
`ext:bciks72` (E1), `rem:proof-facts` (2), `ext:bciks71` (E3), `rem:facts71` (3), `hyp:ca` (H),
`prop:H1` (P-H1), `prop:H2` (P-H2), `cor:share` (C1).

*Block 5 — Protocol and soundness.*
`def:protocol` (D8), `def:weights` (D9), `ext:claim85` (E2), `lem:start` (L11),
`lem:no-increase` (L12), `lem:lift` (L10), `lem:round` (L13), `thm:reduction` (T1),
`cor:johnson` (C2), `cor:ud` (C3), remark on individual degrees (4), `rem:char` (5),
`prop:complete` (P1), `rem:multi` (6), `rem:separate` (7).

*Block 6 — Applications.*
`def:avss` (D10), `lem:avss-bits` (L14), `rem:avss-y` (8), `con:avss-mask` (D11),
`rem:avss-threshold` (9), `lem:avss-bad` (L15), `lem:avss-dist` (L16), `prop:avss-sound` (P2),
`lem:avss-secret` (L17), `rem:avss-leak` (10), `prop:avss-cost` (P3), `lem:line-total` (L19),
`rem:total-app` (11), `rem:total-prior` (12).

*Closing.* The dependency graph section.

**What actually moves, and why.**

| label | now | new | reason |
|---|---|---|---|
| `lem:sz-total` | last block (L18) | block 1 | `prop:complete`(c) uses it; leaving it last is a forward reference. It depends only on `def:wdeg`, so it is a tool, not an application. The total-degree *application* (`lem:line-total`, remarks 11–12) stays in block 6. |
| `ext:claim85` | with the other imported results | block 5 | its statement names the weights of `def:weights` and one query of `def:protocol`: it cannot precede them. |
| `lem:lift`, `lem:no-increase` | before `def:weights` | block 5, after `def:weights` | both quote `ν^{(i)}`/`μ^{(i)}` of `def:weights`; today they are forward references (Part A, fact 2). `lem:start` is placed in the same block because it is the base case of `thm:reduction`'s induction; no dependency forces it there and it may stay in block 3. |
| `ext:bciks72`, `rem:proof-facts`, `ext:bciks71`, `rem:facts71` | after L12 | block 4, after `lem:gran` | they depend on nothing in blocks 1–3 and must precede `hyp:ca`. |

Two deviations from the suggested grouping, both forced by the graph:

1. **`lem:lift` sits in block 5, not with the coding theory.** Its statement needs `ν^{(i)}` from
   `def:weights`, which needs the transcript of `def:protocol`, which cannot precede block 5. If the
   author wants the suggested grouping exactly, the alternative is to split `def:weights` into the
   fibre average `ν^{(i)}` (belongs with `lem:lift`) and the checked weight `μ^{(i)}` (belongs with
   the protocol). That is a definitional split with no change of content, and it would put
   `lem:lift` and `lem:gran` together; it is not proposed as a separate number because it is only
   worth doing if E1 is accepted.
2. **`lem:sz-total` sits in block 1, not with the total-degree application** — see the table.

**Dependency graph.** 56 labels, 109 edges, `A -> B` meaning "*B* uses *A*". Checked mechanically:
no edge points forward in the order above and the graph has no cycle. `def:poly` is the only
isolated node (referenced once, at `total-degree:11`).

```
def:kron -> lem:kron
def:domains -> lem:inj
lem:kron -> lem:inj
def:wdeg -> lem:sz-total

def:domains -> lem:fold-sub
def:fold -> lem:fold-sub
def:kron -> lem:fold-sub
lem:kron -> lem:fold-sub
def:fold -> cor:terminal
lem:fold-sub -> cor:terminal
def:wdeg -> lem:stab
def:codes -> lem:stab
lem:fold-sub -> lem:stab
def:codes -> lem:div
lem:inj -> lem:div
def:kron -> lem:unfold
def:codes -> lem:unfold
lem:div -> lem:unfold
lem:inj -> lem:unfold
lem:fold-sub -> lem:unfold

def:codes -> lem:ext
def:agree -> lem:ext
def:agree -> lem:gran
def:domains -> lem:gran

ext:bciks72 -> hyp:ca
rem:proof-facts -> hyp:ca
ext:bciks72 -> prop:H1
rem:proof-facts -> prop:H1
ext:bciks71 -> prop:H2
rem:facts71 -> prop:H2
hyp:ca -> cor:share
lem:subcode -> cor:share

def:domains -> def:protocol
def:codes -> def:protocol
def:weights -> ext:claim85
def:protocol -> ext:claim85
def:codes -> lem:start
def:agree -> lem:start
def:kron -> lem:start
def:weights -> lem:no-increase
def:agree -> lem:no-increase
def:agree -> lem:lift
def:weights -> lem:lift
def:domains -> lem:lift
hyp:ca -> lem:round
cor:share -> lem:round
lem:div -> lem:round
lem:ext -> lem:round
lem:fold-sub -> lem:round
lem:gran -> lem:round
lem:lift -> lem:round
lem:unfold -> lem:round
def:protocol -> lem:round
lem:start -> thm:reduction
lem:round -> thm:reduction
lem:no-increase -> thm:reduction
ext:claim85 -> thm:reduction
prop:H1 -> cor:johnson
thm:reduction -> cor:johnson
prop:H2 -> cor:ud
thm:reduction -> cor:ud
def:codes -> rem:individual
ext:bciks72 -> rem:char
def:protocol -> prop:complete
lem:stab -> prop:complete
cor:terminal -> prop:complete
lem:sz-total -> prop:complete
lem:inj -> rem:multi
lem:fold-sub -> rem:multi
lem:stab -> rem:multi
lem:div -> rem:multi
lem:unfold -> rem:multi
lem:round -> rem:multi
thm:reduction -> rem:multi
def:codes -> rem:separate

def:domains -> def:avss
def:kron -> def:avss
def:codes -> def:avss
def:avss -> lem:avss-bits
def:wdeg -> lem:avss-bits
def:avss -> rem:avss-y
lem:avss-bits -> rem:avss-y
def:avss -> con:avss-mask
def:protocol -> con:avss-mask
def:avss -> rem:avss-threshold
def:avss -> lem:avss-bad
def:avss -> lem:avss-dist
con:avss-mask -> lem:avss-dist
lem:avss-bits -> lem:avss-dist
lem:inj -> lem:avss-dist
def:codes -> lem:avss-dist
def:agree -> lem:avss-dist
def:avss -> prop:avss-sound
con:avss-mask -> prop:avss-sound
lem:avss-bad -> prop:avss-sound
lem:avss-dist -> prop:avss-sound
cor:ud -> prop:avss-sound
def:avss -> lem:avss-secret
con:avss-mask -> lem:avss-secret
def:protocol -> lem:avss-secret
con:avss-mask -> rem:avss-leak
def:avss -> prop:avss-cost
con:avss-mask -> prop:avss-cost
def:protocol -> prop:avss-cost

def:wdeg -> lem:line-total
lem:sz-total -> rem:total-app
lem:line-total -> rem:total-app
def:protocol -> rem:total-app
rem:total-app -> rem:total-prior
```

Edges that the present `\uses` lines get wrong, and that the list above corrects (F10 does the
editing): `lem:div` does not use `lem:kron`; `lem:start` uses `def:kron`, not `lem:kron`;
`lem:avss-bad` uses neither `def:avss` nor `con:avss-mask`; `lem:round` reaches `hyp:ca` only
through `cor:share` (both edges are kept, since the hypothesis is also assumed directly);
`lem:ext` is used by `lem:round`, not by L6 and L8 (`L07:22` today says `\usedby{L6, L8}`);
`lem:stab` is not used by `lem:round` (`L04:28` today says so).

Accepting a B proposal adds edges but never removes one: each sub-lemma inherits the users of the
label it came from, and the new internal edges are listed in the proposal. Accepting C1, C2, C3 or
C4 inserts a node in block 1 (or block 2 for `lem:subst`) with the users named in Part C; none of
them points forward.

---

## Part F: notation and definitions

### F.0 The four defects, before the proposals

1. **Used before defined.** $\rho$ is introduced inside `hyp:ca` (`H:6`, "of rate $\rho=d/n$"),
   used in `lem:round` (`L13:17`, "of rate $\rho$", `L13:19`, "$\rho\lvert L_i\rvert=k^{m-i}$") where
   it is a different formula ($k^m/N$), and *re*-introduced in `cor:johnson:23` ($\rho:=k^m/N$) and
   `def:avss:5` ($\rho:=2^{2\tau}/N$). $\Delta$ is used at `L16:6`, `L16:22–24` and `L07:9` and is
   defined nowhere (only implicitly by "$\agree(u,v)=1-\Delta(u,v)$", `defs:72`). $d_i$ is used at
   `L04:12` and defined again at `protocol:6`. $\hat h$ is used at `L16:15` and `L16:21` and defined
   nowhere. $\mu^{(i)},\nu^{(i)}$ are used at `L10:5` and `L12:4`, defined at `protocol:20`.
2. **One name, several objects.** $t$: the extension degree (`L07:4`, `L13:17`, `variants:14`), the
   AVSS total-degree bound (`def:avss`, `P2`, `P3`), and the bound in $\F[T]_{<t}$ (`defs:15`).
   $k$: the folding arity everywhere and [BCIKS20]'s dimension in `external:5–7`. $s$: the number of
   repetitions (`protocol:4`) and the constraint index (`variants:4–20`). $A$: a set of points
   (`L05:4`, `L10:5`), the Vandermonde matrix (`L08:11`), and the constants of $\Theta_J$
   (`T1:34`). $e$: the $T$-exponent (`L05:4`, `L06:5`), the mask polynomial (`def:avss`, `L15`,
   `L16`, `P2`), and the unit vector $e_l$ (`defs:10`). $S$: the set of $z$ of $\mathrm H$
   (`H:8`), the set of $z$ of `cor:share` (`C1:8`), and the set of challenges $r$ of `lem:round`
   (`L13:9`) — the third is already called $S_i$ in `T1:15`.
3. **Two names, one object.** $C_{w,D}$ and the $T$-free part of $\Gc_0^{w,D}$ (bridged by
   `lem:start`); $d_i$ in `lem:stab`(c) and in `def:protocol`; $u_h$ in `con:avss-mask:7` and again
   in `lem:avss-dist:5`.
4. **Defined inside a proof, used elsewhere.** $\rho$ (`L13:17`); $h'$ and $\hat h$
   (`L16:17`, `L16:21`); $d_i$ (`L04:12`).

### F1 — `cor:share` quotes `hyp:ca`'s setting instead of repeating it

`prop:H1:30` already does this ("Let $\E,L,d,V,u_j,\mu,M,\alpha\ge\alpha_0,S,P_z$ be as in
`\ref{hyp:ca}`"). `cor:share:4–5` repeats four lines of it. Replacement, introducing no name:

```latex
Assume $\mathrm H(\alpha_*,\Theta)$ and let $\E,L,d,V,u_0,\dots,u_l,\mu,M,\alpha$ be as in
\cref{hyp:ca} with $\alpha\ge\alpha_*$. Let $W\subseteq V$ be an $\F$-linear subspace and let
\[ S:=\{z\in\F:\ \exists P_z\in W\ \text{with}\ \agree_\mu(\textstyle\sum_{j\le l}z^ju_j,P_z)\ge\alpha\} \]
satisfy $\lvert S\rvert>\Theta(n,M,l)$. Then …
```

Δ −3 lines. Risk: none; the same device is already in use two files later.

### F2 — one definition of $\rho$

Put $\rho:=k^m/N$ in the bookkeeping sentence of `def:domains` (C4), where $k^{m-i}/\lvert
L_i\rvert=\rho$ for every $i$ follows in the same line, and delete the local definitions at
`T1:23` and `L14:5`. The imported `E1`'s own $\rho=d/n$ stays as it is (it is a quotation).
Δ −2 lines. Risk: none.

### F3 — $d_i$ defined once

Delete the local definition at `L04:12` and put in `defs.tex`, as an unnumbered
`\paragraph` (so that the definition counter, which `protocol.tex:3` pins with
`\setcounter{definition}{7}`, does not move):

```latex
\paragraph{The caps.} For $w\in\N^m$ and $D\in\N$ put $d_0:=0$ and
$d_i:=\min\big(D,(k-1)\sum_{l\le i}w_l\big)$ for $1\le i\le m$; these are the formats of
\cref{def:protocol}.
```

Then `lem:stab`(c) writes $d_i$ without redefining it, and `def:protocol:6` keeps only "$d_0:=0$".
Δ 0 lines. Risk: the printed statement of `lem:stab`(c) changes (it loses an inline definition).

### F4 — $t$ carries four meanings

| meaning | sites |
|---|---|
| the extension degree, which is also the interleaving length, of `lem:ext` | `L07:4`, `L13:17`, `variants:14`, `def:codes:59` |
| the AVSS total-degree bound | `def:avss`, `lem:avss-*`, `prop:avss-*`, `P3` ($D=t$) |
| the bound in $\F[T]_{<t}$ | `defs:15` |

Proposal: keep $t$ for the AVSS bound (it is the only one that appears in a hypothesis the paper
cares about), rename the extension degree to $\tau_{\mathrm e}$ in `lem:ext`, `lem:round`,
`variants:14`, and change `defs:15` to $\F[T]_{<e}$ with $e$ bound in each use. The renaming is
mechanical and touches no argument. Risk: changes the printed statements of `lem:ext`,
`lem:round`, `rem:multi`; listed under "Statements that change".

### F5 — $k$ means the folding arity and [BCIKS20]'s dimension

`external:5–7`: "They state $\RS[\F_q,D,k]$ with *dimension* $k+1$; in our notation this is
$\RS[\F,L,d]$ with $d=k+1$, $L=D$, $n=|L|$". In that paragraph $k$ is [BCIKS20]'s dimension, while
everywhere else in the file $k$ is the folding arity (`def:domains:22`). Proposal: write the
translation with $\kappa$ for [BCIKS20]'s letter, "with dimension $\kappa+1$ … $d=\kappa+1$". One
sentence; no statement outside `external.tex` changes. Risk: low.

### F6 — $s$: repetitions and constraint index

`def:protocol:5` fixes $s$ as the number of repetitions, and `variants:4–20` uses $s$ as the index of
a weight $w^{(s)}$ and a bound $D_s$, in the same document and after `protocol.tex` has already fixed
the other meaning. Proposal: in `variants.tex` only, index the constraints by $c$ ($w^{(c)}$, $D_c$,
$C_{\mathbf w,\mathbf D}$ unchanged). Mechanical; 9 occurrences. Risk: none.

### F7 — $A$: a set, a matrix, two constants

`L05:4`, `L10:5` (a set of points); `L08:11` (the Vandermonde matrix $A=(z_a^{\,j})_{a,j}$); `T1:34`
("with $A$ and $B$ the two constants of $\Theta_J$"). Proposal: the matrix becomes $\Lambda$, the
constants become $a_J,b_J$. Both are local to one proof; nothing else changes. Risk: none.

### F8 — $e$: exponent, mask, unit vector

`L05:4`, `L06:5` — the exponent $e$ of $T^e$ (eight occurrences, all in `lem:div`); `def:avss`
onwards ($e$, the mask); `defs:10` ($e_l$, the unit vector). Proposal: keep $e$ for the mask (it is
the one the reader meets in statements) and rename the exponent in `lem:div` to $j_e$; leave $e_l$
alone (subscripted, no collision in practice). The alternative, renaming the mask, touches five
files and is not worth it. Risk: low; `lem:div`'s printed statement changes.

### F9 — $S$: three sets

`lem:round:9` defines $S:=\{r\in\F:\dots\}$ while `T1:15` calls the same set $S_i$ and `hyp:ca:8` and
`cor:share:8` use $S$ for a set of $z$. Proposal: `lem:round`'s set becomes $S_i$ throughout, matching
`thm:reduction`. One line each in the statement and in step 1. Risk: changes the printed statement of
`lem:round` (name only).

### F10 — $(\cdot)'$, $\hat h$ and $u_h$

`def:avss` defines $f'$ and $\hat f$ for a polynomial $f$, and `con:avss-mask:7` defines $u_h$ for
$h=f+\theta e$. Then:

1. `lem:avss-dist:5` defines $h$ and $u_h$ **again**;
2. `lem:avss-dist:17` writes $\deg_{w^X}h'$, and `L16:21` writes $\hat h$ — the multilinear
   representative $h'$ of $h=f+\theta e$ and the word $\hat h$ are never defined.

Proposal: in `def:avss`, state $f'$ for every $f$ with $\deg_Xf,\deg_Yf<2^\tau$ and add the two
lines that make it usable elsewhere: "$(\cdot)'$ is $\F$-linear, so $(f+\theta e)'=f'+\theta e'$ and
$\hat h=\hat f+\theta\hat e$ for $h=f+\theta e$". Then `lem:avss-dist`'s statement reads "put
$h:=f+\theta e$ and $\hat h:=U_{h'}$" once, and its proof drops the local definition. Δ +1 line,
and one undefined symbol disappears (only `\Delta` then remains, C6). Risk: none.

### F11 — hygiene: the annotations are hand-maintained and three of them are wrong

| site | today | should be |
|---|---|---|
| `L05-divisibility.tex:16` | `\uses{\cref{def:codes,lem:inj,lem:kron}}` | `lem:kron` is never used in the proof |
| `L07-interleaved.tex:22` | `\usedby{L6, L8}` | plain text, and wrong: the user is `lem:round` |
| `L08-subcode.tex:15` | `\uses{nothing}` | correct; keep |
| `L11-start.tex:14` | `\uses{...,lem:kron}` | the proof uses `def:kron` (that $U^{(0)}_{q_0}$ is the $T$-free part) |
| `L04-stability.tex:28` | `\usedby{...,lem:round}` | `lem:round` never cites `lem:stab` |
| `L15-bad-challenge.tex:56` | `\uses{\cref{def:avss,con:avss-mask}}` | neither is used by the proof |
| `dependencies.tex:4–15` | prose with hard-coded "L1 … L13", "Corollary L3.1" | `\cref` everywhere: the numbers are positional, so **every B proposal above invalidates this file** until it is rewritten |
| `protocol.tex:3` | `\setcounter{definition}{7}` | survives only while exactly seven definitions precede `def:protocol`; F3 keeps the count by making the caps a `\paragraph`, F10 adds no definition. Any later insertion in `defs.tex` must bump it. |

Δ −6 lines (the `\usedby` lines and the prose graph shrink; the graph is derivable from `\uses`, and
the §"Dependency graph" section could be dropped entirely once E1 is accepted, since the order *is*
the graph). Risk: none. This is the one proposal that must accompany *any* accepted split, or the
cross-references will be wrong — which is why it is listed last but should be applied first.

### F12 — the orphan paragraph in `L15-bad-challenge.tex`

Lines 36–40 are a paragraph of claim between `rem:avss-threshold` and its `\uses`/`\usedby` line at
42: "This does not contradict [PolyFRIM, Thm 4.1]: …". Two problems: the annotation at 42 belongs to
the remark but reads as the paragraph's, and the paragraph is the remark's discussion, not a
statement of the results file. Proposal: move it inside `rem:avss-threshold`, after the two cases, and
leave the `\uses`/`\usedby` line directly after `\end{remark}`. Δ 0. Risk: none.

---

## Statements that change

Everything not listed here changes only a proof, a grouping or the order. The following alter what a
statement *says*:

**Change the content of a statement (weaker hypothesis or added guard).**

| proposal | label | change |
|---|---|---|
| D1 | `lem:kron`, `lem:fold-sub`(a), `def:poly` | "$R$ a commutative $\F$-algebra" → "$R$ a commutative ring" (+ "$k$ invertible in $R$" in (a)) |
| D2 | `lem:inj` | $R=\F[T]$ → $R=\F[T_1,\dots,T_p]$ |
| D3 | `lem:fold-sub`(a) | drops $P_j\in R[Y]_{<k^{m-i}}$ |
| D4 | `lem:unfold` | $0\le j<k$ → $1\le j<k$, with $p_0:=v_0$ |
| D5 | `lem:ext`(2),(3) | needs only an injective $\F$-linear map (realised by B3b) |
| D6 | `lem:subcode` | drops "$V$ an $\E$-linear code and $v_0,\dots,v_l\in V$" |
| D7 | `lem:gran` | drops $\mu(x)\in[0,1]$ |
| D8 | `lem:lift` | codomain $R$ → an arbitrary set |
| D9 | `lem:avss-bad` | drops $\deg_Xe,\deg_Yf,\deg_Ye<2^\tau$ |
| D10 | `prop:complete` | **adds** $f\ne0$ to (c) |
| D11 | `def:domains` | drops $m\ge1$ |

**Change the form of a statement, not its content.**

| proposal | label | change |
|---|---|---|
| B2 | `lem:stab` | loses items (b) and (c) to `lem:stab-codes`, `lem:stab-cap`; (a) unchanged |
| B3 | `lem:ext` | loses item (2) to `lem:ext-agree` |
| B8 | `lem:avss-secret` | loses item (a) to `lem:avss-uniform` |
| B9 / C5 | `lem:sz-total` | loses its two-sentence trailer, which becomes `cor:box` |
| C3 | `lem:stab`(a), `lem:line-total` | both replaced by the more general `lem:subst` |
| F2 | `cor:johnson`, `def:avss` | lose their local "$\rho:=\dots$" |
| F3 | `lem:stab`(c) | loses its local "$d_i:=\dots$" |
| F4 | `lem:ext`, `lem:round`, `rem:multi` | the extension degree is renamed |
| F5 | `external.tex` only | [BCIKS20]'s $k$ is renamed $\kappa$ in the translation paragraph |
| F6 | `rem:multi`, `rem:separate` | the constraint index $s$ is renamed |
| F7 | `lem:subcode`, `cor:johnson` proof | $A$ (matrix), $A,B$ (constants) renamed |
| F8 | `lem:div` | the $T$-exponent $e$ is renamed |
| F9 | `lem:round` | $S$ → $S_i$ |
| F10 | `def:avss`, `lem:avss-dist` | $(\cdot)'$ is defined for every $h$, and $\hat h$ appears in the statement |

No proposal changes what `thm:reduction`, `cor:johnson`, `cor:ud`, `prop:H1`, `prop:H2`, `hyp:ca`,
`lem:round`, `prop:avss-sound`, `lem:avss-dist`, `lem:avss-secret` or `prop:avss-cost` assert:
F2–F10 change only how they are written, and B4, B5, B6, B7, B8 leave their statements alone.
