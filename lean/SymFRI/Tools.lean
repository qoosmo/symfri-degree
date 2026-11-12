import SymFRI.Defs

/-!
# Tools  (`proofs/L00-tools.tex`)

`lem:roots`, `lem:rootsum`, `lem:subst`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:roots`.  A polynomial of degree `< D` vanishing on `A` with `|A| ≥ D` is zero. -/
theorem roots_eq_zero {D : ℕ} (hD : 1 ≤ D) {P : Polynomial F} (hdeg : P.natDegree < D)
    {A : Finset F} (hA : D ≤ A.card) (h : ∀ y ∈ A, P.eval y = 0) : P = 0 := by
  sorry

/-- `lem:roots`, consequence: two distinct polynomials of degree `< D` agree on fewer than `D`
points. -/
theorem roots_card_lt {D : ℕ} {P Q : Polynomial F} (hP : P.natDegree < D)
    (hQ : Q.natDegree < D) (hne : P ≠ Q) {A : Finset F} (h : ∀ y ∈ A, P.eval y = Q.eval y) :
    A.card < D := by
  sorry

/-- `lem:rootsum`.  `Σ_{ζ ∈ Ω_k} ζ^j` is `k` if `k ∣ j` and `0` otherwise. -/
theorem rootsum (k : ℕ) (ω : F) (hk : orderOf ω = k) (j : ℤ) :
    (∑ a : Fin k, (ω ^ (a : ℕ) : F) ^ j) = if (k : ℤ) ∣ j then (k : F) else 0 := by
  sorry

/-- The substitution of `lem:subst`: `x_l ↦ g_l` for `l ∈ I`, the other variables unchanged. -/
noncomputable def subst {n : ℕ} (I : Finset (Fin n)) (g : Fin n → Polynomial F)
    (q : MvPolynomial (Fin n) (Polynomial F)) : MvPolynomial (Fin n) (Polynomial F) :=
  MvPolynomial.eval₂ MvPolynomial.C
    (fun j => if j ∈ I then MvPolynomial.C (g j) else MvPolynomial.X j) q

/-- `lem:subst`.  If `deg g_l ≤ w_l` on `I`, then the substitution keeps the graded degree `≤ D`
and the individual degrees `< k` of the variables outside `I`. -/
theorem subst_preserves {n k D : ℕ} {w : Fin n → ℕ} {I : Finset (Fin n)}
    {g : Fin n → Polynomial F} (hg : ∀ j ∈ I, (g j).natDegree ≤ w j)
    {q : MvPolynomial (Fin n) (Polynomial F)} (hbox : ∀ j ∉ I, q.degreeOf j < k)
    (hD : gdeg w q ≤ D) :
    gdeg w (subst I g q) ≤ D ∧ ∀ j ∉ I, (subst I g q).degreeOf j < k := by
  sorry

end SymFRI
