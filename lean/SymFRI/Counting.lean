import SymFRI.Lifting

/-! # Counting bad challenge sequences (`proofs/L10b-counting.tex`): `lem:bad-count`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:bad-count`.  If the `i`-th bad set depends only on the prefix `(r_1, …, r_{i-1})` and has
at most `Θ i` elements, the bad challenges number at most `|F|^(m-1) Σ Θ i`. -/
theorem bad_count {m : ℕ} (bad : Fin m → (Fin m → F) → Prop)
    [∀ i r, Decidable (bad i r)] (Θ : ℕ → ℕ)
    (hdep : ∀ (i : Fin m) (r r' : Fin m → F), (∀ j, j < i → r j = r' j) → (bad i r ↔ bad i r'))
    (hcard : ∀ (i : Fin m) (r : Fin m → F),
      (Finset.univ.filter (fun r' : Fin m → F => bad i r' ∧ ∀ j, j < i → r' j = r j)).card ≤ Θ i) :
    (Finset.univ.filter (fun r : Fin m → F => ∃ i, bad i r)).card ≤
      (Fintype.card F) ^ (m - 1) * ∑ i : Fin m, Θ i := by
  sorry

end SymFRI
