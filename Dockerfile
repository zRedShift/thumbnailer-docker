FROM golang:1.11.2-alpine3.8

ARG LIBIMAGEQUANT_VERSION=2.12.2
ARG VIPS_VERSION=8.7.0
ARG FFMPEG_VERSION=4.0.3
ARG MAKEFLAGS="-j8"

RUN 	apk update && \
    	apk upgrade && \
    	apk add --no-cache \
    	fftw-dev glib-dev lcms2-dev libexif-dev libjpeg-turbo-dev libpng-dev libwebp-dev bash gcc musl-dev \
    	libstdc++ ca-certificates libcrypto1.0 libssl1.0 libgomp expat autoconf automake build-base libtool coreutils\
    	orc-dev tiff-dev zlib-dev openexr-dev pango-dev libgsf-dev librsvg-dev gobject-introspection-dev \
    	libxml2-dev giflib-dev poppler-dev zlib-dev freetype-dev gnutls-dev lame-dev libass-dev libogg-dev \
    	libtheora-dev libvorbis-dev libvpx-dev libssh2 opus-dev rtmpdump-dev x264-dev x265-dev yasm \
    	bzip2-dev lame-dev openjpeg-dev libva-dev libvdpau-dev fribidi-dev xvidcore-dev fontconfig-dev && \
    wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | \
	tar xzC /tmp && \
	wget -O- https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
	tar xzC /tmp && \
	wget -O- https://github.com/ImageOptim/libimagequant/archive/${LIBIMAGEQUANT_VERSION}/libimagequant-${LIBIMAGEQUANT_VERSION}.tar.gz | \
	tar xzC /tmp && \
	cd /tmp/libimagequant-${LIBIMAGEQUANT_VERSION} && \
	./configure --prefix=/usr \
				--with-openmp && \
	make && \
	make install && \
	make distclean && \
	cd /tmp/vips-${VIPS_VERSION} && \
	./configure --prefix=/usr \
				--enable-debug=no \
				--without-python && \
	make && \
	make install && \
	cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
	apk add --no-cache yasm && \
	./configure --prefix=/usr \
				--disable-debug \
				--disable-doc \
				--disable-ffplay \
				--enable-shared \
				--enable-gpl \
				--enable-libass \
				--enable-libfreetype \
				--enable-libmp3lame \
				--enable-libopenjpeg \
				--enable-libopus \
				--enable-libtheora \
				--enable-libvorbis \
				--enable-libvpx \
				--enable-libx265 \
				--enable-libxvid \
				--enable-libx264 \
				--enable-nonfree \
				--enable-openssl \
				--enable-postproc \
				--enable-version3 && \
	make && \
	make install && \
	make distclean && \
	rm -rf /tmp/libimagequant-${LIBIMAGEQUANT_VERSION} && \
	rm -rf /tmp/vips-${VIPS_VERSION} && \
	rm -rf /tmp/ffmpeg-${FFMPEG_VERSION}

WORKDIR $GOPATH