import SymFRI.Soundness
import SymFRI.Hypothesis

/-!
# Axiom check (Phase 1c, A6)

`#print axioms` for the statements of the phase: only the intended axioms, `sorryAx` and Lean's
three standard axioms (`propext`, `Classical.choice`, `Quot.sound`) may appear.

Build with `lake build SymFRI.AxiomCheck`, or elaborate with
`lake env lean lean/SymFRI/AxiomCheck.lean`, and read the output below.
-/

#print axioms SymFRI.H_johnson
#print axioms SymFRI.H_unique
#print axioms SymFRI.reduction
#print axioms SymFRI.johnson
#print axioms SymFRI.unique_decoding
