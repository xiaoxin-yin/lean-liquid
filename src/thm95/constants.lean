import polyhedral_lattice.category
import breen_deligne.suitable

import facts.nnreal

/-!
# Explicit formulas for the constants in theorem 9.5
-/

noncomputable theory

open_locale nnreal

variables (BD : breen_deligne.package) (c_ c' : ℕ → ℝ≥0)
variables [BD.data.suitable c_] [breen_deligne.package.adept BD c_ c']
variables (r r' : ℝ≥0) [fact (0 < r)] [fact (0 < r')] [fact (r < r')] [fact (r' ≤ 1)]
variables (V : NormedGroup)
variables (Λ : PolyhedralLattice) -- (M : ProFiltPseuNormGrpWithTinv r')
variables (m : ℕ)

namespace system_of_double_complexes
namespace normed_spectral

noncomputable
def ε : Π (m : ℕ) (K : ℝ≥0), ℝ≥0
| 0     K := (2 * K)⁻¹
| (m+1) K := ε m (K * (K * K + 1))

lemma ε_pos : ∀ m K [fact (1 ≤ K)], 0 < ε m K
| 0     K hK := nnreal.inv_pos.mpr (mul_pos zero_lt_two (lt_of_lt_of_le zero_lt_one hK.out))
| (m+1) K hK := by { dsimp [ε], exactI ε_pos m _ }

noncomputable
def k₀ : Π (m : ℕ) (k : ℝ≥0), ℝ≥0
| 0     k := k
| (m+1) k := k₀ m (k * k * k)

instance one_le_k₀ : ∀ m k [fact (1 ≤ k)], fact (1 ≤ k₀ m k)
| 0     k hk := hk
| (m+1) k hk := by { dsimp [k₀], exactI one_le_k₀ m _ }

noncomputable
def K₀ : Π (m : ℕ) (K : ℝ≥0), ℝ≥0
| 0     K := K
| (m+1) K := K₀ m (K * (K * K + 1))

instance one_le_K₀ : ∀ m K [fact (1 ≤ K)], fact (1 ≤ K₀ m K)
| 0     K hK := hK
| (m+1) K hK := by { dsimp [K₀], exactI one_le_K₀ m _ }

end normed_spectral
end system_of_double_complexes

namespace thm95

namespace universal_constants

open system_of_double_complexes breen_deligne

-- this should be a constant roughly determined by `combinatorial_lemma.lean` (`lem98`)
-- it should probably also depend on an `N : ℕ`
def c₀ (Λ : PolyhedralLattice) : ℝ≥0 :=
sorry

def k₁ : ℕ → ℝ≥0
| 0     := 2 -- should be anything > 1
| (m+1) := sorry

instance one_le_k₁ : ∀ m, fact (1 ≤ k₁ m)
| 0     := ⟨one_le_two⟩
| (m+1) := sorry

def K₁ : ℕ → ℝ≥0
| 0     := 2 -- should be anything > 1, probably
| (m+1) := sorry

instance one_le_K₁ : ∀ m, fact (1 ≤ K₁ m)
| 0     := ⟨one_le_two⟩
| (m+1) := sorry

-- === jmc: I'm not completely convinced that the next three abbreviations are correct
-- === maybe we should pass an `m-1` around somewhere...

/-- `k₀ m` is the constant `k₀ m (k m)` used in the proof of `normed_spectral` -/
abbreviation k₀ : ℝ≥0 := normed_spectral.k₀ m (k₁ m)

/-- `K₀ m` is the constant `K₀ m (K m)` used in the proof of `normed_spectral` -/
abbreviation K₀ : ℝ≥0 := normed_spectral.K₀ m (K₁ m)

/-- `ε m` is the constant `ε m (K m)` used in the proof of `normed_spectral` -/
abbreviation ε : ℝ≥0 := normed_spectral.ε m (K₁ m)

instance ε_pos : fact (0 < ε m) := ⟨normed_spectral.ε_pos _ _⟩

/-- `k' c' m` is the maximum of `k₀ m` and the constants `c' 0`, `c' 1`, ..., `c' m`, `c' (m+1)` -/
def k' : ℝ≥0 := max (k₀ m) $ (finset.range (m+2)).sup c'

lemma c'_le_k' {i : ℕ} (hi : i ≤ m+1) : c' i ≤ k' c' m :=
le_max_iff.mpr $ or.inr $ finset.le_sup $ finset.mem_range.mpr $ nat.lt_succ_iff.mpr hi

instance one_le_k' : fact (1 ≤ k' c' m) :=
⟨le_trans (fact.out _) $ le_max_left _ _⟩

instance k₀_le_k' : fact (normed_spectral.k₀ m (k₁ m) ≤ k' c' m) := ⟨le_max_left _ _⟩

-- in the PDF `b` is *positive*, we might need to make that explicit
lemma b_exists : ∃ b : ℕ, 2 * (k' c' m) * (r / r') ^ b ≤ (ε m) :=
begin
  have : 0 < 2 * (k' c' m) := mul_pos zero_lt_two (fact.out _),
  simp only [nnreal.mul_le_iff_le_inv this.ne'],
  have h₁ : 0 < ((2 * k' c' m)⁻¹ * ε m : ℝ),
  { refine mul_pos (inv_pos.mpr this) _,
    rw [nnreal.coe_pos],
    exact fact.out _ },
  have h₂ : (r / r' : ℝ) < 1,
  { rw div_lt_iff,
    { rw [one_mul, nnreal.coe_lt_coe], exact fact.out _ },
    { rw [nnreal.coe_pos], exact fact.out _ } },
  obtain ⟨b, hb⟩ := exists_pow_lt_of_lt_one h₁ h₂,
  use b,
  exact_mod_cast hb.le,
end

/-- `b c_ r r' m` is the smallest `b` such that `2 * (k' c' m) * (r / r') ^ b ≤ (ε m)` -/
def b : ℕ := nat.find (b_exists c_ r r' m)

lemma N₂_exists : ∃ N₂ : ℕ, (k' c' m) / (2 ^ N₂) ≤ r' ^ (b c_ r r' m) :=
begin
  suffices : ∃ N₂ : ℕ, ((2⁻¹ : ℝ≥0) ^ N₂ : ℝ) < (k' c' m)⁻¹ * r' ^ (b c_ r r' m),
  { rcases this with ⟨N₂, h⟩,
    use N₂,
    rw [← div_lt_iff', ← nnreal.coe_pow, inv_pow', nnreal.coe_inv, inv_div_left, mul_inv',
      inv_inv', ← div_eq_mul_inv] at h,
    { exact_mod_cast h.le },
    { rw [inv_pos, nnreal.coe_pos], exact fact.out _ } },
  refine exists_pow_lt_of_lt_one (mul_pos _ _) _,
  { rw [inv_pos, nnreal.coe_pos], exact fact.out _ },
  { apply pow_pos, rw [nnreal.coe_pos], exact fact.out _ },
  { norm_num }
end

/-
def preal : Type := { a : ℝ≥0 // 0 < a }

instance preal_inhabited : inhabited preal :=
{default := ⟨(1 : ℝ≥0), zero_lt_one⟩}

instance : ordered_comm_group (units ℝ≥0) := by apply_instance

lemma preal.div_le_div_left {a b c : ℝ≥0} (a0 : 0 < a) (b0 : 0 < b) (c0 : 0 < c) :
  a / b ≤ a / c ↔ c ≤ b :=
by rw [nnreal.div_le_iff b0.ne.symm, div_mul_eq_mul_div, nnreal.le_div_iff_mul_le c0.ne.symm,
    mul_le_mul_left a0]
-/


lemma preal.div_le_div_left_of_le {a b c : ℝ≥0} (b0 : 0 < b) (c0 : 0 < c) :
  c ≤ b → a / b ≤ a / c :=
begin
  by_cases a0 : a = 0,
  { exact λ _, by rw [a0, zero_div, zero_div] },
  { have ai : 0 < a := zero_lt_iff.mpr a0,
    cases a with a ha,
    cases b with b hb,
    cases c with c hc,
    have a00 : 0 < a := lt_of_le_of_ne ha (ne_of_lt ai),
    intros cb,
    erw [div_le_div_left a00 b0 c0],
    exact cb }
end

lemma mul_mono {a b c : ℝ≥0} (c00 : 0 < c) (ab : c * a ≤ c * b) : a ≤ b :=
(mul_le_mul_left c00).mp ab

/-- `N₂ c_ r r' m` is the smallest `N₂` such that `N = 2 ^ N₂` satisfies
`(k' c' m) / N ≤ r' ^ (b c_ r r' m)` -/
def N₂ : ℕ := nat.find (N₂_exists c_ c' r r' m)

lemma N₂_le {n : ℕ} (hn : (N₂ c_ c' r r' m) ≤ n) : (k' c' m) / 2 ^ n ≤ r' ^ b c_ r r' m :=
begin
  rw [N₂, nat.find_le_iff] at hn,
  rcases hn with ⟨n0, ni, g⟩,
  refine (preal.div_le_div_left_of_le _ _ (pow_mono one_le_two ni)).trans g;
  exact pow_pos zero_lt_two _,
end

/-- `N c_ r r' m = 2 ^ N₂ c_ r r' m` is the smallest `N` that satisfies
`(k' c' m) / N ≤ r' ^ (b c_ r r' m)` -/
def N : ℕ := 2 ^ N₂ c_ c' r r' m

instance N_pos : fact (0 < N c_ c' r r' m) := ⟨pow_pos zero_lt_two _⟩

--instance : ordered_semiring ℝ≥0 := by apply_instance
/-
lemma N_le {n : ℕ} (hn : (N₂ c_ c' r r' m) ≤ n) :
  (N c_ c' r r' m) = 2 ^ N₂ c_ r r' m ≤ 2 :=
sorry
-/

-- should be doable now
lemma r_pow_b_mul_N_le :
  r ^ (b c_ r r' m) * (N c_ c' r r' m) ≤ (2 / k' c' m) * (r / r') ^ (b c_ r r' m) :=
begin
--  have F : 1 ≤ k' c' m := (universal_constants.one_le_k' c' m).1,
  have k0 : k' c' m ≠ 0 := ne_of_gt (zero_lt_one.trans_le (universal_constants.one_le_k' c' m).1),
  rw [N, mul_comm ((2 : ℝ≥0) / _), div_pow, nat.cast_pow, nat.cast_two, div_mul_eq_mul_div_comm],
  repeat { rw mul_comm (r ^ b c_ r r' m) },
  refine mul_mono_nonneg (zero_le _) _,
  rw [div_div_eq_div_mul, mul_comm, ← div_div_eq_div_mul],
  rw nnreal.le_div_iff_mul_le k0,
  sorry,

  simp [N₂],
  apply congr_arg (λ f, ),
sorry
end

lemma pow_mono_decr_exp {a : ℝ≥0} (m n : ℕ) (mn : m ≤ n) (a1 : a ≤ 1) :
  a ^ n ≤ a ^ m :=
begin
  by_cases a0 : a = 0,
  { rw [a0],
    by_cases mm0 : m = 0,
      simpa [mm0] using pow_le_one _ rfl.le zero_le_one,
    have m0 : 0 < m := zero_lt_iff.mpr mm0,
    rw [zero_pow (m0.trans_le mn), zero_pow m0] },
  rw [← one_div_one_div a, one_div_pow, one_div_pow, nnreal.div_le_iff (one_div_ne_zero _)],
  rcases le_iff_exists_add.mp mn with ⟨k, rfl⟩,
  simp only [one_div, inv_inv'],
  rw [pow_add, mul_inv', ← mul_assoc, mul_inv_cancel, one_mul, ← one_div, nnreal.le_div_iff_mul_le,
    one_mul, ← one_pow k],
  refine pow_le_pow_of_le_left (zero_le a) a1 _,
  repeat { exact pow_ne_zero _ a0 },
end

lemma pow_mono_decr {a b : ℝ≥0} (n : ℕ) (ab : a ≤ b) : a ^ n ≤ b ^ n :=
begin
  exact canonically_ordered_semiring.pow_le_pow_of_le_left ab n,
end

lemma b_le {n : ℕ} (hn : b c' r r' m ≤ n) : 2 * (k' c' m) * (r / r') ^ n ≤ (ε m) :=
begin
  rcases (nat.find_le_iff _ _).mp hn with ⟨n0, ni, g⟩,
  refine le_trans ((mul_le_mul_left _).mpr (pow_mono_decr_exp n0 n ni (le_of_lt _))) g,
  { exact mul_pos zero_lt_two (zero_lt_one.trans_le (universal_constants.one_le_k' c' m).1) },
  { rw [nnreal.div_lt_iff (ne_of_gt _), one_mul];
    exact fact.out _ }
end

-- should be doable now
lemma two_div_k'_mul_r_div_r'_pow_b_le :
  (2 * k' c' m) * (r / r') ^ (b c_ r r' m) ≤ ε m :=
begin
  apply le_trans _ (b_le c' r r' m rfl.le),
  apply le_of_eq,congr,
  sorry
end

-- should be doable now
instance k'_le_two_pow_N : fact (k' c' m ≤ 2 ^ N₂ c_ c' r r' m) :=
sorry

/-- `H BD c_ r r' m` is the universal bound on the norm of the `N₂`th Breen--Deligne homotopy
in the first `m` degrees. Here `N₂ = thm95.N₂ c_ c' r r' m`. -/
def H : ℕ :=
max 1 $ (finset.range (m+1)).sup $ λ q,
  ((BD.data.homotopy_mul BD.homotopy (N₂ c_ c' r r' m)).h q (q + 1)).bound

lemma bound_by_H {q : ℕ} (h : q ≤ m) :
  ((BD.data.homotopy_mul BD.homotopy (N₂ c_ c' r r' m)).h q (q + 1)).bound_by (H BD c_ c' r r' m) :=
begin
  rw [H, universal_map.bound_by, le_max_iff],
  right,
  refine @finset.le_sup _ _ _ (finset.range (m+1))
    (λ q, ((BD.data.homotopy_mul BD.homotopy (N₂ c_ c' r r' m)).h q (q + 1)).bound) _ _,
  rwa [finset.mem_range, nat.lt_succ_iff],
end

instance H_pos : fact (0 < H BD c_ c' r r' m) :=
⟨lt_max_iff.mpr $ or.inl zero_lt_one⟩

instance H_pos' : fact ((0:ℝ≥0) < H BD c_ c' r r' m) :=
by { norm_cast, apply_instance }

def k : ℝ≥0 := k' c' m * k' c' m

instance one_le_k : fact (1 ≤ k c' m) := by { delta k, apply_instance }

def K : ℝ≥0 := 2 * normed_spectral.K₀ m (K₁ m) * H BD c_ c' r r' m

instance one_le_K : fact (1 ≤ K BD c_ c' r r' m) := sorry

instance k_le_k₁ : fact (k c' (m - 1) ≤ k₁ m) := sorry

instance K_le_K₁ : fact (K BD c_ c' r r' (m - 1) ≤ K₁ m) := sorry

end universal_constants

end thm95
