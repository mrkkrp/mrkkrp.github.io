#
# Some useful stuff for the site management.
#
# Call from project's root. Supported commands:
#
# - watch (default)
# - deploy
# - build
# - gh-pages

MASTER="https://github.com/mrkkrp/mrkkrp.github.io.git"

.PHONY : master

watch : build
	stack exec site watch

deploy : build master
	cd mrkkrp-blog-master/ ; rm -vfr \
	css/ js/ img/ posts/ index.html feed.atom contact.html
	cp -vr _site/* mrkkrp-blog-master/
	cd mrkkrp-blog-master/ ; git add -A ; git commit -m 'auto-sync' ; \
	git push origin master

build :
	stack exec site clean
	stack exec site build

master :
	rm -vfr mrkkrp-blog-master/
	git clone --branch master $(MASTER) mrkkrp-blog-master
