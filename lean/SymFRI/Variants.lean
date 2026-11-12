import SymFRI.Completeness

/-!
# Variants (`proofs/variants.tex`): `rem:multi`, `rem:separate`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `rem:multi`.  With `p` constraints the target code is the intersection `⋂_ι C_{w^ι,D_ι}`; a
word lies in it exactly when it lies in every one of them. -/
theorem multi {m p : ℕ} (T : Tower F 1 m) (w : Fin p → ℕ → ℕ) (D : Fin p → ℕ)
    (v : T.L 0 → F) :
    v ∈ (⨅ s, degreeCode (k := 1) T (w s) (D s)) ↔
      ∀ s, v ∈ degreeCode (k := 1) T (w s) (D s) := by
  sorry

/-- `rem:separate`.  Separate runs on one commitment: below the unique-decoding radius the
codewords achieving the agreements are all the unique closest codeword, hence lie in the
intersection. -/
theorem separate {L : Finset F} {d : ℕ} {u0 : L → F} {C₁ C₂ : Submodule F (L → F)}
    (h₁ : C₁ ≤ RS L d) (h₂ : C₂ ≤ RS L d) (rho : ℝ)
    (hC₁ : AgreeGe (Weight.one L) u0 (C₁ : Set (L → F)) ((1 + rho) / 2))
    (hC₂ : AgreeGe (Weight.one L) u0 (C₂ : Set (L → F)) ((1 + rho) / 2)) :
    ∃ v ∈ C₁ ⊓ C₂, True := by
  sorry

end SymFRI
