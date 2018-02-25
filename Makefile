# Created by: Guangyuan Yang <ygy@FreeBSD.org>
# $FreeBSD$

PORTNAME=	electron
DISTVERSION=	1.0
CATEGORIES=	www
MASTER_SITES=	https://github.com/yzgyyang/freebsd-ports-libchromiumcontent/releases/download/v61.0.3163.100/
DISTFILES=	libchromiumcontent.zip libchromiumcontent-static.zip

MAINTAINER=	ygy@FreeBSD.org

EXTRACT_DEPENDS=${LOCALBASE}/bin/unzip:archivers/unzip

USE_GITHUB=	yes
GH_ACCOUNT=	electron
GH_PROJECT=	electron
GH_TAGNAME=	4dab824
GH_TUPLE=	boto:boto:f7574aa:boto/vendor/boto \
		electron:chromium-breakpad:82f0452e:breakpad/vendor/breakpad \
		electron:crashpad:07072bf:crashpad/vendor/crashpad \
		yzgyyang:depot-tools:4fa73b8:depot_tools/vendor/depot_tools \
		electron:gyp:eea8c79:gyp/vendor/gyp \
		electron:libchromiumcontent:2bdad00:libchromiumcontent/vendor/libchromiumcontent \
		electron:native-mate:bf92fa8:native_mate/vendor/native_mate \
		electron:node:bf06b64:node/vendor/node \
		electron:pdf-viewer:a5251e4:pdf_viewer/vendor/pdf_viewer \
		requests:requests:e4d59be:requests/vendor/requests

post-extract:
	${MKDIR} ${WRKSRC}/vendor/download/libchromiumcontent
	echo ${WRKSRC}
	${UNZIP_CMD} -d ${WRKSRC}/vendor/download/libchromiumcontent/ \
		${DISTDIR}/${DIST_SUBDIR}/libchromiumcontent.zip
	${UNZIP_CMD} -d ${WRKSRC}/vendor/download/libchromiumcontent/ \
		${DISTDIR}/${DIST_SUBDIR}/libchromiumcontent-static.zip

pre-build:
	patch -p1 --ignore-whitespace -d ${WRKSRC} < electron_111.diff
	(cd ${WRKSRC} && script/bootstrap.py -v --clang_dir=/usr || true)
	patch -p1 --ignore-whitespace -d ${WRKSRC}/vendor/native_mate/ < electron_vendor_native_matev1.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/brightray/ < electron_brightrayv3.diff
	patch -p1 --ignore-whitespace -d ${WRKSRC}/vendor/libchromiumcontent/ < electron_vendor_libchromiumcontentv1.diff

do-build:
	(cd ${WRKSRC} && script/bootstrap.py -v --clang_dir=/usr)
	(cd ${WRKSRC} && script/build.py -c R)
	(cd ${WRKSRC} && script/create-dist.py)

.include <bsd.port.mk>