import SymFRI.Stability

/-! # Divisibility (`proofs/L05-divisibility.tex`): `lem:div`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:div`.  If `T ^ γ` divides `v` on `|A| ≥ k^(m-i)` points of `L_i`, then `v = T ^ γ p`
with `p` in the graded code of degree `D - γ`. -/
theorem divisible {k m : ℕ} (T : Tower F k m) (i : ℕ) (w : ℕ → ℕ) (D γ : ℕ)
    (v : T.L i → Polynomial F) (hv : v ∈ gradedCode T i w D) (A : Finset (T.L i))
    (hA : k ^ (m - i) ≤ A.card)
    (hdvd : ∀ y ∈ A, (Polynomial.X : Polynomial F) ^ γ ∣ v y) :
    ∃ p ∈ gradedCode T i w (D - γ), ∀ y, v y = Polynomial.X ^ γ * p y := by
  sorry

end SymFRI
