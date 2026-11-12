import SymFRI.External

/-!
# The hypothesis  (`proofs/H-hypothesis.tex`)

`hyp:ca` is a `def … : Prop`, not an axiom; `prop:H1` and `prop:H2` discharge it from the two
strengthened readings of [BCIKS20] in `External.lean`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

/-- `hyp:ca`.  The statement `H(α_*, Θ)`: for every finite field satisfying the separability
hypothesis, domain, rate, weight, words, challenge set and *prescribed* witnesses `P_z`, if
`|S| > Θ(n,M,l)` then there are codewords `v_j` whose joint weighted agreement is at least `α` and
which reproduce the witnesses on a set `S' ⊆ S` with `|S'| ≥ (M n + 1) l`.

`κ` is carried because the separability hypothesis of `rem:char` depends on it (`D_Y < (2κ+1)/(2√ρ)`);
the `.tex` states `H` for `α_*` and `Θ` only. -/
def CA (rho alpha_star : ℝ) (Theta : ℕ → ℕ → ℕ → ℝ) (kappa : ℕ) : Prop :=
  ∀ (F : Type) [Field F] [Fintype F] [DecidableEq F], Separable F kappa rho →
  ∀ (L : Finset F) (d l : ℕ), d ≤ L.card → rho = (d : ℝ) / (L.card : ℝ) →
  ∀ (w : Weight L) (hl : 1 ≤ l) (u : Fin (l + 1) → L → F) (P : F → L → F) (S : Finset F)
    (alpha : ℝ),
    alpha_star ≤ alpha → Theta L.card w.M l < (S.card : ℝ) →
    (∀ z ∈ S, P z ∈ RS L d ∧ alpha ≤ (agreeOf w (curve z u) (P z) : ℝ)) →
    ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ RS L d) ∧ alpha ≤ (jointAgree w u v : ℝ) ∧
      ∃ S' : Finset F, S' ⊆ S ∧ (w.M * L.card + 1) * l ≤ S'.card ∧
        ∀ z ∈ S', ∀ x, (∑ j : Fin (l + 1), z ^ (j : ℕ) * v j x) = P z x

/-- `prop:H1`.  `H(α₀, Θ_J)` holds at the Johnson radius. -/
theorem H_johnson (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) (kappa : ℕ) (hkappa : 3 ≤ kappa) :
    CA rho (alpha0 rho kappa) (ThetaJ rho kappa) kappa :=
  bciks72_reading kappa hkappa rho hrho hrho1

/-- `prop:H2`.  `H(α_*, Θ_U)` holds for every `α_* > (1+ρ)/2`. -/
theorem H_unique (rho : ℝ) (hrho : 0 < rho) (hrho1 : rho ≤ 1) (alpha_star : ℝ)
    (halpha : (1 + rho) / 2 < alpha_star) (kappa : ℕ) (hkappa : 3 ≤ kappa) :
    CA rho alpha_star (ThetaU rho) kappa := by
  -- `bciks71_reading` also needs the first condition of `(★★)`, `|S| > l n`; deriving it from
  -- `Θ_U(n,M,l) > n` for `α ≥ α_* > (1+ρ)/2` is the step of `prop:H2`'s proof (a `sorry` in the
  -- `.tex` as well), so it is a `sorry` here.
  sorry

end SymFRI
