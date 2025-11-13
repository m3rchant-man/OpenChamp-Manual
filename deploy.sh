#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Name of the virtual environment directory
VENV_DIR="venv"
# The Python command to use (python3 is recommended for modern systems)
PYTHON_CMD="python3"

# --- Script Logic ---

# 1. Check for and create the virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in '$VENV_DIR'..."
    $PYTHON_CMD -m venv "$VENV_DIR"
else
    echo "Virtual environment '$VENV_DIR' already exists."
fi

# 2. Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# 3. Install/update dependencies from requirements.txt
if [ -f "requirements.txt" ]; then
    echo "Installing/updating dependencies from requirements.txt..."
    pip install -r requirements.txt
else
    echo "Warning: requirements.txt not found. Skipping dependency installation."
    # You might want to install manually here if needed, e.g.:
    # pip install mkdocs mkdocs-material mkdocs-macros-plugin
fi

echo "----------------------------------------------------"

# 4. Check for the --build flag and run the appropriate command
if [[ "$1" == "--build" ]]; then
    echo "Build flag detected. Running 'mkdocs build'..."
    mkdocs build
    echo "Build complete. Static site is in the 'site/' directory."
else
    echo "Running 'mkdocs serve'... (Press Ctrl+C to stop)"
    # The --dev-addr flag makes the server accessible on your network
    mkdocs gh-deploy
fi
