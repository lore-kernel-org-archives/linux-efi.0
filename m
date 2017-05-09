From: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] efi/libstub: Indicate clang the relocation mode for arm64
Date: Tue,  9 May 2017 12:36:12 -0700
Message-ID: <20170509193612.64105-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?Bernhard=20Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Without any extra guidance, clang will generate libstub with either
absolute or relative ELF relocations. Use the right combination of
-fpic and -fno-pic on different files to avoid this.

Signed-off-by: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bernhard Rosenkränzer <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/firmware/efi/libstub/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index f7425960f6a5..ccbaaf4d8650 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -11,6 +11,9 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -mno-mmx -mno-sse
 
 cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+ifeq ($(cc-name),clang)
+cflags-$(CONFIG_ARM64)		+= -fpic
+endif
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
@@ -38,6 +41,9 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 
 lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
 				   $(patsubst %.c,lib-%.o,$(arm-deps))
+ifeq ($(cc-name),clang)
+CFLAGS_arm64-stub.o            += -fno-pic
+endif
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
 lib-$(CONFIG_ARM64)		+= arm64-stub.o
-- 
2.13.0.rc2.291.g57267f2277-goog
