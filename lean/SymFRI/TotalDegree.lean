import SymFRI.Variants
import SymFRI.SzTotal

/-! # Total degree (`proofs/total-degree.tex`): `lem:line-total`, `rem:total-app`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- The restriction of `f` to the line `a + T b`. -/
noncomputable def lineRestrict {n : ℕ} (f : MvPolynomial (Fin n) F) (a b : Fin n → F) :
    Polynomial F :=
  MvPolynomial.eval₂ Polynomial.C
    (fun j : Fin n => Polynomial.C (a j) + Polynomial.C (b j) * Polynomial.X) f

/-- `lem:line-total`.  Restriction to a line has degree at most the total degree of `f`. -/
theorem line_total {n : ℕ} (f : MvPolynomial (Fin n) F) (a b : Fin n → F) :
    (lineRestrict f a b).natDegree ≤ totalDeg f := by
  sorry

/-- `rem:total-app`.  If the prover's `q` is not `f` on the line, the verifier's check fails at all
but at most `D` evaluation points: two claims are reduced to one, at error `D/|F|`. -/
theorem total_app {n D : ℕ} (f : MvPolynomial (Fin n) F) (a b : Fin n → F) (ya yb : F)
    (q : Polynomial F) (hq : q.natDegree ≤ D) (h0 : q.eval 0 = ya) (h1 : q.eval 1 = yb)
    (hne : q ≠ lineRestrict f a b) :
    (Finset.univ.filter fun ts : F => q.eval ts = (lineRestrict f a b).eval ts).card ≤ D := by
  sorry

end SymFRI
