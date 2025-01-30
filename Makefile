#which are used for automating build processes and tasks
.PHONY: build serve # declares that "build" and "serve" are not actual files but rather task names. This prevents conflicts if files with these names exist in the directory.

build:
	uv run build.py
serve:
	uv run python -m http.server 8080 --directory dist