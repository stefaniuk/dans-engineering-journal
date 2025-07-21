blog:
	JEKYLL_ENV=development bundle exec jekyll server --drafts
test:
	JEKYLL_ENV=production bundle exec jekyll server
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
		&& git clone https://github.com/stefaniuk-blog/stefaniuk.co.uk.git . \
		&& git checkout master \
		&& cd .. \
		&& JEKYLL_ENV=production bundle exec jekyll build
clean:
	rm -rf .sass-cache
	rm -rf _site
	mkdir _site

.SILENT:
