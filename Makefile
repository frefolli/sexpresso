BUILDDIR=./builddir
LIB=./builddir/sexpresso.so
INCLUDE=./include/*.hh
SRC=./src/*.cc
MESON_CONF=meson.build
BUILD_TYPE=release

@all: ${LIB} docs

${BUILDDIR}: ${MESON_CONF}
	meson setup --buildtype=${BUILD_TYPE} ${BUILDDIR}

${LIB}: ${BUILDDIR} ${SRC} ${INCLUDE}
	ninja -j 0 -C ${BUILDDIR}

clean:
	rm -rf ${BUILDDIR}
	rm -rf ./doc/html
	rm -rf ./doc/latex

test:
	meson test

install: ${LIB}
	mkdir -p ${DESTDIR}/usr/lib64/
	mkdir -p ${DESTDIR}/usr/include/
	mkdir -p ${DESTDIR}/usr/share/pkgconfig
	mv builddir/libsexpresso.so ${DESTDIR}/usr/lib64/
	cp -r include/sexpresso.hh ${DESTDIR}/usr/include/
	cp -r sexpresso.pc ${DESTDIR}/usr/share/pkgconfig
	mkdir -p ${DESTDIR}/usr/share/doc/
	cp -r doc/html ${DESTDIR}/usr/share/doc/sexpresso

docs:
	make -C doc
