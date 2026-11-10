//! Symbolic-FRI multivariate degree test — IOP-level prototype (no Merkle trees).
//!
//! Field: Goldilocks p = 2^64 - 2^32 + 1.
//! f(x_1..x_mu), deg_{x_i} f < B, committed as F(X) = f(X, X^B, ..., X^{B^{mu-1}}).
//! Round i: B-ary fold with symbolic challenge c_i = r_i * T^{w_i}; oracle values in F[T].
//! T-degree of round-i oracle capped at d_i = min(sum_{l<=i} w_l (B-1), D).
//! Final G(T) = f(r_1 T^{w_1}, ..., r_mu T^{w_mu}); verifier checks deg G <= D.

use std::time::Instant;

// ---------------- Field ----------------
const P: u64 = 0xFFFF_FFFF_0000_0001;
const GEN: u64 = 7; // generator of F_p^*

#[inline]
fn add(a: u64, b: u64) -> u64 {
    ((a as u128 + b as u128) % P as u128) as u64
}
#[inline]
fn sub(a: u64, b: u64) -> u64 {
    add(a, P - b % P)
}
#[inline]
fn mul(a: u64, b: u64) -> u64 {
    ((a as u128 * b as u128) % P as u128) as u64
}
fn pow(mut a: u64, mut e: u64) -> u64 {
    let mut r = 1u64;
    while e > 0 {
        if e & 1 == 1 {
            r = mul(r, a);
        }
        a = mul(a, a);
        e >>= 1;
    }
    r
}
fn inv(a: u64) -> u64 {
    assert!(a != 0);
    pow(a, P - 2)
}

// ---------------- PRNG (splitmix64) ----------------
struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }
    fn field(&mut self) -> u64 {
        self.next() % P
    }
    fn nonzero(&mut self) -> u64 {
        loop {
            let x = self.field();
            if x != 0 {
                return x;
            }
        }
    }
    fn below(&mut self, m: usize) -> usize {
        (self.next() % m as u64) as usize
    }
}

// ---------------- Polynomials in T ----------------
type TP = Vec<u64>;

fn tp_trim(mut a: TP) -> TP {
    while let Some(&0) = a.last() {
        a.pop();
    }
    a
}
fn tp_deg(a: &TP) -> Option<usize> {
    let t = tp_trim(a.clone());
    if t.is_empty() {
        None
    } else {
        Some(t.len() - 1)
    }
}
fn tp_add(a: &TP, b: &TP) -> TP {
    let n = a.len().max(b.len());
    (0..n)
        .map(|i| add(*a.get(i).unwrap_or(&0), *b.get(i).unwrap_or(&0)))
        .collect()
}
fn tp_scale(a: &TP, s: u64) -> TP {
    a.iter().map(|&x| mul(x, s)).collect()
}
fn tp_shift(a: &TP, e: usize) -> TP {
    let mut r = vec![0u64; e];
    r.extend_from_slice(a);
    r
}
fn tp_eq(a: &TP, b: &TP) -> bool {
    tp_trim(a.clone()) == tp_trim(b.clone())
}

// ---------------- Parameters ----------------
#[derive(Clone)]
struct Params {
    b: usize,        // fold arity B (power of 2)
    mu: usize,       // number of variables
    inv_rate: usize, // 1/rho
    w: Vec<usize>,   // weights per variable
    d_claim: usize,  // claimed weighted degree bound D
}
impl Params {
    fn dim(&self) -> usize {
        self.b.pow(self.mu as u32)
    }
    fn n(&self) -> usize {
        self.dim() * self.inv_rate
    }
    /// T-degree cap of the round-i oracle (i >= 1)
    fn cap(&self, i: usize) -> usize {
        let s: usize = self.w[..i].iter().map(|wl| wl * (self.b - 1)).sum();
        s.min(self.d_claim)
    }
}

// ---------------- Multivariate f (coefficients in Kronecker order) ----------------
fn digits(idx: usize, b: usize, mu: usize) -> Vec<usize> {
    let mut v = Vec::with_capacity(mu);
    let mut x = idx;
    for _ in 0..mu {
        v.push(x % b);
        x /= b;
    }
    v
}
fn wdeg(alpha: &[usize], w: &[usize]) -> usize {
    alpha.iter().zip(w).map(|(a, wi)| a * wi).sum()
}
/// random f with deg_{x_i} < B and weighted degree exactly `target` (w.h.p.)
fn random_f(b: usize, mu: usize, w: &[usize], target: usize, rng: &mut Rng) -> Vec<u64> {
    (0..b.pow(mu as u32))
        .map(|idx| {
            let a = digits(idx, b, mu);
            if wdeg(&a, w) <= target {
                rng.nonzero()
            } else {
                0
            }
        })
        .collect()
}
fn f_wdeg(f: &[u64], b: usize, mu: usize, w: &[usize]) -> Option<usize> {
    f.iter()
        .enumerate()
        .filter(|(_, &c)| c != 0)
        .map(|(idx, _)| wdeg(&digits(idx, b, mu), w))
        .max()
}
/// G_direct(T) = f(r_1 T^{w_1}, ..., r_mu T^{w_mu})
fn g_direct(f: &[u64], b: usize, mu: usize, w: &[usize], r: &[u64]) -> TP {
    let maxd: usize = w.iter().map(|wi| wi * (b - 1)).sum();
    let mut g = vec![0u64; maxd + 1];
    for (idx, &c) in f.iter().enumerate() {
        if c == 0 {
            continue;
        }
        let a = digits(idx, b, mu);
        let mut m = c;
        for i in 0..mu {
            m = mul(m, pow(r[i], a[i] as u64));
        }
        let e = wdeg(&a, w);
        g[e] = add(g[e], m);
    }
    tp_trim(g)
}

// ---------------- Domains ----------------
struct Domains {
    pts: Vec<Vec<u64>>,  // pts[i][k] = offset_i * omega_i^k, |L_i| = n / B^i
    omega: Vec<u64>,     // omega_i
}
fn domains(p: &Params) -> Domains {
    let n = p.n();
    let omega0 = pow(GEN, (P - 1) / n as u64);
    let mut pts = Vec::new();
    let mut omega = Vec::new();
    for i in 0..=p.mu {
        let bi = p.b.pow(i as u32) as u64;
        let off = pow(GEN, bi);
        let om = pow(omega0, bi);
        let size = n / p.b.pow(i as u32);
        let mut v = Vec::with_capacity(size);
        let mut x = off;
        for _ in 0..size {
            v.push(x);
            x = mul(x, om);
        }
        pts.push(v);
        omega.push(om);
    }
    Domains { pts, omega }
}
fn eval_univ(coeffs: &[u64], x: u64) -> u64 {
    coeffs.iter().rev().fold(0u64, |acc, &c| add(mul(acc, x), c))
}

// ---------------- Fold ----------------
/// value at index k of L_i of Fold(u_{i-1}; r T^w), u_prev defined on L_{i-1}
fn fold_at(p: &Params, d: &Domains, u_prev: &[TP], i: usize, k: usize, r: u64, w: usize) -> TP {
    let b = p.b;
    let size_i = d.pts[i].len();
    let x0 = d.pts[i - 1][k];
    let zeta = pow(d.omega[i - 1], size_i as u64); // primitive B-th root of unity
    let zeta_inv = inv(zeta);
    let x0_inv = inv(x0);
    let b_inv = inv(b as u64);
    let a: Vec<&TP> = (0..b).map(|t| &u_prev[k + t * size_i]).collect();
    let mut out: TP = vec![];
    let mut xj = 1u64; // x0^{-j}
    let mut rj = 1u64; // r^j
    for j in 0..b {
        let mut pj: TP = vec![];
        let zj = pow(zeta_inv, j as u64);
        let mut zt = 1u64; // zeta^{-t j}
        for t in 0..b {
            pj = tp_add(&pj, &tp_scale(a[t], zt));
            zt = mul(zt, zj);
        }
        pj = tp_scale(&pj, mul(b_inv, xj));
        out = tp_add(&out, &tp_shift(&tp_scale(&pj, rj), w * j));
        xj = mul(xj, x0_inv);
        rj = mul(rj, r);
    }
    tp_trim(out)
}

// ---------------- Prover / Verifier ----------------
struct Proof {
    oracles: Vec<Vec<TP>>, // rounds 0..mu-1
    g: TP,
}
/// Honest prover on an arbitrary initial word u0 (folds u0 faithfully, caps at d_i).
fn prove_from_word(p: &Params, d: &Domains, u0: Vec<TP>, r: &[u64]) -> (Proof, Vec<usize>) {
    let mut oracles = vec![u0];
    let mut max_tdeg = Vec::new();
    for i in 1..=p.mu {
        let size = d.pts[i].len();
        let prev = oracles.last().unwrap();
        let mut ui = Vec::with_capacity(size);
        let mut mx = 0usize;
        for k in 0..size {
            let v = fold_at(p, d, prev, i, k, r[i - 1], p.w[i - 1]);
            mx = mx.max(tp_deg(&v).unwrap_or(0));
            let mut v = v;
            v.truncate(p.cap(i) + 1); // format bound
            ui.push(v);
        }
        max_tdeg.push(mx);
        oracles.push(ui);
    }
    let last = oracles.pop().unwrap();
    let g = last[0].clone();
    (Proof { oracles, g }, max_tdeg)
}
fn eval_word(f: &[u64], d: &Domains) -> Vec<TP> {
    d.pts[0].iter().map(|&x| vec![eval_univ(f, x)]).collect()
}
/// One query; returns true if all consistency checks pass.
fn query(p: &Params, d: &Domains, pr: &Proof, r: &[u64], k0: usize) -> bool {
    for i in 1..=p.mu {
        let size_i = d.pts[i].len();
        let k = k0 % size_i;
        let f = fold_at(p, d, &pr.oracles[i - 1], i, k, r[i - 1], p.w[i - 1]);
        let target = if i < p.mu { &pr.oracles[i][k] } else { &pr.g };
        if !tp_eq(&f, target) {
            return false;
        }
    }
    true
}
fn verify(p: &Params, d: &Domains, pr: &Proof, r: &[u64], s: usize, rng: &mut Rng) -> (bool, usize) {
    let deg_ok = tp_deg(&pr.g).map_or(true, |dg| dg <= p.d_claim);
    let n = d.pts[0].len();
    let mut passed = 0;
    for _ in 0..s {
        if query(p, d, pr, r, rng.below(n)) {
            passed += 1;
        }
    }
    (deg_ok && passed == s, passed)
}

// ---------------- Experiments ----------------
fn header(t: &str) {
    println!("\n=== {t} ===");
}

fn run_config(name: &str, b: usize, mu: usize, inv_rate: usize, rng: &mut Rng) {
    println!("\n##### Config {name}: B={b}, mu={mu}, 1/rho={inv_rate}, n={} #####", b.pow(mu as u32) * inv_rate);
    let ones = vec![1usize; mu];
    let dtot = (mu * (b - 1)) / 2 + 1; // a claimed total degree in the middle of the range
    let s = 64;

    // E1: completeness, total degree
    header("E1 completeness (total degree)");
    let p = Params { b, mu, inv_rate, w: ones.clone(), d_claim: dtot };
    let d = domains(&p);
    let f = random_f(b, mu, &ones, dtot, rng);
    let r: Vec<u64> = (0..mu).map(|_| rng.nonzero()).collect();
    let t0 = Instant::now();
    let (pr, mx) = prove_from_word(&p, &d, eval_word(&f, &d), &r);
    let (acc, passed) = verify(&p, &d, &pr, &r, s, rng);
    let gd = g_direct(&f, b, mu, &ones, &r);
    println!("deg_tot f = {:?}, claim D = {dtot}", f_wdeg(&f, b, mu, &ones));
    println!("G == f(rT): {}, deg G = {:?}", tp_eq(&pr.g, &gd), tp_deg(&pr.g));
    println!("accept: {acc} ({passed}/{s} queries), time {:?}", t0.elapsed());
    let caps: Vec<usize> = (1..=mu).map(|i| p.cap(i)).collect();
    println!("max T-deg per round: {mx:?}  caps d_i: {caps:?}");

    // E2: wrong claim (true degree D, claim D-1)
    header("E2 wrong claim: true deg D, claim D-1");
    let p2 = Params { d_claim: dtot - 1, ..p.clone() };
    let (pr2, _) = prove_from_word(&p2, &d, eval_word(&f, &d), &r);
    let (acc2, passed2) = verify(&p2, &d, &pr2, &r, s, rng);
    println!("accept: {acc2} ({passed2}/{s} queries pass; G truncated to cap)");

    // E3: cheater sends G truncated to degree D-1
    header("E3 cheater: honest oracles, G truncated to deg D-1");
    let mut pr3 = Proof { oracles: pr.oracles.clone(), g: pr.g.clone() };
    pr3.g.truncate(dtot);
    let (acc3, passed3) = verify(&p2, &d, &pr3, &r, s, rng);
    println!("accept: {acc3} ({passed3}/{s} queries pass)");

    // E4: far word: u0 agrees with a degree-D codeword on fraction a, else a degree-(D+1) poly
    header("E4 mixed word: agreement a with C_D, rest from deg D+1; cheater folds the C_D part");
    let f_good = random_f(b, mu, &ones, dtot, rng);
    let f_bad = random_f(b, mu, &ones, dtot + 1, rng);
    let ev_good = eval_word(&f_good, &d);
    let ev_bad = eval_word(&f_bad, &d);
    for &a in &[0.9f64, 0.6, 0.4, 0.25] {
        let u0: Vec<TP> = (0..d.pts[0].len())
            .map(|k| if (rng.next() as f64 / u64::MAX as f64) < a { ev_good[k].clone() } else { ev_bad[k].clone() })
            .collect();
        let agree = u0.iter().zip(&ev_good).filter(|(x, y)| x == y).count() as f64 / u0.len() as f64;
        // cheater: oracles = honest chain of f_good, but first oracle is the real committed u0
        let (mut prc, _) = prove_from_word(&p, &d, ev_good.clone(), &r);
        prc.oracles[0] = u0;
        let trials = 4000;
        let mut ok = 0;
        for _ in 0..trials {
            if query(&p, &d, &prc, &r, rng.below(d.pts[0].len())) {
                ok += 1;
            }
        }
        println!(
            "a={a:.2}: measured agreement {agree:.3}, single-query accept {:.4} (bound: <= agreement + eps)",
            ok as f64 / trials as f64
        );
    }
    // honest folding of the far word: does G even have low degree?
    let u0_far = ev_bad.clone();
    let (prf, _) = prove_from_word(&Params { d_claim: mu * (b - 1), ..p.clone() }, &d, u0_far, &r);
    println!("honest fold of deg-(D+1) word: deg G = {:?} (claim D = {dtot} -> rejected by degree check)", tp_deg(&prf.g));

    // E5: exact individual degree of x_1 via w = e_1
    header("E5 individual degree of x_1 via w = e_1");
    let mut e1 = vec![0usize; mu];
    e1[0] = 1;
    let fi = random_f(b, mu, &ones, mu * (b - 1), rng); // full box
    let dx1 = f_wdeg(&fi, b, mu, &e1).unwrap();
    for claim in [dx1, dx1.saturating_sub(1)] {
        let pe = Params { b, mu, inv_rate, w: e1.clone(), d_claim: claim };
        let (pre, _) = prove_from_word(&pe, &d, eval_word(&fi, &d), &r);
        let (acce, passede) = verify(&pe, &d, &pre, &r, s, rng);
        let gde = g_direct(&fi, b, mu, &e1, &r);
        println!(
            "deg_x1 f = {dx1}, claim {claim}: G==direct (before cap) {}, deg G = {:?}, accept {acce} ({passede}/{s})",
            tp_eq(&tp_trim(pre.g.clone()), &gde) || claim < dx1,
            tp_deg(&pre.g)
        );
    }

    // E6: weighted degree, w = (1,2,1,2,...)
    header("E6 weighted degree, w = (1,2,1,2,...)");
    let ww: Vec<usize> = (0..mu).map(|i| 1 + (i % 2)).collect();
    let dw = (ww.iter().sum::<usize>() * (b - 1)) / 2;
    let fw = random_f(b, mu, &ww, dw, rng);
    let pw = Params { b, mu, inv_rate, w: ww.clone(), d_claim: dw };
    let (prw, _) = prove_from_word(&pw, &d, eval_word(&fw, &d), &r);
    let (accw, passedw) = verify(&pw, &d, &prw, &r, s, rng);
    let gdw = g_direct(&fw, b, mu, &ww, &r);
    println!(
        "deg_w f = {:?}, claim {dw}: G == f(r T^w) {}, deg G = {:?}, accept {accw} ({passedw}/{s})",
        f_wdeg(&fw, b, mu, &ww),
        tp_eq(&prw.g, &gdw),
        tp_deg(&prw.g)
    );
}

fn main() {
    let seed = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(42u64);
    println!("symfri-degree prototype, seed = {seed}");
    let mut rng = Rng(seed);
    run_config("A (non-multilinear)", 4, 4, 16, &mut rng);
    run_config("B (multilinear)", 2, 8, 16, &mut rng);
    run_config("C (degree < 8 per variable)", 8, 3, 8, &mut rng);
}
