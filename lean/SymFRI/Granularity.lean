import SymFRI.Subcode

/-! # Granularity (`proofs/L09-granularity.tex`): `lem:gran`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:gran`.  With weights that are multiples of `1/k^i`, agreements on `L_i` are multiples of
`1/N`. -/
theorem granularity {k m : ℕ} (T : Tower F k m) (i : ℕ) (w : Weight (T.L i))
    (hmu : ∀ y, ∃ n : ℤ, w.mu y = (n : ℚ) / ((k : ℚ) ^ i)) (u v : T.L i → F) :
    ∃ n : ℤ, agreeOf w u v = (n : ℚ) / (T.N : ℚ) := by
  sorry

end SymFRI
