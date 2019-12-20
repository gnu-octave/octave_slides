#include <iostream>
#include <octave/oct.h>
#include <octave/builtin-defun-decls.h>

int main () {
  Matrix A(2, 2);

  // Fill matrix
  for (auto j = 0; j < A.columns (); j++) {
    for (auto i = 0; i <  A.rows (); i++) {
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
