import SymFRI.Unfolding

/-! # Interleaved codes (`proofs/L07-interleaved.tex`): `lem:ext`, `lem:ext-agree`. -/

set_option autoImplicit false
set_option linter.unusedVariables false
set_option linter.unusedSectionVars false

namespace SymFRI

open Polynomial MvPolynomial
open scoped BigOperators

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- `lem:ext`.  A basis of `E / F` identifies `t` interleaved words with one word over `E`. -/
theorem ext_linear {L : Finset F} {E : Type*} [Field E] [Algebra F E]
    (t : ℕ) (b : Module.Basis (Fin t) F E) :
    Function.Bijective fun U : Fin t → (L → F) => fun x : L => ∑ s : Fin t, b s * algebraMap F E (U s x) := by
  sorry

/-- `lem:ext-agree`.  An injective `F`-linear map applied pointwise preserves agreement sets, and
hence `Δ` and `agree_μ`. -/
theorem ext_agree {L : Finset F} {E : Type*} [Field E] [Algebra F E] (ψ : F →ₗ[F] E)
    (hψ : Function.Injective ψ) (u v : L → F) :
    ({x : L | u x = v x} : Set L) = {x : L | ψ (u x) = ψ (v x)} := by
  sorry

end SymFRI
