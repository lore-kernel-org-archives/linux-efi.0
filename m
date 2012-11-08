From: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH RFC v2 4/4] firmware: Install firmware signature files automatically
Date: Thu,  8 Nov 2012 18:35:09 +0100
Message-ID: <1352396109-3989-5-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
 <1352396109-3989-1-git-send-email-tiwai@suse.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352396109-3989-1-git-send-email-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

... when CONFIG_FIRMWARE_SIG is set.

Signed-off-by: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
---
 Makefile                |  6 ++++++
 scripts/Makefile.fwinst | 18 ++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a1ccf22..c6d7a3e 100644
--- a/Makefile
+++ b/Makefile
@@ -729,6 +729,12 @@ mod_sign_cmd = true
 endif
 export mod_sign_cmd
 
+ifeq ($(CONFIG_FIRMWARE_SIG),y)
+fw_sign_cmd = perl $(srctree)/scripts/sign-file -f $(MODSECKEY) $(MODPUBKEY)
+else
+fw_sign_cmd = true
+endif
+export fw_sign_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 4d908d1..df256f0 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -29,6 +29,20 @@ installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
 installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
 
+ifeq ($(CONFIG_FIRMWARE_SIG),y)
+installed-fw-sig := $(patsubst %,%.sig, $(installed-fw))
+installed-mod-fw-sig := $(patsubst %,%.sig, $(installed-mod-fw))
+else
+installed-fw-sig :=
+installed-mod-fw-sig :=
+endif
+
+quiet_cmd_fwsig = FWSIG $@
+      cmd_fwsig = $(fw_sign_cmd) $(patsubst %.sig,%,$@) $@
+
+%.sig: %
+	$(call cmd,fwsig)
+
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
 $(INSTALL_FW_PATH)/$$(%): install-all-dirs
@@ -49,9 +63,9 @@ PHONY +=  __fw_install __fw_modinst FORCE
 
 .PHONY: $(PHONY)
 
-__fw_install: $(installed-fw)
+__fw_install: $(installed-fw) $(installed-fw-sig)
 
-__fw_modinst: $(installed-mod-fw)
+__fw_modinst: $(installed-mod-fw) $(installed-mod-fw-sig)
 	@:
 
 __fw_modbuild: $(addprefix $(obj)/,$(mod-fw))
-- 
1.8.0
