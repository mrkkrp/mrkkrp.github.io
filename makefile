#
# Some useful stuff for the site management.
#
# Call from project's root. Supported commands:
#
# - watch (default)
# - deploy
# - build
#

SITE=$(shell find ./.stack-work/dist/ -name site -type f)

.PHONY : get-index

watch : build
	$(SITE) watch

deploy : build # may be brittle
	cd ../mrkkrp-blog-master/ ; rm -vr \
	css/ posts/ index.html
	cd .. ; cp -vr ./mrkkrp-blog/_site/* ./mrkkrp-blog-master/
	cd ../mrkkrp-blog-master/ ; git add -A ; git commit -m 'auto-sync' ; \
	git push origin master

build :
	$(SITE) clean
	$(SITE) build
