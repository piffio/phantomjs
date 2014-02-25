#!/bin/sh
#
# A silly little helper script to build the RPM.
set -e

if [ ! -x ../bin/phantomjs ]; then
	echo "Missing phantomjs binary, make sure you run build.sh before building RPMs"
	exit 1
else
	version=`../bin/phantomjs --version`
fi

basedir=`cd .. && pwd`
name=${1:?"Usage: build <toolname>"}
name=${name%.spec}
builddir="${basedir}/${name}-${version}"
topdir="${basedir}/rpm-build-root"
rm -rf ${topdir} ${builddir}
sourcedir="${topdir}/SOURCES"
buildroot="${topdir}/BUILD/${name}-${version}-root"
mkdir -p ${topdir}/RPMS ${topdir}/SRPMS ${topdir}/SOURCES ${topdir}/BUILD
mkdir -p ${buildroot} ${builddir}
echo "=> Copying sources..."
( cd .. && tar cf - ./C* ./L* ./R* ./bin ./examples | tar xf - -C ${builddir} )
echo "=> Creating source tarball under ${sourcedir}..."
( cd ${builddir}/.. && tar zcf ${sourcedir}/${name}-${version}.tar.gz ${name}-${version} )
echo "=> Building RPM..."
rpmbuild --define "_topdir ${topdir}" --define "_pversion ${version}" --buildroot ${buildroot} --clean -bb ${name}.spec 2>/dev/null
