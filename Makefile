# Default target to run when executing `make` without arguments
all: setup

# Target to set up the project
setup:
	# Make sure `main.sh` is executable
	chmod +x main.sh

	# Move `main.sh` to `/usr/local/bin` with sudo
	sudo mv main.sh /usr/local/bin/ncomp
	
	# Optionally, confirm that the file was moved successfully
	@echo "Setup complete. 'ncomp' is now in /usr/local/bin."

# Target to clean up
clean:
	# Remove `ncomp` from `/usr/local/bin` (requires sudo)
	sudo rm -f /usr/local/bin/ncomp
	# Optional: Remove any other artifacts if needed
	@echo "Clean-up complete."

# Help target to list available commands
help:
	@echo "Available targets:"
	@echo "  all       - Default target (runs setup)"
	@echo "  setup     - Set up the project (make 'main.sh' executable and move to /usr/local/bin)"
	@echo "  clean     - Remove 'ncomp' from /usr/local/bin"
