function residuals(A, b, shifts, x)
  nshifts = size(shifts, 1);
  r = { (b - A * x[:,i] - shifts[i] * x[:,i]) for i = 1 : nshifts };
  return r;
end

cg_tol = 1.0e-6;

n = 10;
A = spdiagm((ones(n-1), 4*ones(n), ones(n-1)), (-1, 0, 1))
b = A * [1:10];
shifts=[1:6];

x = cg_lanczos_shift_seq(A, b, shifts, itmax=10);
r = residuals(A, b, shifts, x);
b_norm = norm(b);
resids = map(norm, r) / b_norm;
@printf("CG_Lanczos: Relative residuals with shifts:");
for resid in resids
  @printf(" %8.1e", resid);
end
@printf("\n");
@test(all(resids .<= cg_tol));
