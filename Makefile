MKDIR?=mkdir
RM?=rm
ZIP?=zip
PERL?=/usr/bin/perl

FILEPP=$(PERL) tools/filepp/filepp
FILEPP_FLAGS= \
	-m pb-utils.pm \
	-m literal.pm

GCUFLAGS?=-p packet-bnetp -s "packet-bnetp plugin"

PKGNAME=packet-bnetp
DISTNAME=packet-bnetp-src
VERSION:=$(shell date +%Y%m%d)

PKG = \
	src/packet-bnetp.lua

SOURCES = \
	src/testpackets.lua \
	src/constants.lua \
	src/checkedtable.lua \
	src/api/integer.lua \
	src/api/array.lua \
	src/api/stringz.lua \
	src/api/time.lua \
	src/api/strdw.lua \
	src/api/when.lua \
	src/api/flags.lua \
	src/api/iterator.lua \
	src/api/ipv4.lua \
	src/api/sockaddr.lua \
	src/api/bytes.lua \
	src/api/version.lua \
	src/valuemaps.lua \
	src/banner.lua \
	src/core.lua \
	src/cpackets_bnls.lua \
	src/cpackets_d2gs.lua \
	src/cpackets_mcp.lua \
	src/cpackets_packet.lua \
	src/cpackets_pkt.lua \
	src/cpackets_sid.lua \
	src/spackets_bnls.lua \
	src/spackets_d2gs.lua \
	src/spackets_mcp.lua \
	src/spackets_packet.lua \
	src/spackets_pkt.lua \
	src/spackets_sid.lua

DIST = \
	$(SOURCES) \
	$(PKG) \
	tools/filepp \
	tools/filepp/filepp \
	tools/filepp/modules \
	tools/filepp/modules/bigdef.pm \
	tools/filepp/modules/bigfunc.pm \
	tools/filepp/modules/blc.pm \
	tools/filepp/modules/c-comment.pm \
	tools/filepp/modules/cmacros.pm \
	tools/filepp/modules/comment.pm \
	tools/filepp/modules/cpp.pm \
	tools/filepp/modules/defplus.pm \
	tools/filepp/modules/for.pm \
	tools/filepp/modules/foreach.pm \
	tools/filepp/modules/format.pm \
	tools/filepp/modules/function.pm \
	tools/filepp/modules/grab.pm \
	tools/filepp/modules/hash-comment.pm \
	tools/filepp/modules/literal.pm \
	tools/filepp/modules/lua-comment.pm \
	tools/filepp/modules/maths.pm \
	tools/filepp/modules/regexp.pm \
	tools/filepp/modules/tolower.pm \
	tools/filepp/modules/toupper.pm \
	tools/filepp/share \
	tools/filepp/share/man \
	tools/filepp/share/man/man1 \
	tools/filepp/share/man/man1/filepp.1 \
	Makefile


src/packet-bnetp.lua: $(SOURCES)
	$(FILEPP) $(FILEPP_FLAGS) src/core.lua > src/packet-bnetp.lua

.PHONY: pkg upload clean

$(PKGNAME)-$(VERSION).zip: $(PKG)
	$(MKDIR) $(PKGNAME)-$(VERSION) && (\
		( cp $(PKG) $(PKGNAME)-$(VERSION) && \
		  $(ZIP) -9 -r $(PKGNAME)-$(VERSION).zip $(PKGNAME)-$(VERSION) ); \
		$(RM) -r $(PKGNAME)-$(VERSION) )

pkg: $(PKGNAME)-$(VERSION).zip
upload: pkg
	tools/googlecode_upload.py \
		$(GCUFLAGS) \
		$(PKGNAME)-$(VERSION).zip

clean:
	$(RM) src/packet-bnetp.lua

-include Makefile.local
