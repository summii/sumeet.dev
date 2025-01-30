.PHONY: build serve

build:
	uv run build.py

serve:
	uv run python -m http.server 8080 --directory dist