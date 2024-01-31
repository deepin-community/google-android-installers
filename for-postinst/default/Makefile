PKG_SOURCE_URL:=${DL_MIRROR}/android/repository/${REPO_DIR}${PKG_SOURCE}

DL_DIR=/var/cache/google-android-${PKG_NAME}-installer
INSTALL_DIR=/usr/lib/${INS_DIR}
DOC_DIR=/usr/share/doc/google-android-${PKG_NAME}

all: $(UNPACK_DIR)/source.properties

install: all
	$(eval UNPACK_DIR=$(DL_DIR)/$(shell \
		if [ $$(unzip -Z -1 $(DL_DIR)/$(PKG_SOURCE) | cut -d '/' -f1 | sort -u | wc -l) -gt 1 ]; then \
		  echo $(TRG_DIR) ;\
		else \
		  unzip -Z -1 $(DL_DIR)/$(PKG_SOURCE) | head -1 | cut -d '/' -f 1 ;\
		fi)/)
	install -d -m0755 $(DOC_DIR)
	@if [ -f $(UNPACK_DIR)source.properties ]; then \
		install -m0644 $(UNPACK_DIR)source.properties $(DOC_DIR)/ ; \
        fi
	@if [ -f $(UNPACK_DIR)NOTICE.txt ]; then \
		gzip -9 --stdout $(UNPACK_DIR)/NOTICE.txt > $(DOC_DIR)/copyright.gz ; \
        fi
	find ${DOC_DIR} | sort >> /var/lib/dpkg/info/google-android-${PKG_NAME}-installer.list
	chmod -R a+rX $(UNPACK_DIR)
	chmod -R go-w $(UNPACK_DIR)
	install -d -m0755 $(INSTALL_DIR)
	@if [ ! -d $(INSTALL_DIR)$(TRG_DIR) ]; then \
		mv $(UNPACK_DIR) $(INSTALL_DIR)${TRG_DIR}  ;\
		if [ -e "/usr/share/google-android-${PKG_NAME}-installer/package.xml" ]; then \
		  ln -s $$(realpath /usr/share/google-android-${PKG_NAME}-installer/package.xml --relative-to=$(INSTALL_DIR)${TRG_DIR} ) $(INSTALL_DIR)${TRG_DIR}/package.xml ;\
		fi ;\
		TMPDIR=$$(realpath $(INSTALL_DIR)${TRG_DIR} --relative-to=/usr/lib) ;\
		(while [ "$$(dirname "$$TMPDIR")" != "." ]; do \
		  TMPDIR="$$(dirname "$$TMPDIR")" ;\
		  echo "/usr/lib/$$TMPDIR" ;\
		done) | tac >> /var/lib/dpkg/info/google-android-${PKG_NAME}-installer.list ;\
		find ${INSTALL_DIR}${TRG_DIR}  | sort >> /var/lib/dpkg/info/google-android-${PKG_NAME}-installer.list ;\
	else\
		echo "\033[0;31m$(INSTALL_DIR)${TRG_DIR} already exists.\033[0m" ; \
		exit 1 ; \
	fi

$(UNPACK_DIR)/source.properties: $(DL_DIR)/$(PKG_SOURCE)
	@echo "\n  Unzipping $(PKG_SOURCE). Please be patient, this may take some time."
	@if [ $$(unzip -Z -1 $(DL_DIR)/$(PKG_SOURCE) | cut -d '/' -f1 | sort -u | wc -l) -gt 1 ]; then \
	  mkdir -p ${DL_DIR}/${TRG_DIR}; \
	  cd $(DL_DIR)/${TRG_DIR} && unzip -ouq $(DL_DIR)/$(PKG_SOURCE); \
	else \
	  cd $(DL_DIR) && unzip -ouq $(DL_DIR)/$(PKG_SOURCE); \
	fi

# Search for broken symbolic links & fix them
	@if [ $$(unzip -Z -1 $(DL_DIR)/$(PKG_SOURCE) | cut -d '/' -f1 | sort -u | wc -l) -gt 1 ]; then \
	  ZIP_ROOT_DIR=$(TRG_DIR) ;\
	else \
	  ZIP_ROOT_DIR=$$(unzip -Z -1 $(DL_DIR)/$(PKG_SOURCE) | head -1 | cut -d '/' -f 1) ;\
	fi && \
	BROKEN_SYMLINKS=$$(cd $(DL_DIR)/$$ZIP_ROOT_DIR && find -xtype l -exec ls {} \;) && \
	if [ -n "$$BROKEN_SYMLINKS" ]; then \
	  echo "\n  Fixing broken symbolic links."; \
	fi && \
	for file in $$BROKEN_SYMLINKS; do \
	  cd $(DL_DIR)/$$ZIP_ROOT_DIR && \
	  LINK_TARGET=$$(readlink "$$file") && \
	  REL_PATH_TO_TARGET=$$(echo "$$LINK_TARGET" | sed "s|.*$$ZIP_ROOT_DIR/\(.*\)|\1|") && \
	  echo "    Replacing symbolic link: $$file" && \
	  echo "      Original target: $$LINK_TARGET" && \
	  echo "      New target: $$REL_PATH_TO_TARGET" && \
	  ln -fsr "$$REL_PATH_TO_TARGET" "$$file"; \
	done; \
	BROKEN_SYMLINKS_AFTER=$$(cd $(DL_DIR)/$$ZIP_ROOT_DIR && find -xtype l -exec ls {} \;) && \
	if [ -n "$$BROKEN_SYMLINKS_AFTER" ]; then \
	  echo "\n  Some files have broken symbolic links. Please report a bug to the package maintainer\n"; \
	  for item in $$BROKEN_SYMLINKS_AFTER; do \
	    echo "    $$item"; \
	  done && \
	  exit 1 ;\
	fi

$(DL_DIR)/$(PKG_SOURCE):
	cd $(DL_DIR) && \
		su nobody -s /bin/sh -c "wget --continue $(PKG_SOURCE_URL) -O $(PKG_SOURCE).tmp && mv $(PKG_SOURCE).tmp $(PKG_SOURCE)"
	sha1sum -c $(PKG_SOURCE).sha1

clean:
	-rm -rf -- $(UNPACK_DIR)

distclean: clean
	-rm -rf -- $(DL_DIR)

.PHONY: install clean
