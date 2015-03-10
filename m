From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 3/7] x86, boot: Don't overlap VO with ZO data
Date: Tue, 10 Mar 2015 10:34:30 +0100
Message-ID: <20150310093430.GC3535@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-4-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425766041-6551-4-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Final patch:

---
From: Yinghai Lu <yinghai@kernel.org>
Date: Sat, 7 Mar 2015 14:07:17 -0800
Subject: [PATCH] x86/setup: Don't overlap vmlinux's brk with compressed kernel's data

We already do move the compressed kernel close to the end of the buffer.
However, there's still overlapping beween kernel proper's .brk/.bss and
compressed kernel's data section.

Extend init_size so that kernel proper's .bss and .brk sections
do not overlap with compressed kernel's data section (see
arch/x86/boot/compressed/misc.c).

The increase is from _rodata to _end in the compressed kernel
(arch/x86/boot/compressed/vmlinux) which is something around ~90K on a
kernel with everything enabled in arch/x86/boot/ which gets linked into
vmlinux.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Link: http://lkml.kernel.org/r/1425766041-6551-4-git-send-email-yinghai@kernel.org
Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
[ Rewrite commit message;
  rename ADDON_ZO_SIZE to INIT_SIZE_PAD;
  improve comments; measure size increase  ]
Signed-off-by: 
---
 arch/x86/boot/Makefile                 |  2 +-
 arch/x86/boot/compressed/vmlinux.lds.S |  1 +
 arch/x86/boot/header.S                 | 13 +++++++++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 57bbf2fb21f6..863ef25dcf60 100644
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
index a80acabb80ec..45081235ce64 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 		*(.text.*)
 		_etext = . ;
 	}
+        . = ALIGN(PAGE_SIZE); /* keep INIT_SIZE_PAD in header.S page-aligned */
 	.rodata : {
 		_rodata = . ;
 		*(.rodata)	 /* read-only data */
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9bfab22efdf7..db46aa45906d 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -440,13 +440,22 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 
+
 #define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
+
+/*
+ * Additional padding so that compressed kernel's .data section doesn't overlap
+ * with kernel proper's .bss/.brk sections.
+ */
+#define INIT_SIZE_PAD	(ZO__end - ZO__rodata)
 #define VO_INIT_SIZE	(VO__end - VO__text)
+
 #if ZO_INIT_SIZE > VO_INIT_SIZE
-#define INIT_SIZE ZO_INIT_SIZE
+#define INIT_SIZE (ZO_INIT_SIZE + INIT_SIZE_PAD)
 #else
-#define INIT_SIZE VO_INIT_SIZE
+#define INIT_SIZE (VO_INIT_SIZE + INIT_SIZE_PAD)
 #endif
+
 init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0			# Filled in by build.c
 
-- 
2.2.0.33.gc18b867

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
