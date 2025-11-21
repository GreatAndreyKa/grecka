.PHONY: all clean distclean

GRECKA    = greckad
EXEC_DIR  = /sbin/
UNAME    := $(shell uname)

OBJS=$(patsubst %.c,%.o,$(sort $(wildcard *.c)))
CFLAGS   ?= \
	-g3 -pipe -fPIC -std=c99 \
	-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 \
	-ffunction-sections -fdata-sections -fstack-protector-all \
	-Wall -Winit-self -Wswitch-enum -Wundef \
	-Wmissing-field-initializers -Wconversion \
	-Wredundant-decls -Wstack-protector -ftabstop=4 -Wshadow \
	-Wpointer-arith
LDFLAGS  += -L. -lc -lndm

ifeq ($(UNAME),Linux)
CFLAGS   += -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=600 -D_DEFAULT_SOURCE=1
endif

all: libndm | $(GRECKA)

libndm:
	@rm -rf /tmp/libndm || true
	git clone https://github.com/keenetic/libndm /tmp/libndm
	cd /tmp/libndm && make CPPFLAGS="-I/tmp/libndm/include -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=600 -D_DEFAULT_SOURCE=1"
	cp -r /tmp/libndm/include ./include
	cp /tmp/libndm/libndm.so .

$(GRECKA): $(OBJS) Makefile
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $@

clean:
	rm -fv *.o *~ $(GRECKA)

distclean: clean

CPPFLAGS += -I$(PWD)/include
