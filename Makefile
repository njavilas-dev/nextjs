define remove-deployments
	@echo "🗑️  Removing existing deployments..."
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
	echo "Current branch: $$BRANCH"; \
	vercel list --meta branch=$$BRANCH --meta app=$(1) --token $$VERCEL_TOKEN --cwd apps/$(1) 2>/dev/null | grep -o "https://[^ ]*\.vercel\.app" | while read url; do \
		echo "   Removing: $$url"; \
		vercel remove $$url --token $$VERCEL_TOKEN --yes 2>/dev/null || true; \
	done
endef

define create-production
	@echo "📦 Creating PRODUCTION deployment..."
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
	echo "Branch: $$BRANCH"; \
	vercel pull --yes --environment=production --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel build --prod --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel deploy --prebuilt --archive=tgz --prod --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=develop" --meta "app=$(1)" --meta "environment=production"
endef

define create-preview
	@echo "🔍 Creating PREVIEW deployment..."
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
	echo "Branch: $$BRANCH"; \
	vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel build --token $$VERCEL_TOKEN --cwd apps/$(1); \
	vercel deploy --prebuilt --archive=tgz --token $$VERCEL_TOKEN --cwd apps/$(1) --meta "branch=$$BRANCH" --meta "app=$(1)" --meta "environment=preview"
endef

define ls-deployments
	@BRANCH=$$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
	vercel list --meta branch=$$BRANCH --meta app=$(1) --token $$VERCEL_TOKEN --cwd apps/$(1)
endef

builder-production:
	$(call create-production,builder)

viewer-production:
	$(call create-production,viewer)

builder-preview:
	$(call create-preview,builder)

viewer-preview:
	$(call create-preview,viewer)

builder:
	$(call remove-existing-deployments,builder)
	$(call create-preview,builder)

viewer:
	$(call remove-existing-deployments,viewer)
	$(call create-preview,viewer)

ls-builder:
	$(call ls-deployments,builder)

ls-viewer:
	$(call ls-deployments,viewer)

remove-builder-production:
	$(call remove-deployments,builder,production)

remove-viewer-production:
	$(call remove-deployments,viewer,production)

remove-builder-preview:
	$(call remove-deployments,builder,preview)

remove-viewer-preview:
	$(call remove-deployments,viewer,preview)