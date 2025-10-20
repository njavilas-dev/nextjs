# Function to remove existing deployments with same metadata
define remove-existing-deployments
	@echo "🗑️  Removing existing deployments..."
	@BRANCH=$$(git branch --show-current || echo "unknown"); \
	vercel list --meta branch=$$BRANCH --meta app=$(1) --token $$VERCEL_TOKEN --cwd apps/$(1) 2>/dev/null | grep -o "https://[^ ]*\.vercel\.app" | while read url; do \
		echo "   Removing: $$url"; \
		vercel remove $$url --token $$VERCEL_TOKEN --yes 2>/dev/null || true; \
	done
endef

# Function to create new deployment
define create-deployment
	@echo "🚀 Creating new $(1) deployment..."
	@BRANCH=$$(git branch --show-current || echo "unknown"); \
	if [ "$$BRANCH" = "develop" ]; then \
		echo "📦 Using PRODUCTION environment for develop branch"; \
		vercel pull --yes --environment=production --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel build --prod --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel deploy --prebuilt --archive=tgz --prod --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=develop" --meta "app=$(1)"; \
	else \
		echo "🔍 Using PREVIEW environment for $$BRANCH branch"; \
		vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel build --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel deploy --prebuilt --archive=tgz --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=$$BRANCH" --meta "app=$(1)"; \
	fi
endef

# Main targets
builder:
	$(call remove-existing-deployments,builder)
	$(call create-deployment,builder)

viewer:
	$(call remove-existing-deployments,viewer)
	$(call create-deployment,viewer)

# List deployments
ls-builder:
	vercel list --meta branch=$(shell git branch --show-current) --meta app=builder --token $$VERCEL_TOKEN --cwd apps/builder

ls-viewer:
	vercel list --meta branch=$(shell git branch --show-current) --meta app=viewer --token $$VERCEL_TOKEN --cwd apps/viewer

# Remove only targets
remove-builder:
	$(call remove-existing-deployments,builder)

remove-viewer:
	$(call remove-existing-deployments,viewer)