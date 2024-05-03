# Get the current directory (where the Makefile is located)
CURDIR = $(shell pwd)

# Default target to run when executing `make` without arguments
all: setup

# Target to set up the project
setup:
	# Suppress output to hide the details from the user
	@chmod +x main.sh
	@sudo mv main.sh /usr/local/bin/ncomp

	@chmod +x $(CURDIR)/cron.sh

	# Only output messages on success or when providing feedback
	@if ! crontab -l | grep -q "$(CURDIR)/cron.sh"; then \
		(crontab -l; echo "0 0 */15 * * $(CURDIR)/cron.sh") | crontab -; \
		@echo "Added cron job for 'cron.sh' to run every 15 days"; \
	else \
		@echo "'cron.sh' is already scheduled in crontab"; \
	fi

	@echo "Setup complete. 'ncomp' is now in /usr/local/bin."

# Target to clean up
clean:
	@sudo rm -f /usr/local/bin/ncomp

	@if crontab -l | grep -q "$(CURDIR)/cron.sh"; then \
		crontab -l | grep -v "$(CURDIR)/cron.sh" | crontab -; \
		@echo "Removed cron job for 'cron.sh'"; \
	else \
		@echo "No cron job for 'cron.sh' to remove"; \
	fi

	@echo "Clean-up complete."

# Help target to list available commands
help:
	@echo "Available targets:"
	@echo "  all       - Default target (runs setup)"
	@echo "  setup     - Set up the project (make 'main.sh' executable, move to /usr/local/bin, and schedule cron job)"
	@echo "  clean     - Remove 'ncomp' from /usr/local/bin, and remove scheduled cron job"
