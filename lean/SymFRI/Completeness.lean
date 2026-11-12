import SymFRI.Soundness

/-! # Completeness (`proofs/completeness.tex`): `prop:complete`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `prop:complete`.  An honest prover passes every format and query check, and its terminal
polynomial is `g = f(r_1 T ^ w_1, …, r_m T ^ w_m)` of degree at most `D`. -/
theorem complete {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (r : Fin m → F)
    (f : MvPolynomial (Fin m) F) (hbox : InBox k f) (hD : wdeg (wvec w 0 m) f ≤ D) :
    ∃ g : Polynomial F,
      g = MvPolynomial.eval₂ Polynomial.C
        (fun j : Fin m => Polynomial.C (r j) * Polynomial.X ^ (w (j : ℕ))) f ∧
      g.natDegree ≤ D := by
  sorry

end SymFRI
