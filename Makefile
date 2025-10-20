define remove-existing-deployments
	@echo "🔍 Checking for existing deployments with same metadata..."
	@BRANCH=$$(git branch --show-current || echo "unknown"); \
	echo "Current branch: $$BRANCH"; \
	EXISTING_DEPLOYMENTS=$$(vercel ls --meta branch=$$BRANCH --meta app=$(1) --token $$VERCEL_TOKEN --cwd apps/$(1) --json 2>/dev/null || echo "[]"); \
	if [ "$$EXISTING_DEPLOYMENTS" != "[]" ]; then \
		echo "🗑️  Found existing deployments, removing them..."; \
		echo $$EXISTING_DEPLOYMENTS | jq -r '.[].url' | while read url; do \
			echo "   Removing: $$url"; \
			vercel remove $$url --token $$VERCEL_TOKEN --yes 2>/dev/null || true; \
		done; \
	else \
		echo "✅ No existing deployments found"; \
	fi
endef

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

define create-preview
	@echo "🚀 Creating new $(1) deployment..."; \
	BRANCH=$$(git rev-parse --abbrev-ref HEAD || echo "unknown"); \
	echo "🔍 Using PREVIEW environment for $$BRANCH branch"; \
	vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel build --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel deploy --prebuilt --archive=tgz --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=$$BRANCH" --meta "app=$(1)"
endef

builder:
	$(call remove-existing-deployments,builder)
	$(call create-preview,builder)

viewer:
	$(call remove-existing-deployments,viewer)
	$(call create-preview,viewer)

ls-builder:
	vercel ls --meta branch=$(shell git branch --show-current) --meta app=builder --token $$VERCEL_TOKEN --cwd apps/builder

ls-viewer:
	vercel ls --meta branch=$(shell git branch --show-current) --meta app=viewer --token $$VERCEL_TOKEN --cwd apps/viewer