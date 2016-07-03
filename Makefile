push: commit
	@cd _site \
		&& git push
commit: build
	@cd _site \
		&& touch .nojekyll \
		&& git add -A \
		&& git commit -m "Automated build"
build: clean
	@cd _site \
		&& git clone git@github.com:stefaniuk/stefaniuk.github.io.git . \
		&& git checkout master \
		&& cd .. \
		&& JEKYLL_ENV=production jekyll build
clean:
	@rm -rf .sass-cache
	@rm -rf _site
	@mkdir _site
