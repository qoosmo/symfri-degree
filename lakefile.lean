import Lake
open Lake DSL

/-!
# The SymFRI Lean project

The sources are in `lean/`; this root lakefile makes them a Lake package, because `leanblueprint`
looks for the project at the repository root.

Mathlib is pinned to the revision of the local prebuilt Mathlib, which is the release tag
`v4.33.1` (commit `0df444a360eaa60ab8c11dca51a86af692955474`; the local tree was identified by its
`lean-toolchain` and by the eight dependency revisions of its `lake-manifest.json`, all equal to
those of that tag).

Building Mathlib from source is not possible on the machine where this phase was prepared, so that
machine uses the prebuilt copy at `/opt/mathlib` — the same tag — when
`SYMFRI_LOCAL_MATHLIB=1` is set:

    SYMFRI_LOCAL_MATHLIB=1 lake build
-/

package SymFRI where
  leanOptions := #[⟨`autoImplicit, false⟩]

open System in
def useLocalMathlib : BaseIO Bool := do
  return (← IO.getEnv "SYMFRI_LOCAL_MATHLIB").isSome

/- The two requirements are exclusive; Lake takes the first branch that is enabled. -/
@[default_target]
lean_lib SymFRI where
  srcDir := "lean"

open Lean Elab Command in
elab "if_local_mathlib" "=>" a:command "else" b:command : command => do
  if (← IO.getEnv "SYMFRI_LOCAL_MATHLIB").isSome then elabCommand a else elabCommand b

if_local_mathlib =>
  require mathlib from "/opt/mathlib"
else
  require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "0df444a360eaa60ab8c11dca51a86af692955474"

/-- leanblueprint's declaration check -/
require checkdecls from git "https://github.com/PatrickMassot/checkdecls.git"
