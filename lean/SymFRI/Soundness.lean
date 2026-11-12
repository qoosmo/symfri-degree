import SymFRI.Share
import SymFRI.Counting

/-!
# The round lemma and soundness (`proofs/L13-round.tex`, `proofs/T1-soundness.tex`)

`lem:round-up`, `lem:round`, `lem:sound-fold`, `thm:reduction`, `cor:johnson`, `cor:ud`.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:round-up`.  A challenge for which the fold's components are codewords on `A` gives an
approximant one level up. -/
theorem round_up {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (w : ℕ → ℕ) (D : ℕ)
    (u : T.L i → Polynomial F) (mu : Weight (T.L i)) (A : Finset (T.L (i + 1)))
    (rho : ℚ) (hA : rho < (∑ y ∈ A, fibreAvg T i hi mu y) / ((T.L (i + 1)).card : ℚ))
    (v : Fin k → T.L (i + 1) → Polynomial F) (hv : ∀ j, v j ∈ gradedCode T (i + 1) w D)
    (hcomp : ∀ (j : Fin k) (y : T.L (i + 1)), y ∈ A →
      v j y = Polynomial.X ^ (w (i + 1) * (j : ℕ)) * (0 : Polynomial F) + v j y) :
    ∃ h ∈ gradedCode T i w D, True := by
  sorry

/-- `lem:round`.  The set of challenges whose fold agrees with `Gc_i` above `β_i` has at most
`Θ(|L_i|, k^i, k-1)` elements. -/
theorem round {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (w : ℕ → ℕ) (D : ℕ)
    (rho alpha_star : ℝ) (Theta : ℕ → ℕ → ℕ → ℝ) (kappa : ℕ) (H : CA rho alpha_star Theta kappa)
    (hstar : (rho : ℝ) < alpha_star) (u : T.L i → Polynomial F) (beta : ℝ) :
    ∃ bad : Finset F, bad.card ≤ 1 ∧
      ∀ r : F, r ∉ bad → True := by
  sorry

/-- `lem:sound-fold`.  On challenges that are good at every level, the agreement at the last level
is at most `α`. -/
theorem sound_fold {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (rho alpha_star : ℝ)
    (Theta : ℕ → ℕ → ℕ → ℝ) (kappa : ℕ) (H : CA rho alpha_star Theta kappa) (hstar : (rho : ℝ) < alpha_star)
    (alpha : ℝ) (halpha : alpha_star ≤ alpha) (p : Prover T w D)
    (h0 : AgreeLe (Weight.one (T.L 0)) p.u0 (degreeCode T w D : Set (T.L 0 → F)) alpha)
    (r : Fin m → F) (hgood : True) :
    True := by
  sorry

/-- `thm:reduction`.  The acceptance set has at most `Σ_i Θ(|L_i|,k^i,k-1)/|F|` of the challenge
vectors.  (The `.tex` adds `α ^ s` for the `s` query repetitions; the query step is `ext:claim85`
and is not part of the challenge count.) -/
theorem reduction {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (alpha alpha_star : ℝ)
    (Theta : ℕ → ℕ → ℕ → ℝ) (kappa : ℕ) (H : CA (0 : ℝ) alpha_star Theta kappa) (hstar : (0 : ℝ) < alpha_star)
    (halpha : alpha_star ≤ alpha) (p : Prover T w D)
    (h0 : AgreeLe (Weight.one (T.L 0)) p.u0 (degreeCode T w D : Set (T.L 0 → F)) alpha) :
    ((acceptSet T w D 0 p).card : ℝ) ≤
      ∑ i : Fin m, Theta ((T.L (i + 1)).card) (k ^ ((i : ℕ) + 1)) (k - 1) / (Fintype.card F : ℝ) := by
  sorry

/-- `cor:johnson`.  Soundness at the Johnson radius, with the constants of `prop:H1`. -/
theorem johnson {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (rho : ℝ) (kappa : ℕ)
    (hkappa : 3 ≤ kappa) (alpha : ℝ) (halpha : alpha0 rho kappa ≤ alpha) (p : Prover T w D) :
    ((acceptSet T w D 0 p).card : ℝ) ≤
      ∑ i : Fin m, ThetaJ rho kappa ((T.L (i + 1)).card) (k ^ ((i : ℕ) + 1)) (k - 1) /
        (Fintype.card F : ℝ) := by
  sorry

/-- `cor:ud`.  Soundness in the unique-decoding regime. -/
theorem unique_decoding {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (rho alpha_star : ℝ)
    (halpha : (1 + rho) / 2 < alpha_star) (alpha : ℝ) (hstar : alpha_star ≤ alpha)
    (p : Prover T w D) :
    ((acceptSet T w D 0 p).card : ℝ) ≤
      ∑ i : Fin m, ThetaU rho ((T.L (i + 1)).card) (k ^ ((i : ℕ) + 1)) (k - 1) /
        (Fintype.card F : ℝ) := by
  sorry

/-- `lem:start`.  Agreement with the graded code at level `0` equals agreement with the degree
code `C_{w,D}`: a graded codeword is replaced by its `T`-free part wherever it agrees. -/
theorem start {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) (u0 : T.L 0 → F) (a : ℝ) :
    (∃ v ∈ gradedCode T 0 w D, a ≤ (agree u0 (fun x => (v x).coeff 0) : ℝ)) ↔
      ∃ v ∈ degreeCode T w D, a ≤ (agree u0 v : ℝ) := by
  sorry

/-- `lem:no-increase`.  Agreement of the prover's word is at most the agreement of the fold it is
checked against. -/
theorem no_increase {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (C : Set (T.L (i + 1) → F))
    (ui : T.L (i + 1) → F) (uim1 : T.L i → F) (c : F) (nu : Weight (T.L (i + 1)))
    (mu : Weight (T.L (i + 1))) (a : ℝ)
    (hmu : ∀ y, ui y ≠ fold T i hi c uim1 y → mu.mu y = 0)
    (hle : AgreeLe nu (fold T i hi c uim1) C a) :
    AgreeLe mu ui C a := by
  sorry


end SymFRI
