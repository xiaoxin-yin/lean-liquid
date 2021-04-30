/-
Copyright (c) 2021 Kevin Buzzard. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kevin Buzzard, Eric Wieser
-/
import algebra.direct_sum
import group_theory.subgroup
import algebra.direct_sum_graded
import group_theory.submonoid.operations

/-!

# Grading of a semiring by an add_monoid

A grading of a semiring `R` by an add_monoid `A` is a decomposition R ≃ ⨁ Rₐ as an internal
direct sum of subgroups indexed by `A`, satisfying `1 ∈ R₀` and `RₘRₙ⊆R_{m+n}`

-/
-- MOVE
open_locale direct_sum

-- should be in algebra.direct_sum
lemma direct_sum.to_add_monoid_apply {ι : Type*} [decidable_eq ι]
  {β : ι → Type*} [Π (i : ι), add_comm_monoid (β i)]
  [ Π (i : ι) (x : β i), decidable (x ≠ 0)]
  {γ : Type*} [add_comm_monoid γ]
  (f : Π (i : ι), β i →+ γ) (b : ⨁ i, β i):
  direct_sum.to_add_monoid f b = dfinsupp.sum b (λ i, f i) :=
dfinsupp.sum_add_hom_apply _ _

-- should be in dfinsupp
namespace dfinsupp

variables (ι : Type*) (β : ι → Type*) [decidable_eq ι] [Π (j : ι), has_zero (β j)]
  (i : ι) (f : Π₀ i, β i)

lemma eq_single_iff : (∀ ⦃j : ι⦄, j ≠ i → f j = 0) ↔ dfinsupp.single i (f i) = f :=
⟨λ h, dfinsupp.ext $ λ j, begin
  by_cases hj : j = i,
  { subst hj,
    apply single_eq_same },
  { rw h hj,
    exact single_eq_of_ne (ne.symm hj) },
end,
begin
  rintro hf j h,
  rw ← hf,
  exact single_eq_of_ne h.symm,
end⟩

/-- A version of `dfinsupp.sum_single_index` which takes monoids homomorphisms. Useful for
  sometimes avoiding `@sum_single_index _ _ _ _ …`. -/
lemma add_monoid_hom_sum_single_index {ι : Type*} {β : ι → Type*} [decidable_eq ι]
  [_inst_1 : Π (i : ι), add_monoid (β i)]
  [_inst_2 : Π (i : ι) (x : β i), decidable (x ≠ 0)]
  {γ : Type*} [add_comm_monoid γ] {i : ι} {b : β i} {h : Π (i : ι), β i →+ γ} :
  (dfinsupp.single i b).sum (λ i, h i) = h i b :=
sum_single_index (h i).map_zero

end dfinsupp

section unused_in_this_file

namespace direct_sum

variables {ι : Type*}

open_locale direct_sum

variables {M : Type*} [decidable_eq ι] [add_comm_monoid M] (A : ι → Type*)
  [∀ i, add_comm_monoid (A i)]

def projection (j : ι) : (⨁ i, A i) →+ A j :=
{ to_fun := λ f, f j,
  map_zero' := rfl,
  map_add' := λ x y, x.add_apply y j }

lemma projection_of_same (j : ι) (aj : A j) : projection A j (of (λ i, A i) j aj) = aj :=
@dfinsupp.single_eq_same _ _ _ _ j _

lemma projection_of_ne {i j : ι} (h : i ≠ j) (ai : A i) :
  projection A j (of (λ i, A i) i ai) = 0 :=
dfinsupp.single_eq_of_ne h

end direct_sum

end unused_in_this_file

open_locale direct_sum
open function

namespace direct_sum

/-!
### Collections of `add_submonoids`
-/
section add_submonoid

/-!
#### `add_submonoid`s over an `add_comm_monoid`
-/
section add_comm_monoid

variables {ι M : Type*} [decidable_eq ι] [add_comm_monoid M] (Mᵢ : ι → add_submonoid M)

/-- The canonical map from a direct sum of `add_submonoid`s to their carrier type-/
abbreviation to_add_monoid_carrier : (⨁ i, Mᵢ i) →+ M :=
(to_add_monoid $ λ i, (Mᵢ i).subtype)

/-- A class to indicate that the collection of submonoids `Mᵢ` make up an internal direct
sum. -/
class has_add_submonoid_decomposition :=
(components : M → ⨁ i, Mᵢ i)
(left_inv : left_inverse (to_add_monoid_carrier Mᵢ) components)
(right_inv : right_inverse (to_add_monoid_carrier Mᵢ) components)

/- The decomposition provided by a `has_add_submonoid_decomposition` as an `add_equiv`. -/
def add_submonoid_decomposition [has_add_submonoid_decomposition Mᵢ] : M ≃+ ⨁ i, Mᵢ i :=
add_equiv.symm {
  inv_fun := (direct_sum.has_add_submonoid_decomposition.components : M → ⨁ i, Mᵢ i),
  left_inv := has_add_submonoid_decomposition.right_inv,
  right_inv := has_add_submonoid_decomposition.left_inv,
  ..(to_add_monoid_carrier Mᵢ) }

/-- By definition a `add_submonoid_decomposition` makes up an internal direct sum. -/
lemma add_submonoid_decomposition.is_internal [has_add_submonoid_decomposition Mᵢ] :
  add_submonoid_is_internal Mᵢ :=
(add_submonoid_decomposition Mᵢ).symm.bijective

/-- Noncomputably construct a decomposition from a proof the direct sum is an internal direct
sum. -/
noncomputable def add_submonoid_is_internal.has_decomposition (h : add_submonoid_is_internal Mᵢ) :
  has_add_submonoid_decomposition Mᵢ :=
{ components := (equiv.of_bijective _ h).symm,
  ..(equiv.of_bijective _ h).symm}

end add_comm_monoid

/-!
#### `add_submonoid`s over a `semiring`
-/
section semiring

variables {A R : Type*} [decidable_eq A] [add_monoid A] [semiring R] (Mᵢ : A → add_submonoid R)

/-- A class to indicate that a collection of `add_submonoid`s meet the requirements of
`direct_sum.gmonoid`. -/
class add_submonoid.is_gmonoid : Prop :=
(grading_one : (1 : R) ∈ Mᵢ 0)
(grading_mul : ∀ {m n : A} {r s : R},
  r ∈ Mᵢ m → s ∈ Mᵢ n → r * s ∈ Mᵢ (m + n))

/-- TODO: perhaps `gmonoid.of_add_submonoids` should be merged with this. -/
instance add_submonoid.is_gmonoid.gmonoid [add_submonoid.is_gmonoid Mᵢ] : gmonoid (λ i, Mᵢ i) :=
gmonoid.of_add_submonoids _ add_submonoid.is_gmonoid.grading_one $
  λ i j ⟨a, ha⟩ ⟨b, hb⟩, add_submonoid.is_gmonoid.grading_mul ha hb

/-- A decomposition of submonoids of a ring preserves multiplication. -/
lemma to_add_monoid_carrier_mul [has_add_submonoid_decomposition Mᵢ] [add_submonoid.is_gmonoid Mᵢ]
  (x y : ⨁ i, Mᵢ i) :
  to_add_monoid_carrier Mᵢ (x * y) =
    to_add_monoid_carrier Mᵢ x * to_add_monoid_carrier Mᵢ y :=
begin
    -- nasty `change` tricks to get things to a point where we can use `ext`. `induction` on `f`
  -- and `g` may be easier.
  change (to_add_monoid_carrier Mᵢ).comp (add_monoid_hom.mul_left x) y =
    (add_monoid_hom.mul_left $
      (to_add_monoid_carrier Mᵢ) x).comp (to_add_monoid_carrier Mᵢ) y,
  apply add_monoid_hom.congr_fun,
  ext yi yv : 2,
  let y' := direct_sum.of _ yi yv,
  change (to_add_monoid_carrier Mᵢ).comp (add_monoid_hom.mul_right y') x =
    (add_monoid_hom.mul_right $
      (to_add_monoid_carrier Mᵢ) y').comp (to_add_monoid_carrier Mᵢ) x,
  apply add_monoid_hom.congr_fun,
  ext xi xv : 2,
  let x' := direct_sum.of _ xi xv,
  change to_add_monoid_carrier Mᵢ (x' * y') =
    to_add_monoid_carrier Mᵢ x' * to_add_monoid_carrier Mᵢ y',
  dsimp only [x', y'],
  dunfold to_add_monoid_carrier,
  rw of_mul_of,
  simp only [to_add_monoid_of],
  refl,
end

/-- `direct_sum.add_submonoid_decomposition` as a `ring_equiv`. -/
def add_submonoid_decomposition_ring_equiv
  [has_add_submonoid_decomposition Mᵢ] [add_submonoid.is_gmonoid Mᵢ] :
  R ≃+* ⨁ i, Mᵢ i :=
ring_equiv.symm
{ map_mul' := to_add_monoid_carrier_mul Mᵢ,
  ..(add_submonoid_decomposition Mᵢ).symm}

end semiring

section comm_semiring

variables {A R : Type*} [decidable_eq A] [add_comm_monoid A] [comm_semiring R] (Mᵢ : A → add_submonoid R)

/-- TODO: perhaps `gcomm_monoid.of_add_submonoids` should be merged with this. -/
instance add_submonoid.is_gmonoid.gcomm_monoid [add_submonoid.is_gmonoid Mᵢ] : gcomm_monoid (λ i, Mᵢ i) :=
gcomm_monoid.of_add_submonoids _ add_submonoid.is_gmonoid.grading_one $
  λ i j ⟨a, ha⟩ ⟨b, hb⟩, add_submonoid.is_gmonoid.grading_mul ha hb
end comm_semiring

end add_submonoid

/-!
### Collections of `add_subgroups`
-/
section add_subgroup

/-!
#### `add_subgroup`s over an `add_comm_group`
-/
section add_comm_group

variables {ι G : Type*} [decidable_eq ι] [add_comm_group G] (Gᵢ : ι → add_subgroup G)

/-- The canonical map from a direct sum of `add_submonoid`s to their carrier type-/
abbreviation to_add_group_carrier : (⨁ i, Gᵢ i) →+ G :=
(to_add_monoid $ λ i, (Gᵢ i).subtype)

/-- A class to indicate that the collection of submonoids `Mᵢ` make up an internal direct
sum. -/
class has_add_subgroup_decomposition :=
(components : G → ⨁ i, Gᵢ i)
(left_inv : left_inverse (to_add_group_carrier Gᵢ) components)
(right_inv : right_inverse (to_add_group_carrier Gᵢ) components)

/- The decomposition provided by a `has_add_subgroup_decomposition` as an `add_equiv`. -/
def add_subgroup_decomposition [has_add_subgroup_decomposition Gᵢ] : G ≃+ ⨁ i, Gᵢ i :=
add_equiv.symm {
  inv_fun := (direct_sum.has_add_subgroup_decomposition.components : G → ⨁ i, Gᵢ i),
  left_inv := has_add_subgroup_decomposition.right_inv,
  right_inv := has_add_subgroup_decomposition.left_inv,
  ..(to_add_group_carrier Gᵢ) }

/-- By definition a `add_subgroup_decomposition` makes up an internal direct sum. -/
lemma add_subgroup_decomposition.is_internal [has_add_subgroup_decomposition Gᵢ] :
  add_subgroup_is_internal Gᵢ :=
(add_subgroup_decomposition Gᵢ).symm.bijective

/-- Noncomputably construct a decomposition from a proof the direct sum is an internal direct
sum. -/
noncomputable def add_subgroup_is_internal.has_decomposition (h : add_subgroup_is_internal Gᵢ) :
  has_add_subgroup_decomposition Gᵢ :=
{ components := (equiv.of_bijective _ h).symm,
  ..(equiv.of_bijective _ h).symm}

end add_comm_group

/-!
#### `add_subgroup`s over a `ring`
-/
section ring

variables {A R : Type*} [decidable_eq A] [add_monoid A] [ring R] (Gᵢ : A → add_subgroup R)

/-- A class to indicate that a collection of `add_subgroup`s meet the requirements of
`direct_sum.gmonoid`. -/
class add_subgroup.is_gmonoid : Prop :=
(grading_one : (1 : R) ∈ Gᵢ 0)
(grading_mul : ∀ {m n : A} {r s : R},
  r ∈ Gᵢ m → s ∈ Gᵢ n → r * s ∈ Gᵢ (m + n))

instance add_subgroup.is_gmonoid.gmonoid [add_subgroup.is_gmonoid Gᵢ] : gmonoid (λ i, Gᵢ i) :=
gmonoid.of_add_subgroups _ add_subgroup.is_gmonoid.grading_one $
  λ i j ⟨a, ha⟩ ⟨b, hb⟩, add_subgroup.is_gmonoid.grading_mul ha hb

/-- A decomposition of submonoids of a ring preserves multiplication. -/
lemma to_add_group_carrier_mul [has_add_subgroup_decomposition Gᵢ] [add_subgroup.is_gmonoid Gᵢ]
  (x y : ⨁ i, Gᵢ i) :
  to_add_group_carrier Gᵢ (x * y) =
    to_add_group_carrier Gᵢ x * to_add_group_carrier Gᵢ y :=
begin
    -- nasty `change` tricks to get things to a point where we can use `ext`. `induction` on `f`
  -- and `g` may be easier.
  change (to_add_group_carrier Gᵢ).comp (add_monoid_hom.mul_left x) y =
    (add_monoid_hom.mul_left $
      (to_add_group_carrier Gᵢ) x).comp (to_add_group_carrier Gᵢ) y,
  apply add_monoid_hom.congr_fun,
  ext yi yv : 2,
  let y' := direct_sum.of _ yi yv,
  change (to_add_group_carrier Gᵢ).comp (add_monoid_hom.mul_right y') x =
    (add_monoid_hom.mul_right $
      (to_add_group_carrier Gᵢ) y').comp (to_add_group_carrier Gᵢ) x,
  apply add_monoid_hom.congr_fun,
  ext xi xv : 2,
  let x' := direct_sum.of _ xi xv,
  change to_add_group_carrier Gᵢ (x' * y') =
    to_add_group_carrier Gᵢ x' * to_add_group_carrier Gᵢ y',
  dsimp only [x', y'],
  dunfold to_add_group_carrier,
  rw of_mul_of,
  simp only [to_add_monoid_of],
  refl,
end

/-- `direct_sum.add_subgroup_decomposition` as a `ring_equiv`. -/
def add_subgroup_decomposition_ring_equiv
  [has_add_subgroup_decomposition Gᵢ] [add_subgroup.is_gmonoid Gᵢ] :
  R ≃+* ⨁ i, Gᵢ i :=
ring_equiv.symm
{ map_mul' := to_add_group_carrier_mul Gᵢ,
  ..(add_subgroup_decomposition Gᵢ).symm}

end ring

section comm_ring

variables {A R : Type*} [decidable_eq A] [add_comm_monoid A] [comm_ring R] (Mᵢ : A → add_subgroup R)

instance add_subgroup.is_gmonoid.gcomm_monoid [add_subgroup.is_gmonoid Mᵢ] : gcomm_monoid (λ i, Mᵢ i) :=
gcomm_monoid.of_add_subgroups _ add_subgroup.is_gmonoid.grading_one $
  λ i j ⟨a, ha⟩ ⟨b, hb⟩, add_subgroup.is_gmonoid.grading_mul ha hb

end comm_ring

end add_subgroup

end direct_sum

namespace add_monoid_grading

/-! ## graded pieces for add_monoids -/

section graded_pieces

open_locale direct_sum

open direct_sum

variables {A : Type*} [decidable_eq A] {R : Type*} [add_comm_monoid R]
  (Mᵢ : A → add_submonoid R) [has_add_submonoid_decomposition Mᵢ] --[add_submonoid.is_gmonoid Mᵢ]

/-- Decomposing `r` into `(rᵢ)ᵢ : ⨁ i, Mᵢ i` and then adding the pieces gives `r` again. -/
lemma sum_decomposition  (r : R) :
  (direct_sum.to_add_monoid (λ i, (Mᵢ i).subtype) : (⨁ i, Mᵢ i) →+ R)
    (add_submonoid_decomposition Mᵢ r) = r :=
(add_submonoid_decomposition Mᵢ).symm_apply_apply r

variable {Mᵢ}

/-- If `r ∈ Rₘ` then the element of `R` which is `r` at `m` and zero elsewhere, is `r`. -/
lemma eq_decomposition_of_mem_piece''' {r : R} {i : A}
  (hr : r ∈ Mᵢ i) :
  (add_submonoid_decomposition Mᵢ).symm (direct_sum.of (λ i, Mᵢ i) i ⟨r, hr⟩) = r :=
begin
  change (direct_sum.to_add_monoid (λ i, (Mᵢ i).subtype) : (⨁ i, (Mᵢ i)) →+ R)
    (direct_sum.of (λ i, Mᵢ i) i ⟨r, hr⟩) = r,
  rw direct_sum.to_add_monoid_of,
  refl,
end

/-- If `r ∈ Rₘ` then `r` is the element of `⨁Rₘ` which is `r` at `m` and `0` elsewhere. -/
lemma eq_decomposition_of_mem_piece'' {r : R} {i : A}
  (hr : r ∈ Mᵢ i) :
  add_submonoid_decomposition Mᵢ r = (direct_sum.of (λ i, Mᵢ i) i ⟨r, hr⟩) :=
(add_submonoid_decomposition Mᵢ).to_equiv.eq_symm_apply.mp
  (eq_decomposition_of_mem_piece''' hr).symm

/-- If `r ∈ Rₘ` then `rₘ`, the `m`'th component of `r`, considered as an element of `Rₘ`, is `r`. -/
lemma eq_decomposition_of_mem_piece' {r : R} {i : A} (hr : r ∈ Mᵢ i) :
  add_submonoid_decomposition Mᵢ r i = ⟨r, hr⟩ :=
begin
  rw eq_decomposition_of_mem_piece'' hr,
  apply dfinsupp.single_eq_same,
end

/-- If `r ∈ Rₘ` then `rₘ`, the `m`'th component of `r`, considered as an element of `R`, is `r`. -/
lemma eq_decomposition_of_mem_piece {r : R} {i : A} (hr : r ∈ Mᵢ i) :
  (add_submonoid_decomposition Mᵢ r i : R) = r :=
begin
  rw eq_decomposition_of_mem_piece' hr,
  refl,
end

lemma mem_piece_iff_single_support (r : R) (i : A) :
  r ∈ Mᵢ i ↔ ∀ ⦃j⦄, j ≠ i → add_submonoid_decomposition Mᵢ r j = 0 :=
begin
  split,
  { intros hrm n hn,
    rw eq_decomposition_of_mem_piece'' hrm,
    exact direct_sum.projection_of_ne _ hn.symm _ },
  { intro h,
    rw dfinsupp.eq_single_iff at h,
    -- can't use `classical` because `decidable_eq M` gets lost
    letI : ∀ n, decidable_eq (Mᵢ n) := λ _, classical.dec_eq _,
    rw [← sum_decomposition Mᵢ r, direct_sum.to_add_monoid_apply, ← h,
        dfinsupp.add_monoid_hom_sum_single_index],
    exact (add_submonoid_decomposition Mᵢ r i).2 }
end

end graded_pieces

/-!

## rings are graded by subgroups

If a ring (or even an add_comm_group) is an internal direct sum of add_submonoids
then they're all add_subgroups.

-/

open direct_sum

-- M is an add_comm_group now, not an add_comm_monoid

variables {ι : Type*} [decidable_eq ι] {M : Type*} [add_comm_group M]
  (Mᵢ : ι → add_submonoid M) [has_add_submonoid_decomposition Mᵢ]

def neg_mem {i : ι} {x : M}
  (hx : x ∈ Mᵢ i) : -x ∈ Mᵢ i :=
begin
    convert (add_submonoid_decomposition Mᵢ (-x) i).2,
    apply neg_eq_of_add_eq_zero,
    --  x ∈ Rₘ so (add_submonoid_decomposition Mᵢ).to_finsupp m = x.
    nth_rewrite 0 ← eq_decomposition_of_mem_piece hx,
    rw subtype.val_eq_coe,
    norm_cast,
    suffices : (add_submonoid_decomposition Mᵢ x +
      add_submonoid_decomposition Mᵢ (-x)) i  = 0,
      simp only [*, add_submonoid.coe_zero, direct_sum.add_apply] at *,
    simp [← (add_submonoid_decomposition Mᵢ).map_add],
end

end add_monoid_grading
