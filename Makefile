define deploy-app
	@echo "🔍 Checking for existing deployments with same metadata..."
	@BRANCH=$$(git branch --show-current); \
	EXISTING_DEPLOYMENTS=$$(vercel ls --meta branch=$$BRANCH --meta app=$(1) --token $$VERCEL_TOKEN --cwd apps/$(1) --json 2>/dev/null || echo "[]"); \
	if [ "$$EXISTING_DEPLOYMENTS" != "[]" ]; then \
		echo "🗑️  Found existing deployments, removing them..."; \
		echo $$EXISTING_DEPLOYMENTS | jq -r '.[].url' | while read url; do \
			echo "   Removing: $$url"; \
			vercel remove $$url --token $$VERCEL_TOKEN --yes 2>/dev/null || true; \
		done; \
	fi
	@echo "🚀 Deploying new $(1) deployment..."
	@if [ "$$BRANCH" = "develop" ]; then \
		echo "📦 Using PRODUCTION environment for develop branch"; \
		vercel pull --yes --environment=production --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel build --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel deploy --prebuilt --prod --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=develop" --meta "app=$(1)"; \
	else \
		echo "🔍 Using PREVIEW environment for $$BRANCH branch"; \
		vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel build --token $$VERCEL_TOKEN --cwd apps/$(1); \
		vercel deploy --prebuilt --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=$$BRANCH" --meta "app=$(1)"; \
	fi
endef

builder:
	$(call deploy-app,builder)

viewer:
	$(call deploy-app,viewer)

ls-builder:
	vercel ls --meta branch=$(shell git branch --show-current) --meta app=builder --token $$VERCEL_TOKEN --cwd apps/builder

ls-viewer:
	vercel ls --meta branch=$(shell git branch --show-current) --meta app=viewer --token $$VERCEL_TOKEN --cwd apps/viewer