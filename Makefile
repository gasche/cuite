LIB_PREFIX ?= $(shell pwd)

PKG_CONFIG_PATH?=$(word 1, $(wildcard /usr/local/Cellar/qt/*/lib/pkgconfig)):
export PKG_CONFIG_PATH

all clean:
	echo "$(PKG_CONFIG_PATH)"
	$(MAKE) -C gen $@
	$(MAKE) -C lib LIB_PREFIX=$(LIB_PREFIX) $@
	$(MAKE) -C examples $@

default:
	$(MAKE) -C gen
	$(MAKE) -C lib LIB_PREFIX=$(LIB_PREFIX)

install:
	ocamlfind install cuite lib/META lib/cuite.a lib/cuite.cma lib/cuite.cmxa \
		lib/cuite.cmi $(filter-out lib/cuite__alloc.%,$(wildcard lib/cuite_*.cmi)) \
		lib/cuite.cmx lib/cuite__qt.cmx lib/cuite__flags.cmx lib/cuite__models.cmx
	install -t $(LIB_PREFIX) lib/libcuite.so

uninstall:
	ocamlfind remove cuite
	rm -f $(LIB_PREFIX)/libcuite.so

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install
