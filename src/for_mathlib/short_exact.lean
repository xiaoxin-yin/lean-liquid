import for_mathlib.split_exact

noncomputable theory

open category_theory category_theory.limits

variables {𝓐 : Type*} [category 𝓐] [abelian 𝓐]

-- move me
lemma exact_of_exact_image {X Y Z : 𝓐} (f : X ⟶ Y) (g : Y ⟶ Z) (h : exact f (factor_thru_image g)) :
  exact f g :=
by { rw ← limits.image.fac g, exact exact_comp_mono h }

-- SELFCONTAINED RB working on it
lemma exact_factor_thru_image_iff {X Y Z : 𝓐} (f : X ⟶ Y) (g : Y ⟶ Z) :
  exact f (factor_thru_image g) ↔ exact f g :=
begin
  refine ⟨exact_of_exact_image f g, _⟩,
  intro h, rw ← limits.image.fac g at h,
  -- this should probably be extracted into a separate lemma
  sorry
end

lemma short_exact_kernel_factor_thru_image {A B : 𝓐} (f : A ⟶ B) :
  short_exact (kernel.ι f) (factor_thru_image f) :=
begin
  refine ⟨_⟩,
  rw exact_factor_thru_image_iff,
  apply exact_kernel_ι,
end

-- SELFCONTAINED
lemma iso_of_short_exact_comp_right {X Y Z W : 𝓐} (f : X ⟶ Y) (g : Y ⟶ Z) (h : Z ⟶ W)
  (H1 : short_exact f g) (H2 : short_exact f (g ≫ h)) :
  is_iso h :=
sorry
