From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 4/5] x86/efi: Save and restore FPU context around efi_calls (x86_64)
Date: Thu, 27 Mar 2014 15:10:42 -0700
Message-ID: <1395958243-14458-5-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Do a complete FPU context save/restore around the EFI calls. This required
as runtime EFI firmware may potentially use the FPU.

This change covers only the x86_64 configuration.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/include/asm/efi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 004bbf1..fc99bd1 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+#include <asm/i387.h>
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
  * with preserved alignment on virtual addresses starting from -4G down
@@ -52,7 +53,9 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 									\
 	efi_sync_low_kernel_mappings();					\
 	preempt_disable();						\
+	__kernel_fpu_begin();						\
 	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	__kernel_fpu_end();						\
 	preempt_enable();						\
 	__s;								\
 })
-- 
1.8.1.2
