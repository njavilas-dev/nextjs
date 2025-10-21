# Makefile targets that use scripts from scripts/ directory

# Production deployments
builder-production:
	./scripts/create-production.sh builder

viewer-production:
	./scripts/create-production.sh viewer

# Preview deployments
builder-preview:
	./scripts/create-preview.sh builder

viewer-preview:
	./scripts/create-preview.sh viewer

# Main targets (remove + create)
builder:
	./scripts/remove-deployments.sh builder preview
	./scripts/create-preview.sh builder

viewer:
	./scripts/remove-deployments.sh viewer preview
	./scripts/create-preview.sh viewer

# List deployments
ls-builder:
	./scripts/ls-deployments.sh builder

ls-viewer:
	./scripts/ls-deployments.sh viewer

# Remove only targets
remove-builder-production:
	./scripts/remove-deployments.sh builder production

remove-viewer-production:
	./scripts/remove-deployments.sh viewer production

remove-builder-preview:
	./scripts/remove-deployments.sh builder preview

remove-viewer-preview:
	./scripts/remove-deployments.sh viewer preview

# Helper targets
help:
	@echo "Available targets:"
	@echo "  builder-production    - Deploy builder to production"
	@echo "  viewer-production      - Deploy viewer to production"
	@echo "  builder-preview        - Deploy builder to preview"
	@echo "  viewer-preview         - Deploy viewer to preview"
	@echo "  builder                - Remove + deploy builder (preview)"
	@echo "  viewer                 - Remove + deploy viewer (preview)"
	@echo "  ls-builder             - List builder deployments"
	@echo "  ls-viewer             - List viewer deployments"
	@echo "  remove-builder-production - Remove builder production deployments"
	@echo "  remove-viewer-production - Remove viewer production deployments"
	@echo "  remove-builder-preview   - Remove builder preview deployments"
	@echo "  remove-viewer-preview    - Remove viewer preview deployments"