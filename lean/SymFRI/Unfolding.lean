import SymFRI.Divisibility

/-! # Unfolding (`proofs/L06-unfolding.tex`): `lem:unfold`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:unfold`.  If `v_j = T ^ (w (i+1) * j) p_j` are graded codewords, then
`h = Σ_j x^j p_j (x^k)` is a graded codeword one level up whose components are the `p_j`. -/
theorem unfold {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (w : ℕ → ℕ) (D : ℕ)
    (p : Fin k → T.L (i + 1) → Polynomial F)
    (hp : ∀ j : Fin k, (fun y => Polynomial.X ^ (w (i + 1) * (j : ℕ)) * p j y) ∈
      gradedCode T (i + 1) w D) :
    ∃ h ∈ gradedCode T i w D, ∀ (j : Fin k) (y : T.L (i + 1)),
      componentsP T i hi h (j : ℕ) y = p j y := by
  sorry

end SymFRI
