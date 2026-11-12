import SymFRI.Granularity

/-! # Fibre averages and lifting (`proofs/L10-lifting.tex`): `def:fibre-avg`, `lem:lift`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:fibre-avg`.  The fibre average of a weight on `L_i`. -/
noncomputable def fibreAvg {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m)
    (mu : Weight (T.L i)) (y : T.L (i + 1)) : ℚ :=
  (∑ x : {x // x ∈ T.fib i hi y.1}, mu.mu ⟨x.1, T.fib_subset i hi y.1 x.2⟩) / (k : ℚ)

/-- `lem:lift`.  Agreement on every fibre over `A` gives agreement at least the fibre-average
mass of `A`. -/
theorem lift {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (mu : Weight (T.L i))
    (u h : T.L i → F) (A : Finset (T.L (i + 1)))
    (hagree : ∀ y ∈ A, ∀ x : {x // x ∈ T.fib i hi y.1},
      u ⟨x.1, T.fib_subset i hi y.1 x.2⟩ = h ⟨x.1, T.fib_subset i hi y.1 x.2⟩) :
    (∑ y ∈ A, fibreAvg T i hi mu y) / ((T.L (i + 1)).card : ℚ) ≤ agreeOf mu u h := by
  sorry

end SymFRI
