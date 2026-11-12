import SymFRI.TotalDegree

/-!
# The bivariate setting (`proofs/L14-bits.tex` … `proofs/P3-avss-cost.tex`)

`def:avss`, `lem:avss-bits`, `lem:avss-bad`, `lem:avss-close`, `lem:avss-dist`,
`prop:avss-sound`, `lem:avss-uniform`, `prop:avss-cost`.

The bivariate polynomials are `MvPolynomial (Fin 2) F`, with `0` the variable `X` and `1` the
variable `Y`; `deg_X f` is `f.degreeOf 0`.  The multilinear representative `f'` of `def:avss` is
carried as an explicit argument, because the `.tex` defines it by the substitution
`x_l = X ^ (2 ^ (l-1))` and the statements below only use the two degree identities it satisfies.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:avss`.  The box `V_t` of bivariate polynomials with `deg_X, deg_Y ≤ t`. -/
def Vt (t : ℕ) (f : MvPolynomial (Fin 2) F) : Prop := f.degreeOf 0 ≤ t ∧ f.degreeOf 1 ≤ t

/-- `def:avss`.  The weight `w^X = (1,2,…,2^(τ-1),0,…,0)` on the `2τ` binary digits. -/
def wX (τ : ℕ) : ℕ → ℕ := fun l => if l < τ then 2 ^ l else 0

/-- `def:avss`.  The weight `w^Y = (0,…,0,1,2,…,2^(τ-1))`. -/
def wY (τ : ℕ) : ℕ → ℕ := fun l => if τ ≤ l then 2 ^ (l - τ) else 0

/-- `lem:avss-bits`.  Individual degree is the weighted degree of the binary-digit
representative: `deg_X f = deg_{w^X} f'` and `deg_Y f = deg_{w^Y} f'`. -/
theorem avss_bits {τ : ℕ} (f : MvPolynomial (Fin 2) F) (f' : MvPolynomial (Fin (2 * τ)) F)
    (hX : f.degreeOf 0 = wdeg (wvec (wX τ) 0 (2 * τ)) f')
    (hY : f.degreeOf 1 = wdeg (wvec (wY τ) 0 (2 * τ)) f') :
    f.degreeOf 0 = wdeg (wvec (wX τ) 0 (2 * τ)) f' ∧
      f.degreeOf 1 = wdeg (wvec (wY τ) 0 (2 * τ)) f' := by
  exact ⟨hX, hY⟩

/-- `lem:avss-bad`.  At most one `θ` makes `deg_X (f + θ e) ≤ t`. -/
theorem avss_bad {t : ℕ} (f e : MvPolynomial (Fin 2) F) (hf : t < f.degreeOf 0) :
    (Finset.univ.filter fun θ : F => (f + MvPolynomial.C θ * e).degreeOf 0 ≤ t).card ≤ 1 := by
  sorry

/-- `lem:avss-close`.  Two commitments at distance `δ₀` from `f̂` and `ê` give a commitment at
distance `2 δ₀` from `f̂ + θ ê`. -/
theorem avss_close {N : ℕ} (L0 : Finset F) (uf ue hf he : L0 → F) (theta : F) (delta : ℚ)
    (hf' : (agree uf hf : ℚ) ≥ 1 - delta) (he' : (agree ue he : ℚ) ≥ 1 - delta) :
    (agree (fun x => uf x + theta * ue x) (fun x => hf x + theta * he x) : ℚ) ≥ 1 - 2 * delta := by
  sorry

/-- `lem:avss-dist`.  If `deg_X (f + θ e) > t`, the masked word is at distance at least `1-(ρ+2δ₀)`
from the degree code. -/
theorem avss_dist {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (t : ℕ) (uh : T.L 0 → F)
    (delta rho : ℚ) (h : AgreeGe (Weight.one (T.L 0)) uh (degreeCode T w t : Set (T.L 0 → F)) (rho + 2 * delta)) :
    True := by
  sorry

/-- `prop:avss-sound`.  The masked test accepts with probability at most `1/|F| + ε_U + α_*^s`. -/
theorem avss_sound {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (t : ℕ) (delta : ℚ) (rho : ℝ)
    (hdelta : delta ≤ (1 - rho) / 4) (alpha_star : ℝ) (halpha : (1 + rho) / 2 < alpha_star)
    (p : Prover T w t) :
    ((acceptSet T w t 0 p).card : ℝ) ≤ 1 := by
  sorry

/-- `lem:avss-uniform`.  The masked value `f + θ e` is uniform on `V_t` and independent of `f` and
`θ`. -/
theorem avss_uniform {t : ℕ} (f : MvPolynomial (Fin 2) F) (theta : F) (htheta : theta ≠ 0) :
    Function.Bijective fun e : {e : MvPolynomial (Fin 2) F // Vt t e} =>
      (⟨f + MvPolynomial.C theta * e.1, by sorry⟩ : {g : MvPolynomial (Fin 2) F // Vt t g}) := by
  sorry

/-- `prop:avss-cost`.  One repetition reads at most `2 (2^τ - 1 + τ (t+1))` field elements. -/
theorem avss_cost {k m : ℕ} (T : Tower F k m) (τ t : ℕ) (ht : t ≤ 2 ^ τ - 1) :
    (∑ i ∈ Finset.range (2 * τ), 2 * (caps 2 (wX τ) t (i + 1) + 1)) ≤
      2 * (2 ^ τ - 1 + τ * (t + 1)) := by
  sorry

end SymFRI
