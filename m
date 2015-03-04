From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 03/15] x86, boot: keep data from ZO boot stage to VO kernel stage.
Date: Wed,  4 Mar 2015 00:00:36 -0800
Message-ID: <1425456048-16236-4-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

bp found data from boot stage can not be used kernel stage.

Actually those data area is overlapped with kernel bss stage, and clear_bss()
clear them before code in arch/x86/kernel/setup.c access them.

To make the data survive that later, we should avoid the overlapping.

We already move compressed kernel close the end of buffer instead of middle of
buffer. But there will have overlapping beween VO BRK with ZO data/bss range.

Extend init_size so no one from kernel bss and brk will touch the data
region of boot/compressed/misc.c

The increase is from _rodata to _end in arch/x86/boot/compressed/vmlinux.

-v2: add init_size in arch/x86/boot/header.S instead of BRK.
-v3: split code that move Zo to end of buffer to another patch.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/Makefile                 | 2 +-
 arch/x86/boot/compressed/vmlinux.lds.S | 2 ++
 arch/x86/boot/header.S                 | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

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
index 34d047c..805d6ad 100644
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
@@ -70,5 +71,6 @@ SECTIONS
 		_epgtable = . ;
 	}
 #endif
+        . = ALIGN(PAGE_SIZE);  /* keep ADDON_ZO_SIZE page aligned */
 	_end = .;
 }
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef025..44359bd 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -440,12 +440,15 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 
+# don't overlap data area of ZO with VO
+#define ADDON_ZO_SIZE (ZO__end - ZO__rodata)
+
 #define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset)
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
