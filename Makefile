all: zip zipnote zipcloak zipsplit

CC ?= gcc
LD ?= gcc
CPP ?= "gcc -E"

PREFIX ?=
BINDIR = $(PREFIX)/bin

INSTALL_PROGRAM = cp
INSTALL_D = mkdir -p

CFLAGS ?= -I. -DUNIX -DHAVE_TERMIOS_H -DNO_BZIP2_SUPPORT -DLARGE_FILE_SUPPORT -DUNICODE_SUPPORT -DHAVE_DIRENT_H -DUIDGID_NOT_16BIT
LFLAGS1 ?=
LDFLAGS ?=

ZIP_H = zip.h ziperr.h tailor.h unix/osdep.h

OBJZ = zip.o zipfile.o zipup.o fileio.o util.o globals.o crypt.o ttyio.o \
	unix.o crc32.o zbz2err.o
OBJI = deflate.o trees.o
OBJU = zipfile_.o fileio_.o util_.o globals_.o unix_.o
OBJN = zipnote.o $(OBJU) crc32_.o
OBJC = zipcloak.o $(OBJU) crc32_.o crypt_.o ttyio.o
OBJS = zipsplit.o $(OBJU) crc32_.o

.SUFFIXES:
.SUFFIXES: _.o .o .c
.c_.o:
	$(CC) -c $(CFLAGS) -DUTIL -o $@ $<

.c.o:
	$(CC) -c $(CFLAGS) $<

unix.o: unix/unix.c
	$(CC) -c $(CFLAGS) unix/unix.c

unix_.o: unix/unix.c
	$(CC) -c $(CFLAGS) -DUTIL -o $@ unix/unix.c

$(OBJZ): $(ZIP_H)
$(OBJI): $(ZIP_H)
$(OBJN): $(ZIP_H)
$(OBJS): $(ZIP_H)
$(OBJC): $(ZIP_H)

zip: $(OBJZ) $(OBJI)
	$(CC) -o zip $(LFLAGS1) $(OBJZ) $(OBJI) $(LDFLAGS)

zipnote: $(OBJN)
	$(CC) -o zipnote $(LFLAGS1) $(OBJN) $(LDFLAGS)

zipcloak: $(OBJC)
	$(CC) -o zipcloak $(LFLAGS1) $(OBJC) $(LDFLAGS)

zipsplit: $(OBJS)
	$(CC) -o zipsplit $(LFLAGS1) $(OBJS) $(LDFLAGS)

ZIPS = zip zipcloak zipnote zipsplit

zips: $(ZIPS)

clean:
	rm -f *.o zip zipnote zipcloak zipsplit

install: $(ZIPS)
	$(INSTALL_D) $(DESTDIR)$(PREFIX)$(BINDIR)
	$(INSTALL_PROGRAM) $(ZIPS) $(DESTDIR)$(PREFIX)$(BINDIR)
