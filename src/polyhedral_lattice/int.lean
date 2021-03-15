import polyhedral_lattice.basic

noncomputable theory

open_locale big_operators

-- move this
lemma int.norm_coe_units (e : units ℤ) : ∥(e : ℤ)∥ = 1 :=
begin
  obtain (rfl|rfl) := int.units_eq_one_or e;
  simp only [units.coe_neg_one, units.coe_one, norm_neg, norm_one_class.norm_one]
end

--move this
@[simp]
lemma int.units_univ : (finset.univ : finset (units ℤ)) = {1, -1} := rfl

lemma int.sum_units_to_nat_aux : ∀ (n : ℤ), n.to_nat • 1 + -((-n).to_nat • 1) = n
| (0 : ℕ)   := rfl
| (n+1 : ℕ) := show ((n+1) • 1 + -(0 • 1) : ℤ) = _,
begin
  simp only [add_zero, mul_one, int.coe_nat_zero, add_left_inj, algebra.smul_def'', zero_mul,
    int.coe_nat_inj', int.coe_nat_succ, ring_hom.eq_nat_cast, int.nat_cast_eq_coe_nat, neg_zero],
end
| -[1+ n]   :=
begin
  show (0 • 1 + -((n+1) • 1) : ℤ) = _,
  simp only [mul_one, int.coe_nat_zero, algebra.smul_def'', zero_mul, int.coe_nat_succ, zero_add,
    ring_hom.eq_nat_cast, int.nat_cast_eq_coe_nat],
  refl
end

lemma int.sum_units_to_nat (n : ℤ) :
  ∑ (i : units ℤ), int.to_nat (i * n) • (i : ℤ) = n :=
begin
  simp only [int.units_univ],
  -- simp makes no further progress :head bandage: :scream: :shock: :see no evil:
  show (1 * n).to_nat • 1 + (((-1) * n).to_nat • -1 + 0) = n,
  simp only [neg_mul_eq_neg_mul_symm, add_zero, one_mul, smul_neg],
  exact int.sum_units_to_nat_aux n
end

@[simp] lemma int.norm_coe_nat (n : ℕ) : ∥(n : ℤ)∥ = n :=
real.norm_coe_nat _

lemma give_better_name : ∀ (n : ℤ), ∥n∥ = ↑(n.to_nat) + ↑((-n).to_nat)
| (0 : ℕ)   := by simp only [add_zero, norm_zero, int.coe_nat_zero, nat.cast_zero, int.to_nat_zero, neg_zero]
| (n+1 : ℕ) := show ∥(↑(n+1):ℤ)∥ = n+1 + 0, by rw [add_zero, int.norm_coe_nat, nat.cast_succ]
| -[1+ n]   := show ∥-↑(n+1:ℕ)∥ = 0 + (n+1), by rw [zero_add, norm_neg, int.norm_coe_nat, nat.cast_succ]

instance int.polyhedral_lattice : polyhedral_lattice ℤ :=
{ fg := by convert module.finite.self _,
  tf := λ m hm n h,
  begin
    rw [← nsmul_eq_smul, nsmul_eq_mul, mul_eq_zero] at h,
    simpa only [hm, int.coe_nat_eq_zero, or_false, int.nat_cast_eq_coe_nat] using h
  end,
  rational :=
  begin
    intro n, refine ⟨abs n, _⟩,
    simpa only [rat.cast_abs, rat.cast_coe_int] using rfl
  end,
  polyhedral :=
  begin
    refine ⟨units ℤ, infer_instance, coe, _⟩,
    intro n,
    refine ⟨1, zero_lt_one, (λ e, int.to_nat (e * n)), _, _⟩,
    { rw [int.sum_units_to_nat, one_smul] },
    { simp only [int.norm_coe_units, mul_one, nat.cast_one, one_mul, int.units_univ],
      show ∥n∥ = ((1 * n).to_nat) + (↑(((-1) * n).to_nat) + 0),
      simp only [neg_mul_eq_neg_mul_symm, add_zero, one_mul],
      exact give_better_name n }
  end }
