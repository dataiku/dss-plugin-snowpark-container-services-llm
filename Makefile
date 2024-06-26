# Makefile variables set automatically
plugin_id=`cat plugin.json | python -c "import sys, json; print(str(json.load(sys.stdin)['id']).replace('/',''))"`
plugin_version=`cat plugin.json | python -c "import sys, json; print(str(json.load(sys.stdin)['version']).replace('/',''))"`
archive_file_name="dss-plugin-${plugin_id}-${plugin_version}.zip"
remote_url=`git config --get remote.origin.url`
last_commit_id=`git rev-parse HEAD`

.DEFAULT_GOAL := plugin

plugin: clean build-plugin zip-plugin

zip-plugin:
	@echo "[START] Archiving plugin to dist/ folder..."
	@cat plugin.json | json_pp > /dev/null
	@mkdir dist
	@echo "{\"remote_url\":\"${remote_url}\",\"last_commit_id\":\"${last_commit_id}\"}" > release_info.json
	@zip -r dist/${archive_file_name} release_info.json plugin.json java-lib/* java-llms/* parameter-sets/* LICENSE README.md
	@rm release_info.json
	@echo "[SUCCESS] Archiving plugin to dist/ folder: Done!"

build-plugin:
	@echo "[START] Building Java..."
	@ant jar
	@echo "[SUCCESS] Building Java: Done!"

clean:
	rm -rf dist
	rm -rf java-build
