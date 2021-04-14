import breen_deligne.universal_map
import breen_deligne.functorial_map
import system_of_complexes.complex

import for_mathlib.free_abelian_group

/-!

# The category of Breen-Deligne data

This file defines the category whose objects are the natural numbers
and whose morphisms `m ⟶ n` are functorial maps `φ_A : ℤ[A^m] → ℤ[A^n]`.

-/

open_locale big_operators

namespace breen_deligne

open free_abelian_group category_theory

/-- The category whose objects are natural numbers
and whose morphisms are the free abelian groups generated by
matrices with integer coefficients. -/
@[derive comm_semiring] def FreeMat := ℕ

namespace FreeMat

instance : small_category FreeMat :=
{ hom := λ m n, universal_map m n,
  id := universal_map.id,
  comp := λ l m n f g, universal_map.comp g f,
  id_comp' := λ n f, universal_map.comp_id,
  comp_id' := λ n f, universal_map.id_comp,
  assoc' := λ k l m n f g h, (universal_map.comp_assoc h g f).symm }

instance : preadditive FreeMat :=
{ hom_group := λ m n, infer_instance,
  add_comp' := λ l m n f g h, add_monoid_hom.map_add _ _ _,
  comp_add' := λ l m n f g h, show universal_map.comp (g + h) f = _,
    by { rw [add_monoid_hom.map_add, add_monoid_hom.add_apply], refl } }

open universal_map

lemma double_comp_double {l m n : FreeMat} (f : l ⟶ m) (g : m ⟶ n) :
  (f.double ≫ g.double : l+l ⟶ n+n) = (f ≫ g).double :=
comp_double_double _ _

lemma double_add {m n : FreeMat} (f g : m ⟶ n) :
  ((f + g).double : m+m ⟶ n+n) = f.double + g.double :=
add_monoid_hom.map_add _ _ _

@[simps]
def mul_functor (N : ℕ) : FreeMat ⥤ FreeMat :=
{ obj := λ n, N * n,
  map := λ m n f, mul N f,
  map_id' := λ n, (free_abelian_group.map_of _ _).trans $ congr_arg _ $
  begin
    dsimp [basic_universal_map.mul, basic_universal_map.id],
    ext i j,
    rw matrix.kronecker_one_one,
    simp only [matrix.minor_apply, matrix.one_apply, equiv.apply_eq_iff_eq, eq_self_iff_true],
    split_ifs; refl
  end,
  map_comp' := λ l m n f g, mul_comp _ _ _ }
.
instance mul_functor.additive (N : ℕ) : (mul_functor N).additive :=
{ map_zero' := λ m n, add_monoid_hom.map_zero _,
  map_add' := λ m n f g, add_monoid_hom.map_add _ _ _ }

@[simps] def iso_mk' {m n : FreeMat}
  (f : basic_universal_map m n) (g : basic_universal_map n m)
  (hfg : basic_universal_map.comp g f = basic_universal_map.id _)
  (hgf : basic_universal_map.comp f g = basic_universal_map.id _) :
  m ≅ n :=
{ hom := of f,
  inv := of g,
  hom_inv_id' := (comp_of _ _).trans $ congr_arg _ $ hfg,
  inv_hom_id' := (comp_of _ _).trans $ congr_arg _ $ hgf }

def one_mul_iso : mul_functor 1 ≅ 𝟭 _ :=
nat_iso.of_components (λ n, iso_mk'
  (basic_universal_map.one_mul_hom _) (basic_universal_map.one_mul_inv _)
  basic_universal_map.one_mul_inv_hom basic_universal_map.one_mul_hom_inv)
begin
  intros m n f,
  dsimp,
  show universal_map.comp _ _ = universal_map.comp _ _,
  rw [← add_monoid_hom.comp_apply, ← add_monoid_hom.comp_hom_apply_apply,
    ← add_monoid_hom.flip_apply _ f],
  congr' 1, clear f, ext1 f,
  have : f = matrix.reindex_linear_equiv
      ((fin_one_equiv.prod_congr $ equiv.refl _).trans $ equiv.punit_prod _)
      ((fin_one_equiv.prod_congr $ equiv.refl _).trans $ equiv.punit_prod _)
      (matrix.kronecker 1 f),
  { ext i j, dsimp [matrix.kronecker, matrix.one_apply],
    simp only [one_mul, if_true, eq_iff_true_of_subsingleton], },
  conv_rhs { rw this },
  simp only [comp_of, mul_of, basic_universal_map.comp, add_monoid_hom.coe_mk',
    basic_universal_map.mul, basic_universal_map.one_mul_hom,
    add_monoid_hom.comp_hom_apply_apply, add_monoid_hom.comp_apply, add_monoid_hom.flip_apply,
    matrix.reindex_linear_equiv_mul, matrix.one_mul, matrix.mul_one, iso_mk'_hom],
end
.

def mul_mul_iso (m n : ℕ) : mul_functor n ⋙ mul_functor m ≅ mul_functor (m * n) :=
nat_iso.of_components (λ i, iso_mk'
  (basic_universal_map.mul_mul_hom m n i) (basic_universal_map.mul_mul_inv m n i)
  basic_universal_map.mul_mul_inv_hom basic_universal_map.mul_mul_hom_inv)
begin
  intros i j f,
  dsimp,
  show universal_map.comp _ _ = universal_map.comp _ _,
  rw [← add_monoid_hom.comp_apply, ← add_monoid_hom.comp_apply,
    ← add_monoid_hom.flip_apply _ (mul (m * n) f),
    ← add_monoid_hom.comp_apply],
  congr' 1, clear f, ext1 f,
  simp only [comp_of, mul_of, basic_universal_map.comp, add_monoid_hom.coe_mk',
    basic_universal_map.mul, basic_universal_map.mul_mul_hom, matrix.reindex_linear_equiv_mul,
    add_monoid_hom.comp_hom_apply_apply, add_monoid_hom.comp_apply, add_monoid_hom.flip_apply,
    matrix.one_mul, matrix.mul_reindex_linear_equiv_one],
  rw [matrix.kronecker_reindex_right, matrix.kronecker_assoc', matrix.kronecker_one_one,
    ← matrix.reindex_linear_equiv_one (@fin_prod_fin_equiv m n), matrix.kronecker_reindex_left],
  simp only [matrix.reindex_reindex],
  congr' 3,
  { ext ⟨⟨a, b⟩, c⟩ : 1, dsimp, simp only [equiv.symm_apply_apply], },
  { ext ⟨⟨a, b⟩, c⟩ : 1, dsimp, simp only [equiv.symm_apply_apply], },
end

end FreeMat

/-- Roughly speaking, this is a collection of formal finite sums of matrices
that encode the data that rolls out of the Breen--Deligne resolution. -/
@[derive [small_category, preadditive]]
def data := chain_complex ℕ FreeMat

namespace data

variable (BD : data)

section reindex

open category_theory.limits

/-
=== jmc: I don't think that `reindex` is actually useful
-/

@[simps]
def reindex (rank : ℕ → ℕ) (hr : ∀ i, BD.X i = rank i) :
  data :=
{ X := rank,
  d := λ i j, (eq_to_iso (hr i)).inv ≫ BD.d i j ≫ (eq_to_iso (hr j)).hom,
  d_comp_d := λ i j k,
  by simp only [category.assoc, iso.hom_inv_id_assoc, BD.d_comp_d_assoc, zero_comp, comp_zero],
  d_eq_zero := λ i j hij,
  by simp only [BD.d_eq_zero hij, zero_comp, comp_zero] }

@[simps]
def reindex_iso (rank : ℕ → ℕ) (hr : ∀ i, BD.X i = rank i) :
  BD ≅ BD.reindex rank hr :=
differential_object.complex_like.iso_of_components (λ i, eq_to_iso (hr i)) $
by { intros i j, rw [reindex_d, iso.hom_inv_id_assoc] }

end reindex

section mul

open universal_map

@[simps]
def mul (N : ℕ) : data ⥤ data :=
(FreeMat.mul_functor N).map_complex_like

def mul_one_iso : (mul 1).obj BD ≅ BD :=
differential_object.complex_like.iso_of_components (λ i, FreeMat.one_mul_iso.app _) $
λ i j, FreeMat.one_mul_iso.hom.naturality (BD.d i j)

def mul_mul_iso (m n : ℕ) : (mul m).obj ((mul n).obj BD) ≅ (mul (m * n)).obj BD :=
differential_object.complex_like.iso_of_components (λ i, (FreeMat.mul_mul_iso _ _).app _) $
λ i j, (FreeMat.mul_mul_iso _ _).hom.naturality (BD.d i j)

end mul

/-- `BD.double` is the Breen--Deligne data whose `n`-th rank is `2 * BD.rank n`. -/
@[simps] def double : data :=
{ X := λ n, BD.X n + BD.X n,
  d := λ m n, (BD.d m n).double,
  d_eq_zero := λ m n h, by { rw [BD.d_eq_zero h, universal_map.double_zero] },
  d_comp_d := λ l m n,
    calc _ = (BD.d l m ≫ BD.d m n).double : universal_map.comp_double_double _ _
    ... = 0 : by { rw [BD.d_comp_d, universal_map.double_zero] } }

/-- `BD.pow N` is the Breen--Deligne data whose `n`-th rank is `2^N * BD.rank n`. -/
def pow : ℕ → data
| 0     := BD
| (n+1) := (pow n).double

/-- `BD.pow N` is the Breen--Deligne data whose `n`-th rank is `2^N * BD.rank n`. -/
def pow' : ℕ → data
| 0     := BD
| (n+1) := (mul 2).obj (pow' n)

lemma BD_pow_X : ∀ N i, (BD.pow N).X i = 2^N * BD.X i
| 0     i := by { rw [pow_zero, one_mul], refl }
| (N+1) i := by { rw [pow_succ, two_mul, add_mul, ← BD_pow_X N], refl }

@[simps] def σ : BD.double ⟶ BD :=
{ f := λ n, universal_map.σ _,
  comm := λ m n, universal_map.σ_comp_double _ }

@[simps] def π : BD.double ⟶ BD :=
{ f := λ n, universal_map.π _,
  comm := λ m n, universal_map.π_comp_double _ }

@[simps] def sum (BD : data) (N : ℕ) : (mul N).obj BD ⟶ BD :=
{ f := λ n, universal_map.sum _ _,
  comm := λ m n, universal_map.sum_comp_mul _ _ }

@[simps] def proj (BD : data) (N : ℕ) : (mul N).obj BD ⟶ BD :=
{ f := λ n, universal_map.proj _ _,
  comm := λ m n, universal_map.proj_comp_mul _ _ }

open differential_object.complex_like FreeMat

@[simps]
def hom_double {BD₁ BD₂ : data} (f : BD₁ ⟶ BD₂) : BD₁.double ⟶ BD₂.double :=
{ f := λ i, (f.f i).double,
  comm := λ i j,
  calc BD₁.double.d i j ≫ (f.f j).double
      = (BD₁.d i j ≫ f.f j).double : double_comp_double _ _
  ... = (f.f i ≫ BD₂.d i j).double : congr_arg _ (f.comm i j)
  ... = (f.f i).double ≫ BD₂.double.d i j : (double_comp_double _ _).symm }

def hom_pow {BD : data} (f : BD.double ⟶ BD) : Π N, BD.pow N ⟶ BD
| 0     := 𝟙 _
| (n+1) := hom_double (hom_pow n) ≫ f

def hom_pow' {BD : data} (f : (mul 2).obj BD ⟶ BD) : Π N, BD.pow' N ⟶ BD
| 0     := 𝟙 _
| (n+1) := (mul 2).map (hom_pow' n) ≫ f

@[simps]
def homotopy_double {BD₁ BD₂ : data} {f g : BD₁ ⟶ BD₂} (h : homotopy f g) :
  homotopy (hom_double f) (hom_double g) :=
{ h := λ j i, (h.h j i).double,
  h_eq_zero := λ i j hij, by rw [h.h_eq_zero i j hij, universal_map.double_zero],
  comm := λ i j k hij hjk,
  begin
    simp only [double_d, double_comp_double, ← double_add, h.comm i j k hij hjk],
    exact add_monoid_hom.map_sub _ _ _
  end }

@[simps]
def homotopy_two_mul {BD₁ BD₂ : data} {f g : BD₁ ⟶ BD₂} (h : homotopy f g) :
  homotopy ((mul 2).map f) ((mul 2).map g) :=
{ h := λ j i, universal_map.mul 2 (h.h j i),
  h_eq_zero := λ i j hij, by rw [h.h_eq_zero i j hij, add_monoid_hom.map_zero],
  comm := λ i j k hij hjk,
  begin
    simp only [mul_obj_d, mul_map_f, ← add_monoid_hom.map_sub],
    rw [← h.comm i j k hij hjk, add_monoid_hom.map_add],
    erw [universal_map.mul_comp, universal_map.mul_comp],
    refl
  end }

def homotopy_pow (h : homotopy BD.σ BD.π) :
  Π N, homotopy (hom_pow BD.σ N) (hom_pow BD.π N)
| 0     := homotopy.refl
| (n+1) := (homotopy_double (homotopy_pow n)).comp h

def homotopy_pow' (h : homotopy (BD.sum 2) (BD.proj 2)) :
  Π N, homotopy (hom_pow' (BD.sum 2) N) (hom_pow' (BD.proj 2) N)
| 0     := homotopy.refl
| (N+1) := (homotopy_two_mul (homotopy_pow' N)).comp h

def pow'_iso_mul : Π N, BD.pow' N ≅ (mul (2^N)).obj BD
| 0     := BD.mul_one_iso.symm
| (N+1) := show (mul 2).obj (BD.pow' N) ≅ (mul (2 * 2 ^ N)).obj BD, from
   (mul 2).map_iso (pow'_iso_mul N) ≪≫ mul_mul_iso _ _ _

lemma hom_pow'_sum : ∀ N, (BD.pow'_iso_mul N).inv ≫ hom_pow' (BD.sum 2) N = BD.sum (2^N)
| 0     :=
begin
  ext n : 2,
  simp only [hom_pow', category.comp_id, sum_f, universal_map.sum],
  dsimp [pow_zero],
  rw [finset.sum_singleton],
  refine congr_arg of _,
  apply basic_universal_map.one_mul_hom_eq_proj,
end
| (N+1) :=
begin
  dsimp [pow'_iso_mul, hom_pow'],
  slice_lhs 2 3 { rw [← functor.map_comp, hom_pow'_sum] },
  rw iso.inv_comp_eq,
  ext i : 2,
  iterate 2 { erw [differential_object.comp_f] },
  dsimp [mul_mul_iso, FreeMat.mul_mul_iso, universal_map.sum],
  rw [universal_map.mul_of],
  show universal_map.comp _ _ = universal_map.comp _ _,
  simp only [universal_map.comp_of, add_monoid_hom.map_sum, add_monoid_hom.finset_sum_apply],
  congr' 1,
  rw [← finset.sum_product', finset.univ_product_univ, ← fin_prod_fin_equiv.symm.sum_comp],
  apply fintype.sum_congr,
  apply basic_universal_map.comp_proj_mul_proj,
end
.

lemma hom_pow'_proj : ∀ N, (BD.pow'_iso_mul N).inv ≫ hom_pow' (BD.proj 2) N = BD.proj (2^N)
| 0     :=
begin
  ext n : 2,
  simp only [hom_pow', category.comp_id, proj_f, universal_map.proj],
  dsimp [pow_zero],
  rw [finset.sum_singleton],
  refine congr_arg of _,
  apply basic_universal_map.one_mul_hom_eq_proj,
end
| (N+1) :=
begin
  dsimp [pow'_iso_mul, hom_pow'],
  slice_lhs 2 3 { rw [← functor.map_comp, hom_pow'_proj] },
  rw iso.inv_comp_eq,
  ext i : 2,
  iterate 2 { erw [differential_object.comp_f] },
  dsimp [mul_mul_iso, FreeMat.mul_mul_iso, universal_map.proj],
  simp only [add_monoid_hom.map_sum, add_monoid_hom.finset_sum_apply,
    preadditive.comp_sum, preadditive.sum_comp],
  rw [← finset.sum_comm, ← finset.sum_product', finset.univ_product_univ,
      ← fin_prod_fin_equiv.symm.sum_comp],
  apply fintype.sum_congr,
  intros j,
  rw [universal_map.mul_of],
  show universal_map.comp _ _ = universal_map.comp _ _,
  simp only [universal_map.comp_of, basic_universal_map.comp_proj_mul_proj],
end

lemma hom_pow'_proj' (N : ℕ) : hom_pow' (BD.proj 2) N = (BD.pow'_iso_mul N).hom ≫ BD.proj (2^N) :=
by { rw ← iso.inv_comp_eq, apply hom_pow'_proj }

def homotopy_mul (h : homotopy (BD.sum 2) (BD.proj 2)) (N : ℕ) :
  homotopy (BD.sum (2^N)) (BD.proj (2^N)) :=
(homotopy.of_eq $ BD.hom_pow'_sum N).symm.trans $
  ((BD.homotopy_pow' h N).const_comp (BD.pow'_iso_mul N).inv).trans $
  (homotopy.of_eq $ BD.hom_pow'_proj N)

end data

section
universe variables u
open universal_map
variables {m n : ℕ} (A : Type u) [add_comm_group A] (f : universal_map m n)

end

open differential_object.complex_like

/-- A Breen--Deligne `package` consists of Breen--Deligne `data`
that forms a complex, together with a `homotopy`
between the two universal maps `σ_add` and `σ_proj`. -/
structure package :=
(data       : data)
(homotopy   : homotopy (data.sum 2) (data.proj 2))

namespace package

/-- `BD.rank i` is the rank of the `i`th entry in the Breen--Deligne resolution described by `BD`. -/
def rank (BD : package) := BD.data.X

def map (BD : package) (i : ℕ) := BD.data.d (i+1) i

@[simp] lemma map_comp_map (BD : package) (i : ℕ) : BD.map _ ≫ BD.map i = 0 :=
BD.data.d_comp_d _ _ _

end package

end breen_deligne
