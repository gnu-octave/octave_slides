#include <iostream>
#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/interpreter.h>

int main (void) {
  int n = 2;
  Matrix A = Matrix (n, n);

  // Fill matrix
  for (octave_idx_type i = 0; i < n; i++) {
    for (octave_idx_type j = 0; j < n; j++) {
      A(i,j) = (i + 1) * 10 + (j + 1);
    }
  }

  octave::interpreter interpreter;
  octave_value_list out;

  try {
    int status = interpreter.execute ();
    if (status != 0) {
      std::cerr << "An error occurred!" << std::endl;
      return status;
    }

    out = octave::feval ("normest", ovl (A), 1);

  } catch (const octave::exit_exception& ex) {
    std::cerr << "Octave interpreter exited with status = "
              << ex.exit_status () << std::endl;
  } catch (const octave::execution_exception&) {
    std::cerr << "An error encountered in Octave evaluator!" << std::endl;
  }

  // Output results
  std::cout << "Matrix A:"            << std::endl
            << A                      << std::endl
            << "normest (A) = "
            << out(0).double_value () << std::endl;

  return 0;
}
