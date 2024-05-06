BUILDDIR=./builddir
LIB=./builddir/sexpresso.so
INCLUDE=./include/*.hh
SRC=./src/*.cc
MESON_CONF=meson.build

@all: ${LIB}

${BUILDDIR}: ${MESON_CONF}
	meson setup --buildtype=${BUILD_TYPE} ${BUILDDIR}

${LIB}: ${BUILDDIR} ${SRC} ${INCLUDE}
	ninja -j 0 -C ${BUILDDIR}

clean:
	rm -rf ${BUILDDIR}

test:
	meson test

install:
	mkdir -p ${DESTDIR}/usr/local/lib/
	mkdir -p ${DESTDIR}/usr/local/include/
	mv builddir/libsexpresso.so ${DESTDIR}/usr/local/lib/
	cp -r include/sexpresso.hh ${DESTDIR}/usr/local/include/
