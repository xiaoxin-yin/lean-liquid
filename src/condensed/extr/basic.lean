import topology.category.Profinite.projective
import for_mathlib.Profinite.disjoint_union
import for_mathlib.concrete_equalizer

noncomputable theory

open category_theory

universes u w v

structure ExtrDisc :=
(val : Profinite.{u})
[cond : projective val]

namespace ExtrDisc

@[ext]
structure hom (X Y : ExtrDisc) := mk :: (val : X.val ⟶ Y.val)

def of (X : Profinite) [projective X] : ExtrDisc := ⟨X⟩

@[simp]
def of_val (X : Profinite) [projective X] : (of X).val = X := rfl

@[simps]
instance : category ExtrDisc :=
{ hom := hom,
  id := λ X, ⟨𝟙 _⟩,
  comp := λ X Y Z f g, ⟨f.val ≫ g.val⟩ }

@[simps]
def _root_.ExtrDisc_to_Profinite : ExtrDisc ⥤ Profinite :=
{ obj := val,
  map := λ X Y f, f.val }

instance : full ExtrDisc_to_Profinite := { preimage := λ X Y f, ⟨f⟩ }

instance : faithful ExtrDisc_to_Profinite := { }

instance : concrete_category ExtrDisc.{u} :=
{ forget := ExtrDisc_to_Profinite ⋙ forget _,
  forget_faithful := ⟨⟩ }

instance : has_coe_to_sort ExtrDisc Type* :=
concrete_category.has_coe_to_sort _

instance {X Y : ExtrDisc} : has_coe_to_fun (X ⟶ Y) (λ f, X → Y) :=
⟨λ f, f.val⟩

@[simp]
lemma coe_fun_eq {X Y : ExtrDisc} (f : X ⟶ Y) (x : X) :
  f x = f.val x := rfl

instance (X : ExtrDisc) : projective X.val := X.cond

example (X : ExtrDisc) : projective (ExtrDisc_to_Profinite.obj X) :=
by { dsimp, apply_instance }

def lift {X Y : Profinite} {P : ExtrDisc} (f : X ⟶ Y)
  (hf : function.surjective f) (e : P.val ⟶ Y) : P.val ⟶ X :=
begin
  haveI : epi f := by rwa Profinite.epi_iff_surjective f,
  choose g h using projective.factors e f,
  exact g,
end

@[simp, reassoc]
lemma lift_lifts {X Y : Profinite} {P : ExtrDisc} (f : X ⟶ Y)
  (hf : function.surjective f) (e : P.val ⟶ Y) :
  lift f hf e ≫ f = e :=
begin
  haveI : epi f := by rwa Profinite.epi_iff_surjective f,
  apply (projective.factors e f).some_spec,
end

instance (X : ExtrDisc) : topological_space X :=
show topological_space X.val, by apply_instance

instance (X : ExtrDisc) : compact_space X :=
show compact_space X.val, by apply_instance

instance (X : ExtrDisc) : t2_space X :=
show t2_space X.val, by apply_instance

instance (X : ExtrDisc) : totally_disconnected_space X :=
show totally_disconnected_space X.val, by apply_instance

.-- move this
-- @[simps]
def _root_.Profinite.sum_iso_coprod (X Y : Profinite.{u}) :
  Profinite.sum X Y ≅ X ⨿ Y :=
{ hom := Profinite.sum.desc _ _ limits.coprod.inl limits.coprod.inr,
  inv := limits.coprod.desc (Profinite.sum.inl _ _) (Profinite.sum.inr _ _),
  hom_inv_id' := by { apply Profinite.sum.hom_ext;
    simp only [← category.assoc, category.comp_id, Profinite.sum.inl_desc,
      limits.coprod.inl_desc, Profinite.sum.inr_desc, limits.coprod.inr_desc] },
  inv_hom_id' := by { apply limits.coprod.hom_ext;
    simp only [← category.assoc, category.comp_id, Profinite.sum.inl_desc,
      limits.coprod.inl_desc, Profinite.sum.inr_desc, limits.coprod.inr_desc] } }

@[simps]
def sum (X Y : ExtrDisc.{u}) : ExtrDisc.{u} :=
{ val := Profinite.sum X.val Y.val,
  cond := begin
    let Z := Profinite.sum X.val Y.val,
    apply projective.of_iso (Profinite.sum_iso_coprod X.val Y.val).symm,
    apply_instance,
  end }

@[simps]
def sum.inl (X Y : ExtrDisc) : X ⟶ sum X Y :=
⟨Profinite.sum.inl _ _⟩

@[simps]
def sum.inr (X Y : ExtrDisc) : Y ⟶ sum X Y :=
⟨Profinite.sum.inr _ _⟩

@[simps]
def sum.desc {X Y Z : ExtrDisc} (f : X ⟶ Z) (g : Y ⟶ Z) :
  sum X Y ⟶ Z :=
⟨Profinite.sum.desc _ _ f.val g.val⟩

@[simp]
lemma sum.inl_desc {X Y Z : ExtrDisc} (f : X ⟶ Z) (g : Y ⟶ Z) :
  sum.inl X Y ≫ sum.desc f g = f :=
by { ext1, dsimp, simp }

@[simp]
lemma sum.inr_desc {X Y Z : ExtrDisc} (f : X ⟶ Z) (g : Y ⟶ Z) :
  sum.inr X Y ≫ sum.desc f g = g :=
by { ext1, dsimp, simp }

@[ext]
lemma sum.hom_ext {X Y Z : ExtrDisc} (f g : sum X Y ⟶ Z)
  (hl : sum.inl X Y ≫ f = sum.inl X Y ≫ g)
  (hr : sum.inr X Y ≫ f = sum.inr X Y ≫ g) : f = g :=
begin
  ext1,
  apply Profinite.sum.hom_ext,
  { apply_fun (λ e, e.val) at hl, exact hl },
  { apply_fun (λ e, e.val) at hr, exact hr }
end

-- move this
lemma _root_.Profinite.empty_is_initial : limits.is_initial Profinite.empty.{u} :=
@limits.is_initial.of_unique.{u} _ _ _ (λ Y, ⟨⟨Profinite.empty.elim _⟩, λ f, by { ext, cases x, }⟩)

@[simps]
def empty : ExtrDisc :=
{ val := Profinite.empty,
  cond := begin
    let e : Profinite.empty ≅ ⊥_ _ :=
    Profinite.empty_is_initial.unique_up_to_iso limits.initial_is_initial,
    apply projective.of_iso e.symm,
    -- apply_instance, <-- missing instance : projective (⊥_ _)
    constructor,
    introsI A B f g _,
    refine ⟨limits.initial.to A, by simp⟩,
  end }

@[simps]
def empty.elim (X : ExtrDisc) : empty ⟶ X :=
⟨Profinite.empty.elim _⟩

@[ext]
def empty.hom_ext {X : ExtrDisc} (f g : empty ⟶ X) : f = g :=
by { ext x, cases x }

def sigma {ι : Type u} [fintype ι] (X : ι → ExtrDisc) : ExtrDisc :=
{ val := Profinite.sigma $ λ i, (X i).val,
  cond := begin
    let e : Profinite.sigma (λ i, (X i).val) ≅ ∐ (λ i, (X i).val) :=
      (Profinite.sigma_cofan_is_colimit _).cocone_point_unique_up_to_iso
      (limits.colimit.is_colimit _),
    apply projective.of_iso e.symm,
    apply_instance,
  end }

def sigma.ι {ι : Type u} [fintype ι] (X : ι → ExtrDisc) (i) :
  X i ⟶ sigma X := ⟨Profinite.sigma.ι _ i⟩

def sigma.desc {ι : Type u} {Y : ExtrDisc} [fintype ι] (X : ι → ExtrDisc)
  (f : Π i, X i ⟶ Y) : sigma X ⟶ Y := ⟨Profinite.sigma.desc _ $ λ i, (f i).val⟩

lemma sigma.ι_desc {ι : Type u} {Y : ExtrDisc} [fintype ι] (X : ι → ExtrDisc)
  (f : Π i, X i ⟶ Y) (i) : sigma.ι X i ≫ sigma.desc X f = f i :=
begin
  ext1,
  apply Profinite.sigma.ι_desc,
end

lemma sigma.hom_ext {ι : Type u} {Y : ExtrDisc} [fintype ι] (X : ι → ExtrDisc)
  (a b : sigma X ⟶ Y) (w : ∀ i, sigma.ι X i ≫ a = sigma.ι X i ≫ b) : a = b :=
begin
  ext1,
  apply Profinite.sigma.hom_ext,
  intros i,
  specialize w i,
  apply_fun (λ e, e.val) at w,
  exact w,
end

lemma sigma.ι_jointly_surjective {ι : Type u} [fintype ι] (X : ι → ExtrDisc)
  (x : sigma X) : ∃ i (t : X i), sigma.ι X i t = x :=
Profinite.sigma.ι_jointly_surjective _ _

open opposite

variables {C : Type v} [category.{w} C] (F : ExtrDisc.{u}ᵒᵖ ⥤ C)

def terminal_condition [limits.has_terminal C] : Prop :=
  is_iso (limits.terminal.from (F.obj (op empty)))

def binary_product_condition [limits.has_binary_products C] : Prop := ∀ (X Y : ExtrDisc.{u}),
  is_iso (limits.prod.lift (F.map (sum.inl X Y).op) (F.map (sum.inr X Y).op))

def finite_product_condition [limits.has_finite_products C] (F : ExtrDisc.{u}ᵒᵖ ⥤ C) :
  Prop := ∀ (ι : Type u) [fintype ι] (X : ι → ExtrDisc),
begin
  -- Lean is being annoying here...
  resetI,
  let t : Π i, F.obj (op (sigma X)) ⟶ F.obj (op (X i)) := λ i, F.map (sigma.ι X i).op,
  exact is_iso (limits.pi.lift t)
end

def finite_product_condition_for_types (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) : Prop :=
  ∀ (ι : Type u) [fintype ι] (X : ι → ExtrDisc),
begin
  resetI,
  let t : Π i, F.obj (op (sigma X)) → F.obj (op (X i)) := λ i, F.map (sigma.ι X i).op,
  let tt : F.obj (op (sigma X)) → Π i, F.obj (op (X i)) := λ x i, t i x,
  exact function.bijective tt
end

def equalizer_condition [limits.has_equalizers C] (F : ExtrDisc.{u}ᵒᵖ ⥤ C) : Prop :=
  ∀ {R X B : ExtrDisc} (f : X ⟶ B) (hf : function.surjective f)
    (g : R.val ⟶ Profinite.pullback f.val f.val) (hg : function.surjective g),
  let e₁ : R ⟶ X := ⟨g ≫ Profinite.pullback.fst _ _⟩,
      e₂ : R ⟶ X := ⟨g ≫ Profinite.pullback.snd _ _⟩,
      w : e₁ ≫ f = e₂ ≫ f := by { ext1, dsimp [e₁, e₂], simp [Profinite.pullback.condition] },
      h : F.map f.op ≫ F.map e₁.op = F.map f.op ≫ F.map e₂.op :=
        by { simp only [← F.map_comp, ← op_comp, w] } in
  is_iso (limits.equalizer.lift _ h)

def equalizer_condition_for_types (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) : Prop :=
  ∀ {R X B : ExtrDisc} (f : X ⟶ B) (hf : function.surjective f)
    (g : R.val ⟶ Profinite.pullback f.val f.val) (hg : function.surjective g),
  let e₁ : R ⟶ X := ⟨g ≫ Profinite.pullback.fst _ _⟩,
      e₂ : R ⟶ X := ⟨g ≫ Profinite.pullback.snd _ _⟩,
      w : e₁ ≫ f = e₂ ≫ f := by { ext1, dsimp [e₁, e₂], simp [Profinite.pullback.condition] },
      h : F.map f.op ≫ F.map e₁.op = F.map f.op ≫ F.map e₂.op :=
        by { simp only [← F.map_comp, ← op_comp, w] },
      E := { x : F.obj (op X) // F.map e₁.op x = F.map e₂.op x },
      t : F.obj (op B) → E := λ x, ⟨F.map f.op x, begin
        change (F.map f.op ≫ F.map e₁.op) x = (F.map f.op ≫ F.map e₂.op) x,
        rw h,
      end⟩ in
    function.bijective t

lemma equalizer_condition_holds [limits.has_equalizers C] (F : ExtrDisc.{u}ᵒᵖ ⥤ C) :
  equalizer_condition F :=
begin
  intros R X B f hf g hg,
  dsimp,
  let e₁ : R ⟶ X := ⟨g ≫ Profinite.pullback.fst _ _⟩,
  let e₂ : R ⟶ X := ⟨g ≫ Profinite.pullback.snd _ _⟩,
  let σ : B ⟶ X := ⟨ExtrDisc.lift _ hf (𝟙 _)⟩,
  let t : X ⟶ R := ⟨ExtrDisc.lift _ hg _⟩,
  swap,
  { refine Profinite.pullback.lift _ _ (𝟙 _) (f.val ≫ σ.val) _,
    dsimp, simp },
  have h₁ : t ≫ e₁ = 𝟙 _, by { ext1, dsimp, simp },
  have h₂ : t ≫ e₂ = f ≫ σ, by { ext1, dsimp, simp, },
  have hh : σ ≫ f = 𝟙 _, by { ext1, dsimp, simp },
  use (limits.equalizer.ι _ _ ≫ F.map σ.op),
  split,
  { simp only [limits.equalizer.lift_ι_assoc],
    simp only [← F.map_comp, ← op_comp, hh],
    simp },
  { ext,
    simp only [limits.equalizer.lift_ι, category.id_comp, category.assoc],
    simp only [← F.map_comp, ← op_comp],
    erw [← h₂, op_comp, F.map_comp],
    dsimp [e₂],
    erw ← limits.equalizer.condition_assoc,
    change _ ≫ F.map e₁.op ≫ F.map t.op = _,
    rw [← F.map_comp, ← op_comp, h₁],
    simp }
end

lemma equalizer_condition_for_types_holds (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) :
  equalizer_condition_for_types F :=
begin
  -- Should be fairly easy, just mimic the proof in the general case above.
   intros R X B f hf g hg,
  dsimp,
  let e₁ : R ⟶ X := ⟨g ≫ Profinite.pullback.fst _ _⟩,
  let e₂ : R ⟶ X := ⟨g ≫ Profinite.pullback.snd _ _⟩,
  have w : e₁ ≫ f = e₂ ≫ f := begin
    dsimp [e₁,e₂],
    apply ExtrDisc.hom.ext,
    simp [category.assoc, Profinite.pullback.condition],
  end,
  have h : F.map f.op ≫ F.map e₁.op = F.map f.op ≫ F.map e₂.op :=
  by { simp only [← F.map_comp, ← op_comp, w] },
  let E := { x : F.obj (op X) // F.map e₁.op x = F.map e₂.op x },
  let t : F.obj (op B) → E := λ x, ⟨F.map f.op x, begin
    change (F.map f.op ≫ F.map e₁.op) x = (F.map f.op ≫ F.map e₂.op) x,
    rw h,
  end⟩,
  change function.bijective t,
  let ee := limits.concrete.equalizer_equiv (F.map e₁.op) (F.map e₂.op),
  suffices : function.bijective (ee.symm ∘ t),
    by exact (equiv.comp_bijective t (equiv.symm ee)).mp this,
  have : ee.symm ∘ t = limits.equalizer.lift _ h,
  { suffices : t = ee ∘ limits.equalizer.lift _ h,
    { rw this, ext, simp, },
    ext,
    apply subtype.ext,
    change _ = (limits.equalizer.lift _ h ≫ limits.equalizer.ι _ _) _,
    rw limits.equalizer.lift_ι,
    refl },
  rw this,
  rw ← is_iso_iff_bijective,
  apply equalizer_condition_holds,
  assumption'
end

end ExtrDisc

namespace Profinite

lemma exists_projective_presentation (B : Profinite.{u}) :
  ∃ (X : ExtrDisc) (π : X.val ⟶ B), function.surjective π :=
begin
  obtain ⟨⟨X,h,π,hπ⟩⟩ := enough_projectives.presentation B,
  resetI,
  use [⟨X⟩, π],
  rwa ← epi_iff_surjective
end

def pres (B : Profinite.{u}) : ExtrDisc :=
  B.exists_projective_presentation.some

def pres_π (B : Profinite.{u}) : B.pres.val ⟶ B :=
  B.exists_projective_presentation.some_spec.some

lemma pres_π_surjective (B : Profinite.{u}) :
  function.surjective B.pres_π :=
B.exists_projective_presentation.some_spec.some_spec

end Profinite

open opposite

def is_ExtrSheaf_of_types (P : ExtrDisc.{u}ᵒᵖ ⥤ Type w) : Prop :=
∀ (B : ExtrDisc.{u}) (ι : Type u) [fintype ι] (α : ι → ExtrDisc.{u})
  (f : Π i, α i ⟶ B) (hf : ∀ b : B, ∃ i (x : α i), f i x = b)
  (x : Π i, P.obj (op (α i)))
  (hx : ∀ (i j : ι) (Z : ExtrDisc) (g₁ : Z ⟶ α i) (g₂ : Z ⟶ α j),
    g₁ ≫ f _ = g₂ ≫ f _ → P.map g₁.op (x _) = P.map g₂.op (x _)),
∃! t : P.obj (op B), ∀ i, P.map (f i).op t = x _

lemma subsingleton_of_empty_of_is_ExtrSheaf_of_types
  (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) (hF : is_ExtrSheaf_of_types F) (Z : ExtrDisc)
  [hZ : is_empty Z] : subsingleton (F.obj (op Z)) :=
begin
  constructor,
  intros a b,
  specialize hF Z pempty pempty.elim (λ a, a.elim) hZ.elim (λ a, a.elim) (λ a, a.elim),
  obtain ⟨t,h1,h2⟩ := hF,
  have : a = t, { apply h2, intros i, exact i.elim },
  have : b = t, { apply h2, intros i, exact i.elim },
  cc,
end

lemma finite_product_condition_for_types_of_is_ExtrSheaf_of_types
  (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) (hF : is_ExtrSheaf_of_types F) :
    ExtrDisc.finite_product_condition_for_types F :=
begin
  introsI ι _ X,
  have hF' := hF,
  dsimp,
  specialize hF (ExtrDisc.sigma X) ι X (ExtrDisc.sigma.ι _)
    (ExtrDisc.sigma.ι_jointly_surjective _),
  split,
  { intros x y hh,
    dsimp at hh,
    have hx := hF (λ i, F.map (ExtrDisc.sigma.ι X i).op x) _,
    swap,
    { intros i j Z g₁ g₂ hh,
      dsimp,
      change (F.map _ ≫ F.map _) _ = (F.map _ ≫ F.map _) _,
      simp only [← F.map_comp, ← op_comp],
      rw hh },
    have hy := hF (λ i, F.map (ExtrDisc.sigma.ι X i).op y) _,
    swap,
    { intros i j Z g₁ g₂ hh,
      dsimp,
      change (F.map _ ≫ F.map _) _ = (F.map _ ≫ F.map _) _,
      simp only [← F.map_comp, ← op_comp],
      rw hh },
    obtain ⟨tx,htx1,htx2⟩ := hx,
    obtain ⟨ty,hty1,hty2⟩ := hy,
    have : x = tx,
    { apply htx2,
      intros i,
      refl },
    rw this,
    symmetry,
    apply htx2,
    intros i,
    apply_fun (λ e, e i) at hh,
    exact hh.symm },
  { intros x,
    have hx := hF x _,
    swap,
    { intros i j Z g₁ g₂ hh,
      by_cases hZ : nonempty Z,
      { obtain ⟨z⟩ := hZ,
        have : i = j,
        { apply_fun (λ e, (e z).1) at hh, exact hh },
        subst this,
        have : g₁ = g₂,
        { ext t : 2,
          apply_fun ExtrDisc.sigma.ι X i,
          swap,
          { apply Profinite.sigma.ι_injective },
          apply_fun (λ e, e t) at hh,
          exact hh },
        rw this },
      { simp at hZ, resetI,
        haveI := subsingleton_of_empty_of_is_ExtrSheaf_of_types F hF' Z,
        apply subsingleton.elim } },
    obtain ⟨t,ht,_⟩ := hx,
    use t,
    ext1,
    apply ht }
end

theorem is_ExtrSheaf_of_types_of_finite_product_condition_for_types
  (F : ExtrDisc.{u}ᵒᵖ ⥤ Type w) (hF : ExtrDisc.finite_product_condition_for_types F) :
  is_ExtrSheaf_of_types F :=
begin
  sorry
end
