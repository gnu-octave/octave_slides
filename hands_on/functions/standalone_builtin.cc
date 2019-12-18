#include <iostream>
#include <octave/oct.h>
#include <octave/builtin-defun-decls.h>

int main () {
  int n = 2;
  Matrix A = Matrix (n, n);

  // Fill matrix
  for (octave_idx_type i = 0; i < n; i++) {
    for (octave_idx_type j = 0; j < n; j++) {
      A(i,j) = (i + 1) * 10 + (j + 1);
    }
  }

  // Compute matrix norm
  octave_value_list out = Fnorm (ovl (A), 1);

  // Output results
  std::cout << "Matrix A:"            << std::endl
            << A                      << std::endl
            << "norm (A) = "
            << out(0).double_value () << std::endl;

  return 0;
}
