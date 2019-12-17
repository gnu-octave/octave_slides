#include <iostream>
#include <octave/oct.h>
#include <octave/octave.h>
#include <octave/parse.h>
#include <octave/interpreter.h>

int
main (void)
{
  octave::interpreter interpreter;

  try
    {
      int status = interpreter.execute ();
      if (status != 0)
        {
          std::cerr << "Error occurred!" << std::endl;
          return status;
        }

      octave_value_list out = octave::feval ("gcd", ovl (10, 15), 1);

      if (out.length () > 0)
        std::cout << "GCD of ["
                  << in(0).int_value ()
                  << ", "
                  << in(1).int_value ()
                  << "] is " << out(0).int_value ()
                  << std::endl;
      else
        std::cout << "invalid\n";
    }
  catch (const octave::exit_exception& ex)
    {
      std::cerr << "Octave interpreter exited with status = "
                << ex.exit_status () << std::endl;
    }
  catch (const octave::execution_exception&)
    {
      std::cerr << "error encountered in Octave evaluator!" << std::endl;
    }

  return 0;
}
