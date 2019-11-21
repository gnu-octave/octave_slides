#include <octave/oct.h>
#include <octave/f77-fcn.h>

extern "C"
{
  F77_RET_T
  F77_FUNC (dgesv, DGESV) (const F77_INT&  /* N    */,
                           const F77_INT&  /* NRHS */,
                                 F77_DBLE* /* A    */,
                           const F77_INT&  /* LDA  */,
                                 F77_INT*  /* IPIV */,
                                 F77_DBLE* /* B    */,
                           const F77_INT&  /* LDB  */,
                                 F77_INT&  /* INFO */);
}

DEFUN_DLD (call_dgesv, args, ,
"[X, Afact, IPIV, INFO] = call_dgesv (A, B)\n\
\n\
DGESV computes the solution to a real system of linear equations\n\
    A * X = B,\n\
 where A is an N-by-N matrix and X and B are N-by-NRHS matrices.\n\
\n\
 The LU decomposition with partial pivoting and row interchanges is\n\
 used to factor A as\n\
    A = P * L * U,\n\
 where P is a permutation matrix, L is unit lower triangular, and U is\n\
 upper triangular.  The factored form of A is then used to solve the\n\
 system of equations A * X = B.\n")
{
  if (args.length () != 2)
    print_usage ();

  // Input A to output Afact
  NDArray Afact = args(0).array_value ();
  double* A = Afact.fortran_vec ();
  F77_INT N = Afact.rows ();

  // Input B to output X
  NDArray X = args(1).array_value ();
  double* B = X.fortran_vec ();
  F77_INT NRHS = X.cols ();

  MArray<F77_INT> ipiv (dim_vector (N, 1));
  F77_INT* IPIV = ipiv.fortran_vec ();

  F77_INT INFO = -42;

  F77_XFCN (dgesv, DGESV,
            (N, NRHS, A, N, IPIV, B, N, INFO));

  return ovl (X, Afact, ipiv, INFO);
}
