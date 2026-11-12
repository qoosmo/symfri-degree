import SymFRI.Subcode

/-!
# The protocol  (`proofs/protocol.tex`, `proofs/external-acceptance.tex`)

`def:protocol` (messages, the `s` query repetitions, acceptance), `def:weights` (the query weights
`ν^(i)`, `μ^(i)`).

Following the `.tex`: the verifier draws challenges `r_1, …, r_m` and, for each of the `s`
repetitions, a seed `ξ_0 ∈ L_0`; it sets `ξ_i := ξ_{i-1}^k` and checks
`u_i(ξ_i) = Fold_{c_i}(u_{i-1})(ξ_i)` at the single point `ξ_i` of level `i`, reading `u_{i-1}` on
the fibre `fib(ξ_i)`.  Acceptance is therefore a predicate of `(r, ξ)` where `ξ` is the `s`-tuple of
seeds, and the probability of soundness is a count over that product space.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:protocol`.  A prover: its `i`-th message as a function of the challenge prefix
`(r_1, …, r_i)`. -/
structure Prover {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) where
  /-- the message `u i` on `L i` -/
  u : (i : ℕ) → (Fin i → F) → T.L i → F

/-- The query path of `def:protocol`: `ξ_i := ξ_{i-1} ^ k`, starting from `ξ_0`. -/
noncomputable def Tower.path {k m : ℕ} (T : Tower F k m) :
    (i : ℕ) → i ≤ m → T.L 0 → T.L i
  | 0, _, x => x
  | i + 1, hi, x =>
      ⟨(T.path i (by omega) x).1 ^ k,
        T.pow_mem i (by omega) _ (T.path i (by omega) x).2⟩

/-- `def:protocol`.  One repetition: the fold checks at the query points `ξ_1, …, ξ_m` of the path
determined by the seed `ξ_0`. -/
def ChecksAt {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (p : Prover T w D)
    (r : Fin m → F) (ξ : T.L 0) : Prop :=
  ∀ (i : ℕ) (hi : i < m),
    p.u (i + 1) (fun j => r ⟨j, by omega⟩) (T.path (i + 1) (by omega) ξ) =
      fold T i hi (r ⟨i, hi⟩) (p.u i (fun j => r ⟨j, by omega⟩))
        (T.path (i + 1) (by omega) ξ)

/-- `def:protocol`.  The verifier accepts for the challenges `r` and the `s` seeds `ξ`: every
repetition passes every fold check. -/
def Accepts {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (s : ℕ) (p : Prover T w D)
    (r : Fin m → F) (ξ : Fin s → T.L 0) : Prop :=
  ∀ a : Fin s, ChecksAt T w D p r (ξ a)

/-- `def:protocol`.  The acceptance set: the challenge vectors and query seeds on which the verifier
accepts.  The soundness count of `thm:reduction` is over this finite set. -/
noncomputable def acceptSet {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (s : ℕ)
    (p : Prover T w D) : Finset ((Fin m → F) × (Fin s → T.L 0)) := by
  classical
  exact Finset.univ.filter fun x => Accepts T w D s p x.1 x.2

/-- `def:weights`.  `ν^(i)`: the fibre average of the weight `μ^(i-1)` on `L_i`. -/
noncomputable def nu {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (mu : Weight (T.L i)) :
    Weight (T.L (i + 1)) where
  mu := fun y =>
    (∑ x : {x // x ∈ T.fib i hi y.1}, mu.mu ⟨x.1, T.fib_subset i hi y.1 x.2⟩) / (k : ℚ)
  nonneg := by sorry
  le_one := by sorry
  M := k * mu.M
  M_pos := by sorry
  denom := by sorry

/-- `def:weights`.  `μ^(i)`: `ν^(i)` where the fold check holds at the point, and `0` elsewhere. -/
noncomputable def muStep {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (s : ℕ)
    (p : Prover T w D) (r : Fin m → F) (i : ℕ) (hi : i < m) (mu : Weight (T.L i)) :
    Weight (T.L (i + 1)) := by
  classical
  exact
  { mu := fun y =>
      if p.u (i + 1) (fun j => r ⟨j, by omega⟩) y =
          fold T i hi (r ⟨i, hi⟩) (p.u i (fun j => r ⟨j, by omega⟩)) y
        then (nu T i hi mu).mu y else 0
    nonneg := by sorry
    le_one := by sorry
    M := k * mu.M
    M_pos := by sorry
    denom := by sorry }

/-- `def:weights`.  The chain of the weights `μ^(0), …, μ^(i)` of a transcript. -/
noncomputable def muChain {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (s : ℕ)
    (p : Prover T w D) (r : Fin m → F) : (i : ℕ) → i ≤ m → Weight (T.L i) :=
  fun i => Nat.rec (motive := fun i => i ≤ m → Weight (T.L i))
    (fun _ => Weight.one (T.L 0))
    (fun i ih hi => muStep T w D s p r i (by omega) (ih (by omega))) i

end SymFRI
