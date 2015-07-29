PROJECT=fros
VERSION=1.1
COMMIT=$(shell git rev-parse HEAD)
SHORT_COMMIT=$(shell git rev-parse --short HEAD)
DIST_TARBALL=${PROJECT}-${VERSION}-${SHORT_COMMIT}.tar.gz

RPM_DIRS = --define "_sourcedir `pwd`" \
		   --define "_rpmdir `pwd`" \
		   --define "_specdir `pwd`" \
		   --define "_builddir `pwd`/rpmbuilddir" \
		   --define "_srcrpmdir `pwd`"

download:
	wget https://github.com/mozeq/fros/archive/${COMMIT}/${DIST_TARBALL}

sdist:
	python3 setup.py sdist

rpm: sdist
	rpmbuild $(RPM_DIRS) -ba fros.spec

srpm: sdist
	rpmbuild $(RPM_DIRS) -bs fros.spec

.PHONY: dist
dist:
	git archive --prefix=fros-${COMMIT}/ HEAD | gzip > ${DIST_TARBALL}

.PHONY: local-rpm
local-rpm: dist
	sed 's/global commit .*$$/global commit '"${COMMIT}"'/' \
		${PROJECT}.spec > /tmp/${PROJECT}.spec
	rpmbuild $(RPM_DIRS) -ba /tmp/${PROJECT}.spec
