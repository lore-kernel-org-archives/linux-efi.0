From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 1/7 v2] Add function efi_remap_region for remapping to saved
 virt address
Date: Tue, 05 Nov 2013 16:20:08 +0800
Message-ID: <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline; filename=01-efi-map-fixed-addr.patch
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

Kexec kernel will use saved runtime virtual mapping, so add a
new function efi_remap_region to remapping it directly without
calculate the virt addr from efi_va.

The md is passed in from 1st kernel, the virtual addr is
saved in md->virt_addr.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/include/asm/efi.h     |    1 +
 arch/x86/platform/efi/efi_32.c |    3 +++
 arch/x86/platform/efi/efi_64.c |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

--- linux-2.6.orig/arch/x86/include/asm/efi.h
+++ linux-2.6/arch/x86/include/asm/efi.h
@@ -128,6 +128,7 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
--- linux-2.6.orig/arch/x86/platform/efi/efi_64.c
+++ linux-2.6/arch/x86/platform/efi/efi_64.c
@@ -203,6 +203,25 @@ void __init efi_map_region(efi_memory_de
 	md->virt_addr = efi_va;
 }
 
+/*
+ * kexec kernel will use efi_map_region_fixed to map efi
+ * runtime memory ranges. md->virt_addr is the original virtual
+ * address which had been mapped in kexec 1st kernel.
+ */
+void __init efi_map_region_fixed(efi_memory_desc_t *md)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long pf = 0;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		pf |= _PAGE_PCD;
+
+	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr,
+			md->num_pages, pf))
+		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, md->virt_addr);
+}
+
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type, u64 attribute)
 {
--- linux-2.6.orig/arch/x86/platform/efi/efi_32.c
+++ linux-2.6/arch/x86/platform/efi/efi_32.c
@@ -47,6 +47,9 @@ void __init efi_map_region(efi_memory_de
 	old_map_region(md);
 }
 
+void __init efi_map_region_fixed(efi_memory_desc_t *md)
+{}
+
 void efi_call_phys_prelog(void)
 {
 	struct desc_ptr gdt_descr;
