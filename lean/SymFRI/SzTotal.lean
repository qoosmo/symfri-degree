import SymFRI.Counting

/-! # Schwartz--Zippel in the total degree (`proofs/L02-sz-total.tex`):
`lem:sz-total`, `cor:box`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:wdeg` with `w = 1`: the total degree. -/
noncomputable def totalDeg {n : ℕ} (f : MvPolynomial (Fin n) F) : ℕ :=
  wdeg (fun _ => 1) f

/-- `lem:sz-total`.  A nonzero polynomial of total degree `≤ D` vanishes on at most a `D/|F|`
fraction of the points. -/
theorem sz_total {n D : ℕ} {f : MvPolynomial (Fin n) F} (hf : f ≠ 0) (hD : totalDeg f ≤ D) :
    ((Finset.univ.filter fun r : Fin n → F => MvPolynomial.eval r f = 0).card : ℚ) ≤
      (D : ℚ) / (Fintype.card F : ℚ) := by
  sorry

/-- `cor:box`.  From the individual bounds alone: `deg_1 f ≤ m (k-1)`, and the `m(k-1)/|F|`
bound. -/
theorem box_bound {n k : ℕ} {f : MvPolynomial (Fin n) F} (hf : f ≠ 0) (hbox : InBox k f) :
    totalDeg f ≤ n * (k - 1) ∧
      ((Finset.univ.filter fun r : Fin n → F => MvPolynomial.eval r f = 0).card : ℚ) ≤
        ((n * (k - 1) : ℕ) : ℚ) / (Fintype.card F : ℚ) := by
  sorry

end SymFRI
