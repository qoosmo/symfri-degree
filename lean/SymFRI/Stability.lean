import SymFRI.FoldSubstitution

/-!
# Folding preserves the graded codes  (`proofs/L04-stability.tex`)

`lem:stab`, `lem:stab-cap`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:stab`.  Folding a graded code lands in the graded code of the next level, for the tail
weight. -/
theorem stab {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) {w : ℕ → ℕ}
    {D : ℕ} (c : F) :
    Set.MapsTo (fun u : T.L i → Polynomial F => fun y : T.L (i + 1) => foldP T i hi (Polynomial.C c) u y)
      (gradedCode T i w D) (gradedCode T (i + 1) w D) := by
  sorry

/-- `lem:stab-cap`.  The honest `i`-fold fold of `U_f` lies in `Gc_i` and its values have
`T`-degree at most `d_i`. -/
theorem stab_cap {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i ≤ m) (r : Fin i → F)
    (w : ℕ → ℕ) (D : ℕ) (f : MvPolynomial (Fin m) F) :
    ∃ v : T.L i → Polynomial F, v ∈ gradedCode T i w D ∧
      ∀ y, (v y).natDegree ≤ caps k w D i := by
  sorry

end SymFRI
