From: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 1/3] efi: Early use of boot service memory
Date: Mon, 11 Nov 2013 19:15:56 -0700
Message-ID: <1384222558-38527-2-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jerry.hoemann-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Add #define to allow for specifying that firmware doesn't reuse
boot service code or data after Exit Boot Service.

Signed-off-by: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..1e3a8d2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -634,6 +634,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_MEMMAP_CORRECT	6	/* We believe the EFI_MEMMAP */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.7.11.3
