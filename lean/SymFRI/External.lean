import SymFRI.Protocol

/-!
# Imported results  (`proofs/external.tex`)

The axioms of the project, and only here.  Each cites the exact item of
Ben-Sasson, Carmon, Ishai, Kopparty, Saraf, *Proximity Gaps for Reed--Solomon Codes*,
IACR ePrint 2020/654, version of 3 July 2021.

Every axiom carries the three hypotheses the `.tex` puts on the statement:

* the weight `μ`, with values in `[0,1]` and a common denominator `M ≥ 1` (`ext:bciks72`);
* the separability hypothesis of [BCIKS20, §5.2.3], quoted by `rem:char`:
  > "Henceforth, we will assume for simplicity that `Q` does not have inseparable irreducible
  > factors, i.e. that `f_i = 0` for all `i`.  Note that since any inseparable factor has
  > `Y`-degree at least `p`, this is necessarily the case if the characteristic is larger than
  > `D_Y` …"
  We take it in the form the remark uses: `char F` exceeds `D_Y`, and `D_Y` is bounded by
  `(2κ+1)/(2√ρ)`;
* `l ≥ 1`.

`bciks72` and `bciks71` are the statements as printed (witnesses existential).  `bciks72_reading`
and `bciks71_reading` are the **strengthened readings** of [BCIKS20, §7.1]: the witnesses `P_z` are
arbitrary and fixed in advance, and the codewords reproduce them on a set `S' ⊆ S` with
`|S'| ≥ (M n + 1) l` — facts (F1) and (F2) of `ext:proof-facts`, which are about the *proof* of the
theorem and are what `prop:H1` / `prop:H2` consume.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

/-- `α₀(ρ,κ) = √ρ (1 + 1/(2κ))`: the Johnson-radius threshold of `ext:bciks72`. -/
noncomputable def alpha0 (rho : ℝ) (kappa : ℕ) : ℝ :=
  Real.sqrt rho * (1 + 1 / (2 * (kappa : ℝ)))

/-- `Θ_J(ρ,κ)(n,M,l)`, the first threshold of `ext:bciks72`: `l · max(A n², B (M n + 1))` with
`A = (1+1/(2κ))⁷κ⁷/(3ρ^{3/2})` and `B = (2κ+1)/√ρ`. -/
noncomputable def ThetaJ (rho : ℝ) (kappa : ℕ) (n M l : ℕ) : ℝ :=
  (l : ℝ) * max
    ((1 + 1 / (2 * (kappa : ℝ))) ^ 7 * (kappa : ℝ) ^ 7 / (3 * rho ^ (3 / 2 : ℝ)) * (n : ℝ) ^ 2)
    ((2 * (kappa : ℝ) + 1) / Real.sqrt rho * ((M : ℝ) * n + 1))

/-- `η_U = min((1-√ρ)²/2, √ρ/20)` of `ext:bciks71`. -/
noncomputable def etaU (rho : ℝ) : ℝ := min ((1 - Real.sqrt rho) ^ 2 / 2) (Real.sqrt rho / 20)

/-- `Θ_U(ρ)(n,M,l) = l (M n + 1) (1/η_U + 3/√ρ)`, the threshold of `ext:bciks71`. -/
noncomputable def ThetaU (rho : ℝ) (n M l : ℕ) : ℝ :=
  (l : ℝ) * ((M : ℝ) * n + 1) * (1 / etaU rho + 3 / Real.sqrt rho)

/-- The separability hypothesis of [BCIKS20, §5.2.3], in the form `rem:char` states it: the
characteristic `p` of `F` is larger than `D_Y`, and `D_Y` is below `(2κ+1)/(2√ρ)`. -/
def Separable (F : Type*) [Field F] (kappa : ℕ) (rho : ℝ) : Prop :=
  ∃ p : ℕ, CharP F p ∧ (2 * (kappa : ℝ) + 1) / (2 * Real.sqrt rho) ≤ (p : ℝ)

/-- `ext:bciks72` — **[BCIKS20, Theorem 7.2]**, p. 33, ePrint 2020/654 (3 July 2021): weighted
correlated agreement over curves, at the Johnson radius, with the statement as printed. -/
axiom bciks72 (kappa : ℕ) (hkappa : 3 ≤ kappa) (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F], Separable F kappa rho →
    ∀ (L : Finset F) (d l : ℕ), d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
    ∀ (w : Weight L) (hl : 1 ≤ l) (u : Fin (l + 1) → L → F) (S : Finset F) (alpha : ℝ),
      alpha0 rho kappa ≤ alpha → ThetaJ rho kappa L.card w.M l < (S.card : ℝ) →
      (∀ z ∈ S, ∃ P ∈ RS L d, alpha ≤ (agreeOf w (curve z u) P : ℝ)) →
      ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧
        alpha ≤ (jointAgree w u v : ℝ)

/-- **Strengthened reading of [BCIKS20, §7.1]** — the axiom `prop:H1` uses: `ext:bciks72` with
facts (F1) and (F2) of `ext:proof-facts` built in.  The witnesses `P_z ∈ V` are arbitrary and fixed
in advance, `S ⊆ F` is any set of the stated size, and the codewords reproduce those `P_z` on a set
`S' ⊆ S` with `|S'| ≥ (M n + 1) l`. -/
axiom bciks72_reading (kappa : ℕ) (hkappa : 3 ≤ kappa) (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F], Separable F kappa rho →
    ∀ (L : Finset F) (d l : ℕ), d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
    ∀ (w : Weight L) (hl : 1 ≤ l) (u : Fin (l + 1) → L → F) (P : F → L → F) (S : Finset F)
      (alpha : ℝ),
      alpha0 rho kappa ≤ alpha → ThetaJ rho kappa L.card w.M l < (S.card : ℝ) →
      (∀ z ∈ S, P z ∈ RS L d ∧ alpha ≤ (agreeOf w (curve z u) (P z) : ℝ)) →
      ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧ alpha ≤ (jointAgree w u v : ℝ) ∧
        ∃ S' : Finset F, S' ⊆ S ∧ (w.M * L.card + 1) * l ≤ S'.card ∧
          ∀ z ∈ S', ∀ x, (∑ j : Fin (l + 1), z ^ (j : ℕ) * v j x) = P z x

/-- `ext:bciks71` — **[BCIKS20, Theorem 7.1]**, version I, in the unique-decoding range: the
statement as printed, with both conditions of `(★★)` of `external.tex`: the threshold `Θ_U` and
`|S| > l·n` (the first condition `|S| > l ε |F|` with `ε = n/|F|` of the unique-decoding range). -/
axiom bciks71 (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1)
    (alpha_star : ℝ) (halpha : (1 + rho) / 2 < alpha_star)
    (kappa : ℕ) (hkappa : 3 ≤ kappa) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F], Separable F kappa rho →
    ∀ (L : Finset F) (d l : ℕ), d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
    ∀ (w : Weight L) (hl : 1 ≤ l) (u : Fin (l + 1) → L → F) (S : Finset F) (alpha : ℝ),
      alpha_star ≤ alpha → ThetaU rho L.card w.M l < (S.card : ℝ) →
      (l : ℝ) * (L.card : ℝ) < (S.card : ℝ) →
      (∀ z ∈ S, ∃ P ∈ RS L d, alpha ≤ (agreeOf w (curve z u) P : ℝ)) →
      ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧
        alpha ≤ (jointAgree w u v : ℝ)

/-- **Strengthened reading of [BCIKS20, §7.1]** — the axiom `prop:H2` uses, with (F1) and (F2)
built in exactly as in `bciks72_reading`. -/
axiom bciks71_reading (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1)
    (alpha_star : ℝ) (halpha : (1 + rho) / 2 < alpha_star)
    (kappa : ℕ) (hkappa : 3 ≤ kappa) :
    ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F], Separable F kappa rho →
    ∀ (L : Finset F) (d l : ℕ), d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
    ∀ (w : Weight L) (hl : 1 ≤ l) (u : Fin (l + 1) → L → F) (P : F → L → F) (S : Finset F)
      (alpha : ℝ),
      alpha_star ≤ alpha → ThetaU rho L.card w.M l < (S.card : ℝ) →
      (l : ℝ) * (L.card : ℝ) < (S.card : ℝ) →
      (∀ z ∈ S, P z ∈ RS L d ∧ alpha ≤ (agreeOf w (curve z u) (P z) : ℝ)) →
      ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧ alpha ≤ (jointAgree w u v : ℝ) ∧
        ∃ S' : Finset F, S' ⊆ S ∧ (w.M * L.card + 1) * l ≤ S'.card ∧
          ∀ z ∈ S', ∀ x, (∑ j : Fin (l + 1), z ^ (j : ℕ) * v j x) = P z x

/-- `ext:claim85` — [BCIKS20, **Claim 8.5**]: the probability that one query accepts equals the
mean `(1/|L_m|) Σ_y μ^(m)(y)` of the last query weight.  Stated in the form the soundness proof
consumes it: if that weight is at most `alpha` at every point, one query accepts with probability at
most `alpha`.  (`thm:reduction` raises this to the `s` repetitions.) -/
axiom claim85 {F : Type*} [Field F] [Fintype F] [DecidableEq F] {k m s : ℕ} (T : Tower F k m)
    (w : ℕ → ℕ) (D : ℕ) (p : Prover T w D) (r : Fin m → F) (alpha : ℚ)
    [∀ ξ : T.L 0, Decidable (ChecksAt T w D p r ξ)]
    (hmu : ∀ y : T.L m, (muChain T w D s p r m le_rfl).mu y ≤ alpha) :
    ((Finset.univ.filter (fun ξ : T.L 0 => ChecksAt T w D p r ξ)).card : ℚ) /
      ((T.L 0).card : ℚ) ≤ alpha

end SymFRI
