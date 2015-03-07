From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 3/7] x86, boot: Don't overlap VO with ZO data
Date: Sat,  7 Mar 2015 14:07:17 -0800
Message-ID: <1425766041-6551-4-git-send-email-yinghai@kernel.org>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Boris found data from boot stage can not be used kernel stage.

Bootloader allocate buffer according to init_size in hdr, and load the
ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
During running of ZO, ZO move itself to the middle of buffer at
z_extract_offset to make sure that decompressor would not have output
overwrite input data before input data get consumed.
After decompressor is called, VO (vmlinux) use whole buffer from start,
and ZO code and data section is overlapped with VO bss section.
And later VO/clear_bss() clear them before code in arch/x86/kernel/setup.c
access them.

We need to avoid overlapping to keep ZO data.

In previous patch, We already move ZO close the end of buffer instead of
middle of buffer. But there is overlapping beween VO brk with ZO data area.

Extend init_size so VO bss and brk will not overlap with data ZO data area
(most from boot/compressed/misc.c).

The increase is from _rodata to _end in ZO (arch/x86/boot/compressed/vmlinux).

-v2: add init_size in arch/x86/boot/header.S instead of BRK.
-v3: split code that move ZO to end of buffer to another patch.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/Makefile                 | 2 +-
 arch/x86/boot/compressed/vmlinux.lds.S | 1 +
 arch/x86/boot/header.S                 | 7 +++++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 57bbf2f..863ef25 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,7 +86,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index e24e0a0..6d6158e 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 		*(.text.*)
 		_etext = . ;
 	}
+        . = ALIGN(PAGE_SIZE); /* keep ADDON_ZO_SIZE page aligned */
 	.rodata : {
 		_rodata = . ;
 		*(.rodata)	 /* read-only data */
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9bfab22..bc5d78d 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -440,12 +440,15 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 
+# don't overlap data area of ZO with VO
+#define ADDON_ZO_SIZE (ZO__end - ZO__rodata)
+
 #define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
 #define VO_INIT_SIZE	(VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
-#define INIT_SIZE ZO_INIT_SIZE
+#define INIT_SIZE (ZO_INIT_SIZE + ADDON_ZO_SIZE)
 #else
-#define INIT_SIZE VO_INIT_SIZE
+#define INIT_SIZE (VO_INIT_SIZE + ADDON_ZO_SIZE)
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0			# Filled in by build.c
-- 
1.8.4.5
