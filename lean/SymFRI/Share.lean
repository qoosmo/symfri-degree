import SymFRI.Hypothesis

/-! # Correlated agreement for subcodes (`proofs/C1-share.tex`): `cor:share`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `cor:share`.  `hyp:ca` with the codewords required to lie in an `F`-linear subcode `W`. -/
theorem share {L : Finset F} {d l : ℕ} {rho alpha_star : ℝ} {Theta : ℕ → ℕ → ℕ → ℝ}
    {kappa : ℕ} (H : CA rho alpha_star Theta kappa) (hsep : Separable F kappa rho)
    (hd : d ≤ L.card) (hrho : rho = (d : ℝ) / (L.card : ℝ)) {w : Weight L} (hl : 1 ≤ l)
    {u : Fin (l + 1) → L → F} {W : Submodule F (L → F)} (hW : W ≤ RS L d) {S : Finset F}
    (P : F → L → F) (alpha : ℝ) (halpha : alpha_star ≤ alpha)
    (hcard : Theta L.card w.M l < (S.card : ℝ))
    (hP : ∀ z ∈ S, P z ∈ W ∧ alpha ≤ (agreeOf w (curve z u) (P z) : ℝ)) :
    ∃ v : Fin (l + 1) → L → F, (∀ j, v j ∈ W) ∧ alpha ≤ (jointAgree w u v : ℝ) := by
  sorry

end SymFRI
