#
# Some useful stuff for the site management.
#
# Call from project's root. Supported commands:
#
# - watch (default)
# - deploy
# - build
#

.PHONY : get-index

watch : build
	stack exec site watch

deploy : build # may be brittle
	cd ../mrkkrp-blog-master/ ; rm -vfr \
	css/ posts/ index.html feed.atom contact.html
	cd .. ; cp -vr ./mrkkrp-blog/_site/* ./mrkkrp-blog-master/
	cd ../mrkkrp-blog-master/ ; git add -A ; git commit -m 'auto-sync' ; \
	git push origin master

build :
	stack exec site clean
	stack exec site build
