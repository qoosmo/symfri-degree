import SymFRI.Interleaved

/-! # The subcode lemma (`proofs/L08-subcode.tex`): `lem:subcode`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:subcode`.  If `Σ_j z^j v_j ∈ W` for more than `l` values of `z`, then every `v_j ∈ W`. -/
theorem subcode {L : Finset F} {l : ℕ} (S' : Finset F) (hS' : l < S'.card)
    (W : Submodule F (L → F)) (v : Fin (l + 1) → L → F)
    (hv : ∀ z ∈ S', (∑ j : Fin (l + 1), z ^ (j : ℕ) • v j) ∈ W) :
    ∀ j, v j ∈ W := by
  sorry

end SymFRI
