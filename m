From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86/efi: Store upper bits of command line buffer address in ext_cmd_line_ptr
Date: Wed, 15 Apr 2015 16:32:24 -0700
Message-ID: <1429140744-25768-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Until now, the EFI stub was only setting the 32 bit cmd_line_ptr in
the setup_header structure, so on 64 bit platforms this could be truncated.
This patch adds setting the upper bits of the buffer address in
ext_cmd_line_ptr.  This case was likely never hit, as the allocation
for this buffer is done at the lowest available address.  Only
x86_64 kernels have this problem, as the 1-1 mapping mandated
by EFI ensures that all memory is 32 bit addressable on 32 bit
platforms.  The EFI stub does not support mixed mode, so the
32 bit kernel on 64 bit firmware case does not need to be handled.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
This is a follow-up to "x86_64/efi: enforce 32 bit address for command line buffer",
which had the wrong fix to the truncation of address.

 arch/x86/boot/compressed/eboot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ef17683..48304b8 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1109,6 +1109,8 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	if (!cmdline_ptr)
 		goto fail;
 	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
+	/* Fill in upper bits of command line address, NOP on 32 bit  */
+	boot_params->ext_cmd_line_ptr = (u64)(unsigned long)cmdline_ptr >> 32;
 
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
-- 
1.9.1
