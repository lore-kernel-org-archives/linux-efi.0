From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 03/19] x86, boot: Simplify run_size calculation
Date: Wed, 18 Mar 2015 00:28:10 -0700
Message-ID: <1426663706-23979-4-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Junjie Mao <eternal.n08@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

While looking at the boot code to add mem mapping for kasl
with 64bit above 4G support, I found that e6023367d779 ("x86, kaslr: Prevent
.bss from overlaping initrd") and later introduced way to get kernel run_size
and pass it around.  First via perl and then change to shell scripts.

That is not necessary. As that run_size is simple constant, we don't
need to pass it around and we already have voffset.h for that.

We can share voffset.h between misc.c and header.S instead
of adding other way to get run_size.

This patch:
Move voffset.h creation code to boot/compressed/Makefile.

Dependence was:
boot/header.S ==> boot/voffset.h ==> vmlinux
boot/header.S ==> compressed/vmlinux ==> compressed/misc.c
Now become:
boot/header.S ==> compressed/vmlinux ==> compressed/misc.c ==> boot/voffset.h ==> vmlinux

Use macro in misc.c to replace passed run_size.

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/Makefile            | 11 +----------
 arch/x86/boot/compressed/Makefile | 12 ++++++++++++
 arch/x86/boot/compressed/misc.c   |  3 +++
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 863ef25..e7ee9cd 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -77,15 +77,6 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
-
-quiet_cmd_voffset = VOFFSET $@
-      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
-
-targets += voffset.h
-$(obj)/voffset.h: vmlinux FORCE
-	$(call if_changed,voffset)
-
 sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
@@ -97,7 +88,7 @@ $(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
 
 
 AFLAGS_header.o += -I$(obj)
-$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
+$(obj)/header.o: $(obj)/zoffset.h
 
 LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0a291cd..d9fee82 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -40,6 +40,18 @@ LDFLAGS_vmlinux := -T
 hostprogs-y	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
+
+quiet_cmd_voffset = VOFFSET $@
+      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
+
+targets += ../voffset.h
+
+$(obj)/../voffset.h: vmlinux FORCE
+	$(call if_changed,voffset)
+
+$(obj)/misc.o: $(obj)/../voffset.h
+
 vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o \
 	$(obj)/piggy.o $(obj)/cpuflags.o
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index a950864..4785c23 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -11,6 +11,7 @@
 
 #include "misc.h"
 #include "../string.h"
+#include "../voffset.h"
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -390,6 +391,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
+	run_size = VO__end - VO__text;
+
 	console_init();
 	debug_putstr("early console in decompress_kernel\n");
 
-- 
1.8.4.5
