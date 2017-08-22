blog:
	JEKYLL_ENV=development jekyll server --drafts
test:
	JEKYLL_ENV=production jekyll server
publish: save
	cd _site \
		&& git push
save: update
	cd _site \
		&& touch .nojekyll \
		&& git add -A \
		&& git commit -m "Publish"
update: clean
	cd _site \
		&& git clone git@github.com:stefaniuk/stefaniuk.github.io.git . \
		&& git checkout master \
		&& cd .. \
		&& JEKYLL_ENV=production jekyll build
clean:
	rm -rf .sass-cache
	rm -rf _site
	mkdir _site

.SILENT:
