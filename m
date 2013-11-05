From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 3/7 v2] Cleanup efi_enter_virtual_mode function
Date: Tue, 05 Nov 2013 16:20:10 +0800
Message-ID: <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline; filename=03-efi-enter-virtual-mode-cleanup-1.patch
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Add two small functions:
efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
calls them instead of embedding two long for loop.

v1->v2:
refresh; coding style fixes.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |  107 +++++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 44 deletions(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -773,44 +773,12 @@ void __init old_map_region(efi_memory_de
 		       (unsigned long long)md->phys_addr);
 }
 
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, we look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor into the
- * ->trampoline_pgd page table using a top-down VA allocation scheme.
- *
- * The old method which used to update that memory descriptor with the
- * virtual address obtained from ioremap() is still supported when the
- * kernel is booted with efi=old_map on its command line. Same old
- * method enabled the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- *
- * The new method does a pagetable switch in a preemption-safe manner
- * so that we're in a different address space when calling a runtime
- * function. For function arguments passing we do copy the PGDs of the
- * kernel page table into ->trampoline_pgd prior to each call.
- */
-void __init efi_enter_virtual_mode(void)
+/* Merge contiguous regions of the same type and attribute */
+static void efi_merge_regions(void)
 {
+	void *p;
 	efi_memory_desc_t *md, *prev_md = NULL;
-	void *p, *new_memmap = NULL;
-	unsigned long size;
-	efi_status_t status;
-	u64 end, systab;
-	int count = 0;
-
-	efi.systab = NULL;
-
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
 
-	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
 		md = p;
@@ -837,6 +805,18 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 
 	}
+}
+
+/*
+ * Map efi memory ranges for runtime serivce
+ * Return the new memmap with updated virtual addrresses.
+ */
+static void efi_map_regions(void **new_memmap, int *count)
+{
+	efi_memory_desc_t *md;
+	void *p;
+	unsigned long size;
+	u64 end, systab;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -860,17 +840,59 @@ void __init efi_enter_virtual_mode(void)
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
 
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		if (!new_memmap)
+		*new_memmap = krealloc(*new_memmap,
+					(*count + 1) * memmap.desc_size,
+					GFP_KERNEL);
+		if (!*new_memmap)
 			goto err_out;
 
-		memcpy(new_memmap + (count * memmap.desc_size), md,
+		memcpy(*new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
-		count++;
+		(*count)++;
 	}
 
+err_out:
+	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, we look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor into the
+ * ->trampoline_pgd page table using a top-down VA allocation scheme.
+ *
+ * The old method which used to update that memory descriptor with the
+ * virtual address obtained from ioremap() is still supported when the
+ * kernel is booted with efi=old_map on its command line. Same old
+ * method enabled the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ *
+ * The new method does a pagetable switch in a preemption-safe manner
+ * so that we're in a different address space when calling a runtime
+ * function. For function arguments passing we do copy the PGDs of the
+ * kernel page table into ->trampoline_pgd prior to each call.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	void *p, *new_memmap = NULL;
+	int count = 0;
+
+	efi.systab = NULL;
+
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+	if (!efi_is_native()) {
+		efi_unmap_memmap();
+		return;
+	}
+
+	efi_merge_regions();
+
+	efi_map_regions(&new_memmap, &count);
+
 	BUG_ON(!efi.systab);
 
 	efi_setup_page_tables();
@@ -922,9 +944,6 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 
 	return;
-
- err_out:
-	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
