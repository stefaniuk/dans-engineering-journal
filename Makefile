serve-drafts:
	JEKYLL_ENV=development bundle exec jekyll server --drafts

serve-live:
	JEKYLL_ENV=production bundle exec jekyll server

clean:
	rm -rf \
		_site \
		.jekyll-cache \
		.sass-cache

update: clean
	mkdir _site && cd _site \
		&& git clone https://github.com/stefaniuk-pages/stefaniuk.co.uk.git . \
		&& git checkout gh-pages \
		&& cd .. \
		&& JEKYLL_ENV=production bundle exec jekyll build

save: update
	[ -z "$(TITLE)" ] && echo "ERROR: Please provide a TITLE for the post to publish, e.g. make publish TITLE='My New Post'" && exit 1 ||:
	cd _site \
		&& touch .nojekyll \
		&& git add -A \
		&& git commit -m "feat(post): publish '$(TITLE)'"

publish: save # Publish the site to GitHub
	cd _site \
		&& echo git push

.SILENT:
