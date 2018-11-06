FROM golang as builder

ARG LIBIMAGEQUANT_VERSION=2.12.2
ARG VIPS_VERSION=8.7.0
ARG MAKEFLAGS="-j8"
ARG FFMPEG_VERSION=4.0.3

WORKDIR /tmp/workdir

RUN apt-get update -yqq && \
	apt-get install -yq --no-install-recommends build-essential pkg-config glib2.0-dev libexpat1-dev libexif-dev \
		libfftw3-dev libgif-dev libjpeg62-turbo-dev liblcms2-dev liborc-0.4-dev libpng-dev libpoppler-glib-dev \
		librsvg2-dev libtiff5-dev libwebp-dev yasm libx264-dev libx265-dev libnuma-dev libvpx-dev libtheora-dev && \
	wget -O- https://github.com/ImageOptim/libimagequant/archive/${LIBIMAGEQUANT_VERSION}/libimagequant-${LIBIMAGEQUANT_VERSION}.tar.gz | \
		tar xzC . && \
	cd libimagequant-${LIBIMAGEQUANT_VERSION} && \
	./configure --prefix=/usr --with-openmp && \
	make && make install && cd ../ && \
	wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | \
		tar xzC . && \
	cd vips-${VIPS_VERSION} && \
	./configure --prefix=/usr --enable-static=no && \
	make && make install && cd ../ && \
	wget -O- https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
		tar xjC . && \
	cd ffmpeg-${FFMPEG_VERSION} && \
	./configure --prefix=/usr --disable-debug --disable-doc --disable-ffplay --disable-static --enable-shared \
		--enable-gpl --enable-libtheora --enable-libvpx --enable-libx265 --enable-libx264 --enable-version3 && \
	make && make install && cd / && \
	rm -rf /tmp/workdir