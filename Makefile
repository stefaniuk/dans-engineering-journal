serve-drafts:
	JEKYLL_ENV=development bundle exec jekyll server --drafts

serve-live:
	JEKYLL_ENV=production bundle exec jekyll server

clean:
	rm -rf .sass-cache
	rm -rf _site
	mkdir _site

update: clean
	cd _site \
		&& git clone https://github.com/stefaniuk-blog/stefaniuk.co.uk.git . \
		&& git checkout main \
		&& cd .. \
		&& JEKYLL_ENV=production bundle exec jekyll build

save: update
	cd _site \
		&& touch .nojekyll \
		&& git add -A \
		&& git commit -m "Publish"

publish: save # Publish the site to GitHub
	cd _site \
		&& git push

.SILENT:
