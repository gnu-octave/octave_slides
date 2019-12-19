#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Install Octave 5.1.0 via Singularity
if ! [ -x "$(command -v singularity)" ]; then
  echo 'Error: singularity is not installed.' >&2
  echo 'See https://sylabs.io/guides/3.5/user-guide/quick_start.html' >&2
  exit 1
fi

OCTAVE_SIF=${SCRIPT_DIR}/gnu_octave_5.1.0.sif

if [ ! -f "${OCTAVE_SIF}" ]; then
  singularity pull library://siko1056/default/gnu_octave:5.1.0
fi

# Check for first time run.
if [ ! -d "$SCRIPT_DIR/bin" ] || [ ! -f "$SCRIPT_DIR/bin/activate" ]; then
  # Create virtual Python environment
  python3 -m venv $SCRIPT_DIR
  source $SCRIPT_DIR/bin/activate

  PYTHON_SITE_DIR=$(python -c "import site; print (site.getsitepackages()[0])")

  # Create Octave start script
  cat <<EOT >> octave
#!/bin/bash

# For octave_kernel in JupyterLab to work.
export SINGULARITY_BIND="${PYTHON_SITE_DIR}/octave_kernel/_make_figures.m:/usr/local/share/octave/5.1.0/m/miscellaneous/_make_figures.m"

export LD_LIBRARY_PATH="/usr/local/lib/octave/5.1.0/:\${LD_LIBRARY_PATH}"
singularity exec ${OCTAVE_SIF} "\${0##*/}" "\$@"
EOT

  chmod u+x octave

  ln -sf octave octave-cli
  ln -sf octave octave-config
  ln -sf octave mkoctfile

  pip install --upgrade pip jupyterlab octave_kernel sympy
fi

source $SCRIPT_DIR/bin/activate

export OCTAVE_EXECUTABLE=$SCRIPT_DIR/octave-cli

# The JupyterLab is usually started automatically in the browser
jupyter lab --notebook-dir="$HOME"
