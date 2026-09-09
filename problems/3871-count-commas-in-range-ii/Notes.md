**NOTES**

## Key insight: tiers

Group numbers by how many commas they contain:

| Tier k | Range | Commas per number |
|--------|-------|-------------------|
| 0 | 1 – 999 | 0 |
| 1 | 1,000 – 999,999 | 1 |
| 2 | 1,000,000 – 999,999,999 | 2 |
| 3 | 1,000,000,000 – 999,999,999,999 | 3 |
| 4 | 1,000,000,000,000 – 999,999,999,999,999 | 4 |
| 5 | 1,000,000,000,000,000 (= 10^15) | 5 |

Tier k starts at `10^(3k)` and ends at `10^(3(k+1)) - 1`.
Size of a full tier k = `10^(3k) × 999`.

---

## f(n) — total commas in [1, n]

Let `k = tier(n)` (the number of commas in n). Then:

```
f(n) = (sum of all full tiers 1..k-1) + (partial contribution of tier k)

     = Σ_{j=1}^{k-1} [ j × 999 × 10^(3j) ]   +   k × (n − 10^(3k) + 1)
```

Notice the pattern in the partial tier term — the subtracted constant is always `10^(3k) - 1`:

| Tier k | Partial contribution |
|--------|----------------------|
| 1 | `1 × (n − 999)` |
| 2 | `2 × (n − 999,999)` |
| 3 | `3 × (n − 999,999,999)` |
| 4 | `4 × (n − 999,999,999,999)` |

**Tier 1 worked example:**

`f(1,002) = 1 × (1,002 − 1,000 + 1) = 3` ✓ (matches example)

`f(999,999) = 1 × (999,999 − 1,000 + 1) = 999,000` — the entire tier 1, all 999,000 numbers contribute exactly 1 comma each. This is also the value subtracted from tier-2+ calculations.

**Tier 2 worked example:**

`f(1,000,000)`:
- Full tier 1: `1 × 999 × 1,000 = 999,000`
- Partial tier 2: `2 × (1,000,000 − 1,000,000 + 1) = 2`
- Total = **999,002**

`f(2,000,000)`:
- Full tier 1: `999,000`
- Partial tier 2: `2 × (2,000,000 − 1,000,000 + 1) = 2,000,002`
- Total = **2,999,002**

---

## Range query

For a range [lo, hi]: `answer = f(hi) − f(lo − 1)`

---

## Implementation

The solution iterates from the highest tier down to 1. For each tier j it adds `j × count`, where `count` is the number of integers that fall in tier j and are ≤ n. The `min(n, tier_end)` caps the top tier.

```elixir
defp count_commas(n, tier, acc) do
  tier_start = pow1000(tier)
  tier_end   = min(n, pow1000(tier + 1) - 1)
  count_commas(n, tier - 1, acc + tier * (tier_end - tier_start + 1))
end
```

Numbers below 1,000 contribute 0 commas, so the base case returns `acc`.
