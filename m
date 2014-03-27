From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/5] x86/efi: Implement a __efi_call_virt macro
Date: Thu, 27 Mar 2014 15:10:41 -0700
Message-ID: <1395958243-14458-4-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1395958243-14458-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395958243-14458-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For i386, all the EFI system runtime services functions return efi_status_t
except efi_reset_system_system. Therefore, not all functions can be covered
by the same macro in case the macro needs to do more than calling the function
(i.e., return a value). The purpose of the __efi_call_virt macro is to be used
when no return value is expected.

For x86_64, this macro would not be needed as all the runtime services return
u64. However, the same code is used for both x86_64 and i386. Thus, the macro
__efi_call_virt is also defined to not break compilation.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/include/asm/efi.h  | 10 ++++++++++
 arch/x86/platform/efi/efi.c |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0eafd59..004bbf1 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -29,9 +29,13 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
  * Wrap all the virtual calls in a way that forces the parameters on the stack.
  */
 
+/* Use this macro if your virtual returns a non-void value */
 #define efi_call_virt(f, args...) \
 	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
 
+/* Use this macro if your virtual call does not return any value */
+#define __efi_call_virt(f, args...) efi_call_virt(f, args)
+
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
@@ -53,6 +57,12 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 	__s;								\
 })
 
+/*
+ * All X86_64 virt calls return non-void values. Thus, use non-void call for
+ * virt calls that would be void on X86_32.
+ */
+#define __efi_call_virt(f, args...) efi_call_virt(f, args)
+
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 				 u32 type, u64 attribute);
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e9e2fe0..72bf23d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -213,8 +213,8 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	efi_call_virt(reset_system, reset_type, status,
-		      data_size, data);
+	__efi_call_virt(reset_system, reset_type, status,
+			data_size, data);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
-- 
1.8.1.2
