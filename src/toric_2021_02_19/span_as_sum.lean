import tactic
import linear_algebra.finsupp
import algebra.ring.basic
import ring_theory.subring
import algebra.algebra.basic

open function

variables (R : Type*)

section Rnnoneg

variables [ordered_semiring R]

/--  The subtype of non-negative elements of `R`. -/
def pR : subsemiring R :=
{ carrier := {r : R | 0 ≤ r},
  one_mem' := by simp only [set.mem_set_of_eq, zero_le_one],
  mul_mem' := λ x y (x0 : 0 ≤ x) (y0 : 0 ≤ y), mul_nonneg x0 y0,
  zero_mem' := rfl.le,
  add_mem' := λ x y (x0 : 0 ≤ x) (y0 : 0 ≤ y), add_nonneg x0 y0 }

variable {R}

@[simp] lemma mem_pR_nonneg (y : (pR R)) : 0 ≤ y := y.2

/--  The function `f : N → Z` is injective and its image only contains non-negative elements.
These properties are useful for `pointed_of_is_basis_is_inj`, in order to avoid having getting
entangled into statements such as "the subtype of the non-negative terms in ℤ is the type of ℕ". -/
structure is_inj_nonneg {N Z : Sort*} [has_zero Z] [has_le Z] (f : N → Z) : Prop :=
(inj : injective f)
(map_nonneg : ∀ n : N, 0 ≤ f n)

namespace is_inj_nonneg

/--  The inclusion of the non-negative elements of an `ordered_comm_semiring` is injective and
consists of non-negative elements. -/
lemma pR_ocr (Z : Type*) [ordered_comm_semiring Z] :
  is_inj_nonneg (algebra_map (pR Z) Z) := --tidy works
⟨subtype.coe_injective, λ n, n.2⟩

/--  The inclusion of the non-negative integers into the integers is injective and
consists of non-negative elements. -/
lemma pR_int_int : is_inj_nonneg (algebra_map (pR ℤ) ℤ) :=
by convert pR_ocr ℤ

/--  The inclusion of the natural numbers into a non-trivial `ordered_semiring` is injective and
consists of non-negative elements. -/
lemma nat (Z : Sort*) [ordered_semiring Z] [nontrivial Z] :
  is_inj_nonneg (nat.cast_ring_hom Z) :=
⟨@nat.cast_injective Z _ _ ordered_semiring.to_char_zero, λ n, nat.cast_nonneg n⟩

end is_inj_nonneg

/--  The ring homomorphism `f : N → Z` is injective and its image only contains
non-negative elements. -/
structure is_inj_nonneg_hom {N Z : Sort*} [semiring N] [semiring Z] [has_le Z] (f : N →+* Z) : Prop :=
(inj : injective f)
(map_nonneg : ∀ n : N, 0 ≤ f n)

namespace is_inj_nonneg_hom

lemma pR_ocr (Z : Type*) [ordered_comm_semiring Z] :
  is_inj_nonneg (algebra_map (pR Z) Z) := --tidy works
⟨subtype.coe_injective, λ n, n.2⟩

lemma pR_int_int : is_inj_nonneg (algebra_map (pR ℤ) ℤ) :=
by convert pR_ocr ℤ

lemma nat (Z : Sort*) [ordered_semiring Z] [nontrivial Z] :
  is_inj_nonneg (nat.cast_ring_hom Z) :=
⟨@nat.cast_injective Z _ _ ordered_semiring.to_char_zero, λ n, nat.cast_nonneg n⟩

--lemma pR_Z_eq_N : pR ℤ ≃+* ℕ := sorry

end is_inj_nonneg_hom

variables {α β : Type*}

open function


end Rnnoneg

variables [ordered_comm_ring R]

instance pos_algebra : algebra (pR R) R := algebra.of_subsemiring (pR R)
