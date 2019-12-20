#include <iostream>
#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/interpreter.h>

int main (void) {
  Matrix A(2, 2);

  // Fill matrix
  for (auto j = 0; j < A.columns (); j++) {
    for (auto i = 0; i <  A.rows (); i++) {
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
