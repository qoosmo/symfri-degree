import SymFRI.Kronecker

/-!
# Fold equals substitution  (`proofs/L03-fold-substitution.tex`)

`lem:fold-parts`, `lem:fold-sub`, `lem:fold-invert`, `cor:terminal`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:fold-parts`.  If `P = Σ_{j<k} Y^j P_j(Y^k)`, the components of `P` on `L_i` are the
`P_j` on `L_{i+1}`. -/
theorem components_eq {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (P : Polynomial F)
    (Pj : Fin k → Polynomial F)
    (hP : P = ∑ j : Fin k, Polynomial.X ^ (j : ℕ) * (Pj j).comp (Polynomial.X ^ k))
    (j : Fin k) (y : T.L (i + 1)) :
    components T i hi (fun x => P.eval x.1) (j : ℕ) y = (Pj j).eval y.1 := by
  sorry

/-- `lem:fold-sub`.  The fold of a Kronecker image is the Kronecker image of the substitution
`x_i ↦ c`. -/
theorem fold_subst {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (c : F)
    (q : MvPolynomial (Fin (m - i)) F) :
    ∃ q' : MvPolynomial (Fin (m - i - 1)) F, ∀ y : T.L (i + 1),
      fold T i hi c (fun x : T.L i => (kron (k := k) q).eval x.1) y = (kron (k := k) q').eval y.1 := by
  sorry

/-- `lem:fold-invert`.  `u(x) = Σ_j x^j u_j(x^k)`. -/
theorem fold_invert {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (u : T.L i → F)
    (x : T.L i) :
    (∑ j ∈ Finset.range k,
        (x.1 : F) ^ j * components T i hi u j ⟨x.1 ^ k, T.pow_mem i hi x.1 x.2⟩) = u x := by
  sorry

/-- `cor:terminal`.  The honest iterated fold of `U_f` is the constant `f(r_1 T^{w_1}, …)`. -/
theorem terminal {k m : ℕ} (T : Tower F k m) (r : Fin m → F) (w : Fin m → ℕ)
    (f : MvPolynomial (Fin m) F) :
    ∃ g : Polynomial F, ∀ i, i = m →
      g = MvPolynomial.eval₂ Polynomial.C
        (fun j : Fin m => Polynomial.C (r j) * Polynomial.X ^ (w j)) f := by
  sorry

end SymFRI
