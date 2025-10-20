builder:
	vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/builder
	vercel build --token $$VERCEL_TOKEN --cwd apps/builder
	vercel deploy --prebuilt --token $$VERCEL_TOKEN --cwd apps/builder --meta "branch=$(shell git branch --show-current)" --meta "app=builder"

viewer:
	vercel pull --yes --environment=preview --token $$VERCEL_TOKEN --cwd apps/viewer
	vercel build --token $$VERCEL_TOKEN --cwd apps/viewer
	vercel deploy --prebuilt --token $$VERCEL_TOKEN --cwd apps/viewer --meta "branch=$(shell git branch --show-current)" --meta "app=viewer"