From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 08/19] x86, kaslr: Get correct max_addr for relocs pointer
Date: Wed, 18 Mar 2015 00:28:15 -0700
Message-ID: <1426663706-23979-9-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

There is boundary checking for pointer in kaslr relocation handling.

Current code is using output_len, and that is VO (vmlinux after objcopy)
file size plus vmlinux.relocs file size.

That is not right, as we should use loaded address for running.

At that time parse_elf already move the sections according to ELF headers.

The valid range should be VO [_text, __bss_start) loaded physical addresses.

In the patch, add export for __bss_start to voffset.h and use it to get
max_addr.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 2 +-
 arch/x86/boot/compressed/misc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 50daea7..e12a93c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -40,7 +40,7 @@ LDFLAGS_vmlinux := -T
 hostprogs-y	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|__bss_start\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
 
 quiet_cmd_voffset = VOFFSET $@
       cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8e81a88..f99c9c9 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -234,7 +234,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 	int *reloc;
 	unsigned long delta, map, ptr;
 	unsigned long min_addr = (unsigned long)output;
-	unsigned long max_addr = min_addr + output_len;
+	unsigned long max_addr = min_addr + (VO___bss_start - VO__text);
 
 	/*
 	 * Calculate the delta between where vmlinux was linked to load
-- 
1.8.4.5
