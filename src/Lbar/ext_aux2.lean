import Lbar.ext_aux1

noncomputable theory

universes v u u'

open opposite category_theory category_theory.limits category_theory.preadditive
open_locale nnreal zero_object

variables (r r' : ℝ≥0)
variables [fact (0 < r)] [fact (r < r')] [fact (r < 1)]

section

open bounded_homotopy_category

variables (BD : breen_deligne.data)
variables (κ κ₂ : ℝ≥0 → ℕ → ℝ≥0)
variables [∀ (c : ℝ≥0), BD.suitable (κ c)] [∀ n, fact (monotone (function.swap κ n))]
variables [∀ (c : ℝ≥0), BD.suitable (κ₂ c)] [∀ n, fact (monotone (function.swap κ₂ n))]
variables (M : ProFiltPseuNormGrpWithTinv₁.{u} r')
variables (V : SemiNormedGroup.{u}) [complete_space V] [separated_space V]

set_option pp.universes true

-- jmc: is this helpful??
-- @[reassoc]
-- def preadditive_yoneda_obj_obj_CondensedSet_to_Condensed_Ab_natural
--   (M : Condensed.{u} Ab.{u+1}) (X Y : Profinite) (f : X ⟶ Y) :
--   (preadditive_yoneda_obj_obj_CondensedSet_to_Condensed_Ab M Y).hom ≫ M.val.map f.op =
--   ((preadditive_yoneda.obj M).map (CondensedSet_to_Condensed_Ab.map $ Profinite_to_Condensed.map f).op) ≫
--    (preadditive_yoneda_obj_obj_CondensedSet_to_Condensed_Ab M X).hom :=
-- by admit

lemma QprimeFP_map (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) :
  (QprimeFP r' BD κ M).map h = of'_hom ((QprimeFP_int r' BD κ _).map h) := rfl

variables [fact (0 < r')] [fact (r' < 1)]

namespace ExtQprime_iso_aux_system_obj_naturality_setup

/-
lemma aux₁ (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) :
homological_complex.unop_functor.{u+2 u+1 0}.map
    (((preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
         forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
           AddCommGroup.{u+1}).right_op.map_homological_complex
        (complex_shape.up.{0} ℤ)).map
       ((homological_complex.embed.{0 0 u+2 u+1} complex_shape.embedding.nat_down_int_up).map
          ((QprimeFP_nat.{u} r' BD κ M).map h))).op ≫
  homological_complex.unop_functor.{u+2 u+1 0}.map
      ((map_homological_complex_embed.{u+2 u+2 u+1 u+1}
          (preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
             forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
               AddCommGroup.{u+1}).right_op).inv.app
         ((QprimeFP_nat.{u} r' BD κ M).obj c₁)).op ≫
    embed_unop.{u+2 u+1}.hom.app
      (op.{u+3}
         (((preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
              forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
                Ab.{u+1}).right_op.map_homological_complex
             (complex_shape.down.{0} ℕ)).obj
            ((QprimeFP_nat.{u} r' BD κ M).obj c₁))) =
  begin
    dsimp,
    let e := (QprimeFP_nat r' BD κ M).map h,
    let e₁ := ((preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
      forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
      Ab.{u+1}).right_op.map_homological_complex
      (complex_shape.down.{0} ℕ)).map e,
    let e₂ := homological_complex.unop_functor.map e₁.op,
    refine _ ≫
      (homological_complex.embed.{0 0 u+2 u+1} complex_shape.embedding.nat_up_int_down).map
      e₂,
    refine homological_complex.unop_functor.{u+2 u+1 0}.map
    ((map_homological_complex_embed.{u+2 u+2 u+1 u+1}
        (preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
           forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
             AddCommGroup.{u+1}).right_op).inv.app
       ((QprimeFP_nat.{u} r' BD κ M).obj c₂)).op ≫
    embed_unop.{u+2 u+1}.hom.app
    (op.{u+3}
       (((preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
            forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
              Ab.{u+1}).right_op.map_homological_complex
           (complex_shape.down.{0} ℕ)).obj
          ((QprimeFP_nat.{u} r' BD κ M).obj c₂)))
  end := admit

def F : ℝ≥0 ⥤
  (homological_complex.{u+1 u+2 0} AddCommGroup.{u+1} (complex_shape.down.{0} ℕ).symm)ᵒᵖ :=
QprimeFP_nat.{u} r' BD κ M ⋙
  (preadditive_yoneda_obj.{u+1 u+2} V.to_Cond ⋙
     forget₂.{u+2 u+2 u+1 u+1 u+1} (Module.{u+1 u+1} (End.{u+1 u+2} V.to_Cond))
       AddCommGroup.{u+1}).right_op.map_homological_complex
    (complex_shape.down.{0} ℕ) ⋙ homological_complex.unop_functor.right_op

def homological_complex.map_unop {A M : Type*} [category A] [abelian A]
  {c : complex_shape M} (C₁ C₂ : homological_complex Aᵒᵖ c) (f : C₁ ⟶ C₂) :
  C₂.unop ⟶ C₁.unop :=
homological_complex.unop_functor.map f.op

@[reassoc]
lemma naturality_helper {c₁ c₂ : ℝ≥0} (h : c₁ ⟶ c₂) (n : ℕ) (w1 w2) :
  (homological_complex.homology_embed_nat_iso.{0 0 u+2 u+1} Ab.{u+1} complex_shape.embedding.nat_up_int_down
   nat_up_int_down_c_iff n (-↑n) w1).hom.app
    (((preadditive_yoneda.{u+1 u+2}.obj
    V.to_Cond).right_op.map_homological_complex (complex_shape.down.{0} ℕ)).obj
     ((QprimeFP_nat.{u} r' BD κ M).obj c₂)).unop ≫
     (homology_functor _ _ _).map
     (homological_complex.map_unop _ _ $
     category_theory.functor.map _ $ category_theory.functor.map _ h) =
  category_theory.functor.map _
  (homological_complex.map_unop _ _ $
    category_theory.functor.map _ $ category_theory.functor.map _ h) ≫
    (homological_complex.homology_embed_nat_iso.{0 0 u+2 u+1} Ab.{u+1} complex_shape.embedding.nat_up_int_down
  nat_up_int_down_c_iff n (-↑n) w2).hom.app
    (((preadditive_yoneda.{u+1 u+2}.obj
    V.to_Cond).right_op.map_homological_complex (complex_shape.down.{0} ℕ)).obj
    ((QprimeFP_nat.{u} r' BD κ M).obj c₁)).unop :=
admit
-/

lemma aux₁ (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) (n : ℕ) :
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℕ) n).map
  (hom_complex_QprimeFP_nat_iso_aux_system.{u} r' BD κ M V c₂).hom ≫
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℕ) n).map
  ((aux_system.{u u+1} r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1 u}.obj V) κ).to_Ab.map h.op) =
  (homology_functor _ _ _).map
  (category_theory.functor.map _
      (homological_complex.op_functor.map ((QprimeFP_nat r' BD κ M).map h).op)) ≫
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℕ) n).map
  (hom_complex_QprimeFP_nat_iso_aux_system.{u} r' BD κ M V c₁).hom :=
sorry

lemma aux₂ (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) (n : ℕ) :
  (homological_complex.homology_embed_nat_iso.{0 0 u+2 u+1} Ab.{u+1}
    complex_shape.embedding.nat_up_int_down nat_up_int_down_c_iff n (-↑n) (by { cases n; refl})).hom.app
    (hom_complex_nat.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₂) V.to_Cond) ≫
    (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℕ) n).map
    (((preadditive_yoneda.{u+1 u+2}.obj V.to_Cond).map_homological_complex
    (complex_shape.down.{0} ℕ).symm).map (homological_complex.op_functor.{u+2 u+1 0}.map
    ((QprimeFP_nat.{u} r' BD κ M).map h).op)) =
  (homological_complex.embed.{0 0 u+2 u+1} complex_shape.embedding.nat_up_int_down ⋙
  homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.down.{0} ℤ) (-↑n)).map
  (category_theory.functor.map _
      (homological_complex.op_functor.map ((QprimeFP_nat r' BD κ M).map h).op)) ≫
  (homological_complex.homology_embed_nat_iso.{0 0 u+2 u+1} Ab.{u+1}
  complex_shape.embedding.nat_up_int_down nat_up_int_down_c_iff n (-↑n) (by { cases n; refl})).hom.app
  (hom_complex_nat.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₁) V.to_Cond) :=
sorry

lemma aux₃ (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) (n : ℕ) :
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℤ).symm (-↑n)).map
  (embed_hom_complex_nat_iso.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₂) V.to_Cond).hom ≫
  (homological_complex.embed.{0 0 u+2 u+1} complex_shape.embedding.nat_up_int_down ⋙
  homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.down.{0} ℤ) (-↑n)).map
  (((preadditive_yoneda.{u+1 u+2}.obj V.to_Cond).map_homological_complex
  (complex_shape.down.{0} ℕ).symm).map (homological_complex.op_functor.{u+2 u+1 0}.map
  ((QprimeFP_nat.{u} r' BD κ M).map h).op))
  =
  ((homology_functor.{u+1 u+2 0} AddCommGroup.{u+1}
  (complex_shape.up.{0} ℤ).symm (-↑n)).op.map
  (homological_complex.unop_functor.{u+2 u+1 0}.right_op.map
  (((preadditive_yoneda.{u+1 u+2}.obj V.to_Cond).right_op.map_homological_complex
  (complex_shape.up.{0} ℤ)).map ((QprimeFP_int.{u} r' BD κ M).map h)))).unop ≫
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℤ).symm (-↑n)).map
  (embed_hom_complex_nat_iso.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₁) V.to_Cond).hom
  := sorry
/-
lemma naturality_helper {c₂ : ℝ≥0} (n : ℕ) :
  (homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℤ).symm (-↑n)).map
  (embed_hom_complex_nat_iso.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₂) V.to_Cond).hom ≫
  (homological_complex.homology_embed_nat_iso.{0 0 u+2 u+1} Ab.{u+1}
  complex_shape.embedding.nat_up_int_down nat_up_int_down_c_iff n (-↑n) (by { cases n; refl})).hom.app
  (hom_complex_nat.{u} ((QprimeFP_nat.{u} r' BD κ M).obj c₂) V.to_Cond) =
  _
-/

end ExtQprime_iso_aux_system_obj_naturality_setup

lemma QprimeFP_acyclic (c) (k i : ℤ) (hi : 0 < i) :
  is_zero (((Ext' i).obj (op (((QprimeFP_int.{u} r' BD κ M).obj c).X k))).obj V.to_Cond) :=
begin
  rcases k with ((_|k)|k),
  { apply free_acyclic, exact hi },
  { rw [← functor.flip_obj_obj], refine functor.map_is_zero _ _, refine (is_zero_zero _).op, },
  { apply free_acyclic, exact hi },
end

lemma ExtQprime_iso_aux_system_obj_natrality (c₁ c₂ : ℝ≥0) (h : c₁ ⟶ c₂) (n : ℕ) :
  (ExtQprime_iso_aux_system_obj r' BD κ M V c₂ n).hom ≫
  (homology_functor _ _ _).map
  ((system_of_complexes.to_Ab _).map h.op)  =
  ((Ext n).map ((QprimeFP r' BD κ _).map h).op).app _ ≫
  (ExtQprime_iso_aux_system_obj r' BD κ M V c₁ n).hom :=
begin
  dsimp only [ExtQprime_iso_aux_system_obj,
    iso.trans_hom, id, functor.map_iso_hom],
  haveI : ((homotopy_category.quotient.{u+1 u+2 0}
    (Condensed.{u u+1 u+2} Ab.{u+1}) (complex_shape.up.{0} ℤ)).obj
     ((QprimeFP_int.{u} r' BD κ M).obj c₁)).is_bounded_above :=
    chain_complex.is_bounded_above _,
  haveI : ((homotopy_category.quotient.{u+1 u+2 0}
    (Condensed.{u u+1 u+2} Ab.{u+1}) (complex_shape.up.{0} ℤ)).obj
     ((QprimeFP_int.{u} r' BD κ M).obj c₂)).is_bounded_above :=
    chain_complex.is_bounded_above _,
  have := Ext_compute_with_acyclic_naturality
    ((QprimeFP_int.{u} r' BD κ M).obj c₁)
    ((QprimeFP_int.{u} r' BD κ M).obj c₂)
    V.to_Cond _ _
    ((QprimeFP_int.{u} r' BD κ M).map h) n,
  rotate,
  { intros k i hi, apply QprimeFP_acyclic, exact hi },
  { intros k i hi, apply QprimeFP_acyclic, exact hi },
  dsimp only [functor.comp_map] at this,
  erw reassoc_of this, clear this,
  simp only [category.assoc, nat_iso.app_hom],
  congr' 1,
  rw ExtQprime_iso_aux_system_obj_naturality_setup.aux₁ r' BD κ M V c₁ c₂ h n,
  simp only [← category.assoc], congr' 1,
  simp only [category.assoc],
  rw ExtQprime_iso_aux_system_obj_naturality_setup.aux₂ r' BD κ M V c₁ c₂ h n,
  simp only [← category.assoc], congr' 1,

  exact ExtQprime_iso_aux_system_obj_naturality_setup.aux₃ r' BD κ M V c₁ c₂ h n,

  --- OLD PROOF FROM HERE
  --have := ExtQprime_iso_aux_system_obj_naturality_setup.naturality_helper r' BD κ
  --  M V h n _ _,
  --simp only [category.assoc, functor.map_comp],
  --slice_rhs 3 4
  --{ erw ← this },

  /-
  dsimp only [QprimeFP_int],
  congr' 1,
  dsimp only [nat_iso.app_hom],
  simp only [functor.map_comp, functor.comp_map, nat_trans.naturality,
    nat_trans.naturality_assoc],
  dsimp only [functor.op_map, quiver.hom.unop_op, functor.right_op_map],
  simp only [← functor.map_comp, ← functor.map_comp_assoc, category.assoc],
  dsimp [-homology_functor_map],
  rw ExtQprime_iso_aux_system_obj_naturality_setup.aux₁,
  dsimp [-homology_functor_map],
  simp only [functor.map_comp, functor.map_comp_assoc,
    category.assoc, nat_trans.naturality_assoc],
  congr' 2,
  dsimp [-homology_functor_map],
  dsimp only [← functor.comp_map, ← functor.comp_obj],
  --erw nat_trans.naturality_assoc,
  --refine congr_arg2 _ _ (congr_arg2 _ rfl _),

  --congr' 1,
  --refl,
  sorry

  -/
end

def ExtQprime_iso_aux_system (n : ℕ) :
  (QprimeFP r' BD κ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) ≅
  aux_system r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1}.obj V) κ ⋙
    (forget₂ _ Ab).map_homological_complex _ ⋙ homology_functor _ _ n :=
nat_iso.of_components (λ c, ExtQprime_iso_aux_system_obj r' BD κ M V (unop c) n)
begin
  intros c₁ c₂ h,
  dsimp [-homology_functor_map],
  rw ← ExtQprime_iso_aux_system_obj_natrality,
  refl,
end

/-- The `Tinv` map induced by `M` -/
def ExtQprime.Tinv
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)]
  (n : ℤ) :
  (QprimeFP r' BD κ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) ⟶
  (QprimeFP r' BD κ₂ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) :=
whisker_right (nat_trans.op $ QprimeFP.Tinv BD _ _ M) _

/-- The `T_inv` map induced by `V` -/
def ExtQprime.T_inv [normed_with_aut r V]
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)]
  (n : ℤ) :
  (QprimeFP r' BD κ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) ⟶
  (QprimeFP r' BD κ₂ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) :=
whisker_right (nat_trans.op $ QprimeFP.ι BD _ _ M) _ ≫ whisker_left _ ((Ext n).flip.map $ (single _ _).map $
  (Condensed.of_top_ab_map (normed_with_aut.T.inv).to_add_monoid_hom
  (normed_group_hom.continuous _)))

def ExtQprime.Tinv2 [normed_with_aut r V]
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)]
  (n : ℤ) :
  (QprimeFP r' BD κ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) ⟶
  (QprimeFP r' BD κ₂ M).op ⋙ (Ext n).flip.obj ((single _ 0).obj V.to_Cond) :=
ExtQprime.Tinv r' BD κ κ₂ M V n - ExtQprime.T_inv r r' BD κ κ₂ M V n

lemma ExtQprime_iso_aux_system_comm_Tinv
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)] (n : ℕ) :
  (ExtQprime_iso_aux_system r' BD κ M V n).hom ≫
  whisker_right (aux_system.Tinv.{u} r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1}.obj V) κ₂ κ)
    ((forget₂ _ _).map_homological_complex _ ⋙ homology_functor Ab.{u+1} (complex_shape.up ℕ) n) =
  ExtQprime.Tinv r' BD κ κ₂ M V n ≫
  (ExtQprime_iso_aux_system r' BD κ₂ M V n).hom :=
sorry


-- lemma ExtQprime_iso_aux_system_comm_T_inv [normed_with_aut r V] (n : ℕ) (c : ℝ≥0ᵒᵖ) :
--   (ExtQprime_iso_aux_system_obj.{u} r' BD κ₂ M V (unop.{1} c) n).hom ≫
--     ((forget₂.{u+2 u+2 u+1 u+1 u+1} SemiNormedGroup.{u+1} Ab.{u+1}).map_homological_complex (complex_shape.up.{0} ℕ) ⋙
--    homology_functor.{u+1 u+2 0} Ab.{u+1} (complex_shape.up.{0} ℕ) n).map
--   ((aux_system.res.{u u+1} r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1 u}.obj V) κ₂ κ).app c) =
--   ((Ext.{u+1 u+2} ↑n).flip.map
--       ((single.{u+1 u+2} (Condensed.{u u+1 u+2} Ab.{u+1}) 0).map
--           (Condensed.of_top_ab_map.{u} (normed_group_hom.to_add_monoid_hom.{u u} normed_with_aut.T.{u}.inv) _))).app
--       ((QprimeFP.{u} r' BD κ₂ M).op.obj c) ≫
--     (ExtQprime_iso_aux_system_obj.{u} r' BD κ₂ M V (unop.{1} c) n).hom :=
-- sorry

lemma ExtQprime_iso_aux_system_comm [normed_with_aut r V]
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)] (n : ℕ) :
  (ExtQprime_iso_aux_system r' BD κ M V n).hom ≫
  whisker_right (aux_system.Tinv2.{u} r r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1}.obj V) κ₂ κ)
    ((forget₂ _ _).map_homological_complex _ ⋙ homology_functor Ab.{u+1} (complex_shape.up ℕ) n) =
  ExtQprime.Tinv2 r r' BD κ κ₂ M V n ≫
  (ExtQprime_iso_aux_system r' BD κ₂ M V n).hom :=
begin
  ext c : 2, dsimp only [aux_system.Tinv2, ExtQprime.Tinv2, nat_trans.comp_app, whisker_right_app],
  simp only [sub_comp, nat_trans.app_sub, functor.map_sub, comp_sub],
  refine congr_arg2 _ _ _,
  { rw [← nat_trans.comp_app, ← ExtQprime_iso_aux_system_comm_Tinv], refl },
  rw [nat_trans.comp_app, functor.map_comp, ExtQprime.T_inv,
    nat_trans.comp_app, whisker_right_app, whisker_left_app, category.assoc],
  dsimp only [ExtQprime_iso_aux_system, nat_iso.of_components.hom_app, aux_system,
    aux_system.res, functor.comp_map],
  sorry
end

lemma ExtQprime_iso_aux_system_comm' [normed_with_aut r V]
  [∀ c n, fact (κ₂ c n ≤ κ c n)] [∀ c n, fact (κ₂ c n ≤ r' * κ c n)] (n : ℕ) :
  whisker_right (aux_system.Tinv2.{u} r r' BD ⟨M⟩ (SemiNormedGroup.ulift.{u+1}.obj V) κ₂ κ)
    ((forget₂ _ _).map_homological_complex _ ⋙ homology_functor Ab.{u+1} (complex_shape.up ℕ) n) ≫
  (ExtQprime_iso_aux_system r' BD κ₂ M V n).inv =
  (ExtQprime_iso_aux_system r' BD κ M V n).inv ≫
  ExtQprime.Tinv2 r r' BD κ κ₂ M V n :=
begin
  rw [iso.comp_inv_eq, category.assoc, iso.eq_inv_comp],
  apply ExtQprime_iso_aux_system_comm
end

end

section

def _root_.category_theory.functor.map_commsq
  {C D : Type*} [category C] [abelian C] [category D] [abelian D] (F : C ⥤ D) {X Y Z W : C}
  {f₁ : X ⟶ Y} {g₁ : X ⟶ Z} {g₂ : Y ⟶ W} {f₂ : Z ⟶ W} (sq : commsq f₁ g₁ g₂ f₂) :
  commsq (F.map f₁) (F.map g₁) (F.map g₂) (F.map f₂) :=
commsq.of_eq $ by rw [← F.map_comp, sq.w, F.map_comp]

end

section

variables {r'}
variables (BD : breen_deligne.package)
variables (κ κ₂ : ℝ≥0 → ℕ → ℝ≥0)
variables [∀ (c : ℝ≥0), BD.data.suitable (κ c)] [∀ n, fact (monotone (function.swap κ n))]
variables [∀ (c : ℝ≥0), BD.data.suitable (κ₂ c)] [∀ n, fact (monotone (function.swap κ₂ n))]
variables (M : ProFiltPseuNormGrpWithTinv₁.{u} r')
variables (V : SemiNormedGroup.{u}) [complete_space V] [separated_space V]

open bounded_homotopy_category

-- move me
instance eval'_is_bounded_above :
  ((homotopy_category.quotient (Condensed Ab) (complex_shape.up ℤ)).obj
    ((BD.eval' freeCond').obj M.to_Condensed)).is_bounded_above :=
by { delta breen_deligne.package.eval', refine ⟨⟨1, _⟩⟩, apply chain_complex.bounded_by_one }

variables (ι : ulift.{u+1} ℕ → ℝ≥0) (hι : monotone ι)

def Ext_Tinv2
  {𝓐 : Type*} [category 𝓐] [abelian 𝓐] [enough_projectives 𝓐]
  {A B V : bounded_homotopy_category 𝓐}
  (Tinv : A ⟶ B) (ι : A ⟶ B) (T_inv : V ⟶ V) (i : ℤ) :
  ((Ext i).obj (op B)).obj V ⟶ ((Ext i).obj (op A)).obj V :=
(((Ext i).map Tinv.op).app V - (((Ext i).map ι.op).app V ≫ ((Ext i).obj _).map T_inv))

open category_theory.preadditive

def Ext_Tinv2_commsq
  {𝓐 : Type*} [category 𝓐] [abelian 𝓐] [enough_projectives 𝓐]
  {A₁ B₁ A₂ B₂ V : bounded_homotopy_category 𝓐}
  (Tinv₁ : A₁ ⟶ B₁) (ι₁ : A₁ ⟶ B₁)
  (Tinv₂ : A₂ ⟶ B₂) (ι₂ : A₂ ⟶ B₂)
  (f : A₁ ⟶ A₂) (g : B₁ ⟶ B₂) (sqT : f ≫ Tinv₂ = Tinv₁ ≫ g) (sqι : f ≫ ι₂ = ι₁ ≫ g)
  (T_inv : V ⟶ V) (i : ℤ) :
  commsq
    (((Ext i).map g.op).app V)
    (Ext_Tinv2 Tinv₂ ι₂ T_inv i)
    (Ext_Tinv2 Tinv₁ ι₁ T_inv i)
    (((Ext i).map f.op).app V) :=
commsq.of_eq
begin
  delta Ext_Tinv2,
  simp only [comp_sub, sub_comp, ← nat_trans.comp_app, ← functor.map_comp, ← op_comp, sqT,
    ← nat_trans.naturality, ← nat_trans.naturality_assoc, category.assoc, sqι],
end

open category_theory.preadditive

lemma auux
  {𝓐 : Type*} [category 𝓐] [abelian 𝓐] [enough_projectives 𝓐]
  {A₁ B₁ A₂ B₂ : cochain_complex 𝓐 ℤ}
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj A₁).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj B₁).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj A₂).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj B₂).is_bounded_above]
  {f₁ : A₁ ⟶ B₁} {f₂ : A₂ ⟶ B₂} {α : A₁ ⟶ A₂} {β : B₁ ⟶ B₂}
  (sq1 : commsq f₁ α β f₂) :
  of_hom f₁ ≫ of_hom β = of_hom α ≫ of_hom f₂ :=
begin
  have := sq1.w,
  apply_fun (λ f, (homotopy_category.quotient _ _).map f) at this,
  simp only [functor.map_comp] at this,
  exact this,
end

@[simp] lemma of_hom_id
  {𝓐 : Type*} [category 𝓐] [abelian 𝓐] [enough_projectives 𝓐]
  {A : cochain_complex 𝓐 ℤ}
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj A).is_bounded_above] :
  of_hom (𝟙 A) = 𝟙 _ :=
by { delta of_hom, rw [category_theory.functor.map_id], refl }

lemma Ext_iso_of_bicartesian_of_bicartesian
  {𝓐 : Type*} [category 𝓐] [abelian 𝓐] [enough_projectives 𝓐]
  {A₁ B₁ C A₂ B₂ : cochain_complex 𝓐 ℤ}
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj A₁).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj B₁).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj C).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj A₂).is_bounded_above]
  [((homotopy_category.quotient 𝓐 (complex_shape.up ℤ)).obj B₂).is_bounded_above]
  {f₁ : A₁ ⟶ B₁} {g₁ : B₁ ⟶ C} (w₁ : ∀ n, short_exact (f₁.f n) (g₁.f n))
  {f₂ : A₂ ⟶ B₂} {g₂ : B₂ ⟶ C} (w₂ : ∀ n, short_exact (f₂.f n) (g₂.f n))
  (α : A₁ ⟶ A₂) (β : B₁ ⟶ B₂) (γ : C ⟶ C)
  (ιA : A₁ ⟶ A₂) (ιB : B₁ ⟶ B₂)
  (sq1 : commsq f₁ α β f₂) (sq2 : commsq g₁ β γ g₂)
  (sq1' : commsq f₁ ιA ιB f₂) (sq2' : commsq g₁ ιB (𝟙 _) g₂)
  (V : bounded_homotopy_category 𝓐) (T_inv : V ⟶ V)
  (i : ℤ)
  (H1 : (Ext_Tinv2_commsq (of_hom α) (of_hom ιA) (of_hom β) (of_hom ιB) (of_hom f₁) (of_hom f₂)
    (auux sq1) (auux sq1') T_inv i).bicartesian)
  (H2 : (Ext_Tinv2_commsq (of_hom α) (of_hom ιA) (of_hom β) (of_hom ιB) (of_hom f₁) (of_hom f₂)
    (auux sq1) (auux sq1') T_inv (i+1)).bicartesian) :
  is_iso (Ext_Tinv2 (of_hom γ) (𝟙 _) T_inv (i+1)) :=
begin
  have LES₁ := (((Ext_five_term_exact_seq' _ _ i V w₁).drop 2).pair.cons (Ext_five_term_exact_seq' _ _ (i+1) V w₁)),
  replace LES₁ := (((Ext_five_term_exact_seq' _ _ i V w₁).drop 1).pair.cons LES₁).extract 0 4,
  have LES₂ := (((Ext_five_term_exact_seq' _ _ i V w₂).drop 2).pair.cons (Ext_five_term_exact_seq' _ _ (i+1) V w₂)).extract 0 4,
  replace LES₂ := (((Ext_five_term_exact_seq' _ _ i V w₂).drop 1).pair.cons LES₂).extract 0 4,
  refine iso_of_bicartesian_of_bicartesian LES₂ LES₁ _ _ _ _ H1 H2,
  { apply commsq.of_eq, delta Ext_Tinv2, clear LES₁ LES₂,
    rw [sub_comp, comp_sub, ← functor.flip_obj_map, ← functor.flip_obj_map],
    rw ← Ext_δ_natural i V _ _ _ _ α β γ sq1.w sq2.w w₁ w₂,
    congr' 1,
    rw [← nat_trans.naturality, ← functor.flip_obj_map, category.assoc,
      Ext_δ_natural i V _ _ _ _ ιA ιB (𝟙 _) sq1'.w sq2'.w w₁ w₂],
    simp only [op_id, category_theory.functor.map_id, nat_trans.id_app,
      category.id_comp, of_hom_id, category.comp_id],
    erw [category.id_comp],
    symmetry,
    apply Ext_δ_natural', },
  { apply Ext_Tinv2_commsq,
    { exact auux sq2 },
    { exact auux sq2' }, },
end

end
