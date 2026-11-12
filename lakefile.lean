import Lake
open Lake DSL

/-! SymFRI Lean project: sources in lean/, dependencies pinned for reproducibility. -/

package SymFRI where
  leanOptions := #[⟨`autoImplicit, false⟩]

@[default_target]
lean_lib SymFRI where
  srcDir := "lean"

require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "0df444a360eaa60ab8c11dca51a86af692955474"

require checkdecls from git "https://github.com/PatrickMassot/checkdecls.git"
