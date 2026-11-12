import Mathlib

/-!
# Shared definitions  (`proofs/defs.tex`)

This file transcribes `defs.tex`.  Statements are those of the `.tex`; the shape of each definition
is the one a Lean proof wants, and every departure is recorded in `blueprint/REPORT.md` (R4).

Conventions of the phase: `F` is a finite field, `L : Finset F`, codes are `Submodule F (L → F)`,
agreement is a `Finset` cardinality.
-/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `def:domains`.  A tower of domains `L 0, …, L m` with `|L i| = N / k ^ i` and `k`-to-one
fibres.  The `.tex` *derives* this from a coset `L₀` of the subgroup of order `N`; here the
derived properties are the fields, because they are exactly what the proofs use. -/
structure Tower (F : Type*) [Field F] [DecidableEq F] (k m : ℕ) : Type _ where
  /-- the number `N` of `def:domains` -/
  N : ℕ
  N_pos : 0 < N
  k_ge_two : 2 ≤ k
  pow_dvd : k ^ m ∣ N
  /-- `L i` is the domain `L_i`, for `0 ≤ i ≤ m` -/
  L : ℕ → Finset F
  card_L : ∀ i, i ≤ m → (L i).card = N / k ^ i
  /-- the fibre `fib(y) = {x ∈ L_{i-1} : x^k = y}` -/
  fib : (i : ℕ) → i < m → F → Finset F
  fib_subset : ∀ (i : ℕ) (hi : i < m) (y : F), fib i hi y ⊆ L i
  fib_card : ∀ (i : ℕ) (hi : i < m) (y : F), y ∈ L (i + 1) → (fib i hi y).card = k
  fib_cover : ∀ (i : ℕ) (hi : i < m), (L (i + 1)).biUnion (fun y => fib i hi y) = L i
  pow_mem : ∀ (i : ℕ) (hi : i < m) (x : F), x ∈ L i → x ^ k ∈ L (i + 1)

/-- `def:domains`, the construction: from `k ≥ 2`, `k^m ∣ N ∣ |F|-1` and a coset `L₀` of the
subgroup of order `N`, there is a tower with `T.N = N` and `T.L 0 = L₀`.  This shows that the
hypotheses of `Tower` are met, so no theorem of the file is vacuous.  (The coset is written as
`x ^ N = 1`; a general coset is that one multiplied by a fixed `g`, the same proof.) -/
theorem Tower.ofCoset (k m N : ℕ) (hk : 2 ≤ k) (hkm : k ^ m ∣ N)
    (hNF : N ∣ Fintype.card F - 1) (L0 : Finset F) (h0 : L0.Nonempty)
    (hcoset : ∀ x : F, x ∈ L0 ↔ x ^ N = 1) :
    ∃ T : Tower F k m, T.N = N ∧ T.L 0 = L0 := by
  sorry

/-- `def:poly`.  The box of individual degree `< k` in `n` variables. -/
def InBox {n : ℕ} (k : ℕ) (q : MvPolynomial (Fin n) F) : Prop := ∀ j, q.degreeOf j < k

/-- `def:wdeg`.  The weighted degree `deg_w q = max { <w, α> : q_α ≠ 0 }`. -/
noncomputable def wdeg {n : ℕ} (w : Fin n → ℕ) (q : MvPolynomial (Fin n) F) : ℕ :=
  q.support.sup fun a => ∑ j, w j * a j

/-- `def:kron`.  The Kronecker map, in the multivariate form: it is `U_f` evaluated at a point.
(`U^{(i)}_q` itself is `SymFRI.kron` in `Kronecker.lean`.) -/
noncomputable def evalAt {n : ℕ} (x : F) (q : MvPolynomial (Fin n) F) : F :=
  MvPolynomial.eval (fun _ => x) q

/-- `def:kron`, read as a word on a domain. -/
noncomputable def evalOn {n : ℕ} (L : Finset F) (q : MvPolynomial (Fin n) F) : L → F :=
  fun x => evalAt x.1 q

/-- `def:codes`.  `RS[F,L,d] = {P|_L : deg P < d}`, as the span of the `d` monomial evaluations.
For `d ≤ |L|` this is the `.tex` set, of dimension `d`. -/
def RS (L : Finset F) (d : ℕ) : Submodule F (L → F) :=
  Submodule.span F (Set.range fun i : Fin d => (fun x : L => x.1 ^ (i : ℕ)))

/-- The weight vector of the variables `x_{off+1}, …, x_{off+n}`, from a weight `w` on the
indices `1, …, m`.  Using a total weight makes the level shifts of `lm:stab` free of arithmetic. -/
def wvec (w : ℕ → ℕ) (off n : ℕ) : Fin n → ℕ := fun j => w (off + (j : ℕ))

/-- `def:codes`.  The degree code `C_{w,D}`: the `T`-free part of `Gc_0^{w,D}`, that is the
evaluations of the box with `deg_w f ≤ D`. -/
noncomputable def degreeCode {k m : ℕ} (T : Tower F k m) (w : ℕ → ℕ) (D : ℕ) :
    Submodule F (T.L 0 → F) :=
  Submodule.span F (Set.range fun q : {q : MvPolynomial (Fin m) F //
      InBox k q ∧ wdeg (wvec w 0 m) q ≤ D} => evalOn (T.L 0) q.1)

/-- `def:wdeg`.  The graded degree `a + <w, α>` of a monomial `T^a x^α`: the `T`-degree of its
coefficient plus its weighted `x`-degree.  The coefficients are `F[T]`, so the `T`-variable is not
a variable of the polynomial. -/
noncomputable def gdeg {n : ℕ} (w : Fin n → ℕ) (q : MvPolynomial (Fin n) (Polynomial F)) : ℕ :=
  q.support.sup fun a => (q.coeff a).natDegree + ∑ j, w j * a j

/-- The box with `T`-coefficients: individual degree `< k` in the `x`-variables. -/
def InBoxP {n : ℕ} (k : ℕ) (q : MvPolynomial (Fin n) (Polynomial F)) : Prop :=
  ∀ j, q.degreeOf j < k

/-- The Kronecker substitution with the symbolic variable: the `x`-variables go to `Y ^ (k ^ j)`
and the coefficients stay in `F[T]`. -/
noncomputable def kronP {n : ℕ} (k : ℕ) (q : MvPolynomial (Fin n) (Polynomial F)) :
    Polynomial (Polynomial F) :=
  MvPolynomial.eval₂ Polynomial.C
    (fun j : Fin n => Polynomial.X ^ (k ^ (j : ℕ))) q

/-- `def:codes`.  The graded code `Gc_i^{w,D}`: the evaluations on `L_i` of the Kronecker images
of the box with `gdeg ≤ D`. -/
noncomputable def gradedCode {k m : ℕ} (T : Tower F k m) (i : ℕ) (w : ℕ → ℕ) (D : ℕ) :
    Submodule F (T.L i → Polynomial F) :=
  Submodule.span F (Set.range fun q : {q : MvPolynomial (Fin (m - i)) (Polynomial F) //
      InBoxP k q ∧ gdeg (wvec w i (m - i)) q ≤ D} =>
    fun y : T.L i => (kronP k q.1).eval₂ (RingHom.id (Polynomial F)) (Polynomial.C y.1))

/-- `def:agree`.  A weight on `L`: values in `[0,1]` with a common denominator `M ≥ 1`.  This is
the one place where a weight is defined; the axioms and the theorems all take a `Weight`. -/
structure Weight (L : Finset F) where
  /-- the weight function `μ` -/
  mu : L → ℚ
  nonneg : ∀ x, 0 ≤ mu x
  le_one : ∀ x, mu x ≤ 1
  /-- the common denominator `M` -/
  M : ℕ
  M_pos : 1 ≤ M
  denom : ∀ x, ∃ z : ℤ, mu x * (M : ℚ) = z

/-- `def:agree`: the weight `μ ≡ 1` of the unweighted case. -/
def Weight.one (L : Finset F) : Weight L where
  mu := fun _ => 1
  nonneg := fun _ => by norm_num
  le_one := fun _ => by norm_num
  M := 1
  M_pos := le_rfl
  denom := fun _ => ⟨1, by norm_num⟩

/-- `def:agree`.  The weighted agreement `agree_μ(u,v)`: one definition, for every codomain (words
with values in `F`, and words with values in `F[T]`, which the graded codes carry). -/
noncomputable def agreeOf {L : Finset F} {α : Type*} [DecidableEq α] (w : Weight L)
    (u v : L → α) : ℚ :=
  (∑ x : L, if u x = v x then w.mu x else 0) / (L.card : ℚ)

/-- `def:agree`.  Without a subscript, `μ ≡ 1`: `agree(u,v) = 1 - Δ(u,v)`. -/
noncomputable def agree {L : Finset F} (u v : L → F) : ℚ := agreeOf (Weight.one L) u v

/-- `def:agree`.  The distance `Δ = 1 - agree`. -/
noncomputable def dist {L : Finset F} (u v : L → F) : ℚ := 1 - agree u v

/-- `def:agree`.  Joint agreement of `l+1` words with `l+1` words, weighted: the quantity
`μ({x : u_j(x) = v_j(x) for all j})` of `hyp:ca`. -/
noncomputable def jointAgree {L : Finset F} {l : ℕ} (w : Weight L)
    (u v : Fin (l + 1) → L → F) : ℚ :=
  (∑ x : L, if ∀ j, u j x = v j x then w.mu x else 0) / (L.card : ℚ)

/-- The curve `u_β = Σ_j β^j u_j` of `hyp:ca`. -/
noncomputable def curve {L : Finset F} {l : ℕ} (z : F) (u : Fin (l + 1) → L → F) : L → F :=
  fun x => ∑ j : Fin (l + 1), z ^ (j : ℕ) * u j x

/-- `def:agree`.  The agreement of a word with a set of words, as the **maximum** over the set,
taken in `ℝ`: `agree_μ(u,C) = max {agree_μ(u,v) : v ∈ C}`.  The maximum is attained because the
value depends only on the agreement set `{x | u x = v x} ⊆ L`, which is finite (`agreeCode_attained`). -/
noncomputable def agreeCode {L : Finset F} {α : Type*} [DecidableEq α] (w : Weight L)
    (u : L → α) (C : Set (L → α)) : ℝ :=
  sSup ((fun v => (agreeOf w u v : ℝ)) '' C)

/-- `def:agree`.  `agree_μ(u,C) ≤ a`.  Kept only to state the equivalence with `agreeCode`. -/
def AgreeLe {L : Finset F} (w : Weight L) (u : L → F) (C : Set (L → F)) (a : ℝ) : Prop :=
  ∀ v ∈ C, (agreeOf w u v : ℝ) ≤ a

/-- `def:agree`.  `a ≤ agree_μ(u,C)`.  Kept only to state the equivalence with `agreeCode`. -/
def AgreeGe {L : Finset F} (w : Weight L) (u : L → F) (C : Set (L → F)) (a : ℝ) : Prop :=
  ∃ v ∈ C, a ≤ (agreeOf w u v : ℝ)

/-- `agreeCode` is the least upper bound: `agree_μ(u,C) ≤ a ↔ ∀ v ∈ C, agree_μ(u,v) ≤ a`. -/
theorem agreeLe_iff {L : Finset F} (w : Weight L) (u : L → F) {C : Set (L → F)}
    (hC : C.Nonempty) (a : ℝ) : AgreeLe w u C a ↔ agreeCode w u C ≤ a := by
  sorry

/-- `agreeCode` is attained: `a ≤ agree_μ(u,C) ↔ ∃ v ∈ C, a ≤ agree_μ(u,v)`. -/
theorem agreeGe_iff {L : Finset F} (w : Weight L) (u : L → F) {C : Set (L → F)}
    (hC : C.Nonempty) (a : ℝ) : AgreeGe w u C a ↔ a ≤ agreeCode w u C := by
  sorry

/-- The maximum is attained at a word of the set. -/
theorem agreeCode_attained {L : Finset F} (w : Weight L) (u : L → F) {C : Set (L → F)}
    (hC : C.Nonempty) : ∃ v ∈ C, agreeCode w u C = (agreeOf w u v : ℝ) := by
  sorry

/-- The caps `d_i = min (D, (k-1) Σ_{l≤i} w_l)` of `defs.tex`, paragraph "The caps". -/
def caps (k : ℕ) (w : ℕ → ℕ) (D : ℕ) (i : ℕ) : ℕ :=
  min D ((k - 1) * ∑ l ∈ Finset.range i, w l)

/-- `def:fold`.  The `j`-th component `u_j(y) = (1/k) Σ_{x ∈ fib y} x^{-j} u(x)` of a word on
`L_i`, as a word on `L_{i+1}`. -/
noncomputable def components {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m)
    (u : T.L i → F) (j : ℕ) (y : T.L (i + 1)) : F :=
  (k : F)⁻¹ * ∑ x : {x // x ∈ T.fib i hi y.1},
    (x.1 : F) ^ (-(j : ℤ)) * u ⟨x.1, T.fib_subset i hi y.1 x.2⟩

/-- `def:fold`.  The fold `Fold_c u = Σ_{j<k} c^j u_j`. -/
noncomputable def fold {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (c : F)
    (u : T.L i → F) (y : T.L (i + 1)) : F :=
  ∑ j ∈ Finset.range k, c ^ j * components T i hi u j y

/-- `def:fold`, for words with values in `F[T]`, which is what the graded codes carry. -/
noncomputable def foldP {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m) (c : Polynomial F)
    (u : T.L i → Polynomial F) (y : T.L (i + 1)) : Polynomial F :=
  ∑ j ∈ Finset.range k, c ^ j *
    (Polynomial.C ((k : F)⁻¹) * ∑ x : {x // x ∈ T.fib i hi y.1},
      Polynomial.C ((x.1 : F) ^ (-(j : ℤ))) * u ⟨x.1, T.fib_subset i hi y.1 x.2⟩)

/-- `def:fold` for words with values in `F[T]`: the components. -/
noncomputable def componentsP {k m : ℕ} (T : Tower F k m) (i : ℕ) (hi : i < m)
    (u : T.L i → Polynomial F) (j : ℕ) (y : T.L (i + 1)) : Polynomial F :=
  Polynomial.C ((k : F)⁻¹) * ∑ x : {x // x ∈ T.fib i hi y.1},
    Polynomial.C ((x.1 : F) ^ (-(j : ℤ))) * u ⟨x.1, T.fib_subset i hi y.1 x.2⟩

end SymFRI
