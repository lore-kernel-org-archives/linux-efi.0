From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 5/5] x86/efi: Save and restore FPU context around efi_calls (i386)
Date: Thu, 27 Mar 2014 15:10:43 -0700
Message-ID: <1395958243-14458-6-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Do a complete FPU context save/restore around the EFI calls. This required
as runtime EFI firmware may potentially use the FPU.

This change covers only the i386 configuration.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/include/asm/efi.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index fc99bd1..473969e 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -32,10 +32,23 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 /* Use this macro if your virtual returns a non-void value */
 #define efi_call_virt(f, args...) \
-	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
+({									\
+	efi_status_t __s;						\
+	kernel_fpu_begin();						\
+	__s = ((efi_##f##_t __attribute__((regparm(0)))*)		\
+		efi.systab->runtime->f)(args);				\
+	kernel_fpu_end();						\
+	__s;								\
+})
 
 /* Use this macro if your virtual call does not return any value */
-#define __efi_call_virt(f, args...) efi_call_virt(f, args)
+#define __efi_call_virt(f, args...) \
+({									\
+	kernel_fpu_begin();						\
+	((efi_##f##_t __attribute__((regparm(0)))*)			\
+		efi.systab->runtime->f)(args);				\
+	kernel_fpu_end();						\
+})
 
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
-- 
1.8.1.2
