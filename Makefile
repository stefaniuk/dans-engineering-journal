build: clean
	@jekyll build \
		&& tar -zcf dist/_site.tar.gz _site
clean:
	@rm dist/*.tar.gz
	@rm -rf _site/*
