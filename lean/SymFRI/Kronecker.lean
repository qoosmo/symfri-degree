import SymFRI.Tools

/-!
# The Kronecker map  (`proofs/L01-kronecker.tex`)

`lem:kron`, `lem:inj`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:kron` / `lem:kron`.  The Kronecker map `U q = q(Y, Y^k, …, Y^{k^{n-1}})`. -/
noncomputable def kron {n : ℕ} (k : ℕ) (q : MvPolynomial (Fin n) F) : Polynomial F :=
  MvPolynomial.eval₂ Polynomial.C (fun j : Fin n => Polynomial.X ^ (k ^ (j : ℕ))) q

/-- `lem:kron`.  The Kronecker map is a bijection from the box onto the polynomials of degree
`< k ^ n`; `x ^ α ↦ Y ^ n(α)` with `n(α) = Σ_l α_l k ^ l`. -/
theorem kron_bijOn {n k : ℕ} (hk : 2 ≤ k) :
    Set.BijOn (kron (F := F) k) {q : MvPolynomial (Fin n) F | InBox k q}
      {P : Polynomial F | P.natDegree < k ^ n} := by
  sorry

/-- `lem:inj`.  Evaluation of the Kronecker image on a domain of size `≥ k ^ (m - i)` is
injective on the box. -/
theorem eval_injective {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i ≤ m) :
    Function.Injective fun q : {q : MvPolynomial (Fin (m - i)) F // InBox k q} =>
      evalOn (T.L i) q.1 := by
  sorry

end SymFRI
