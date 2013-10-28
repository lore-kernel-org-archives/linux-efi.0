From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Date: Mon, 28 Oct 2013 18:10:11 +0800
Message-ID: <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
 <20131028093206.GB4314@pd.tnic>
 <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
 <20131028100402.GC4314@pd.tnic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028100402.GC4314-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 10/28/13 at 11:04am, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 05:51:17PM +0800, Dave Young wrote:
> > It does have a warning, but it applied successfully, no idea though: 
> > patches/02-efi-enter-virtual-mode-cleanup.patch
> > Applying: Cleanup efi_enter_virtual_mode function
> > /home/dave/git/efi/.git/rebase-apply/patch:42: space before tab in indent.
> >  	efi_memory_desc_t *md, *prev_md = NULL;
> > warning: 1 line adds whitespace errors.
> 
> Hmm, ok, can you upload the patches somewhere so that I can pull them?

Sorry, I have not any public git account. Attached the patch I applied with git

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="02-efi-enter-virtual-mode-cleanup-1.patch.new"

From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cleanup efi_enter_virtual_mode function

Add two small functions:
efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
calls them instead of embedding two long for loop.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |   83 +++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 31 deletions(-)

--- efi.orig/arch/x86/platform/efi/efi.c
+++ efi/arch/x86/platform/efi/efi.c
@@ -789,35 +789,13 @@ void __init old_map_region(efi_memory_de
 		pr_err("ioremap of 0x%llX failed!\n",
 		       (unsigned long long)md->phys_addr);
 }
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor and update
- * that memory descriptor with the virtual address obtained from ioremap().
- * This enables the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- */
-void __init efi_enter_virtual_mode(void)
-{
-	efi_memory_desc_t *md, *prev_md = NULL;
-	void *p, *new_memmap = NULL;
-	unsigned long size;
-	efi_status_t status;
-	u64 end, systab;
-	int count = 0;
 
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
+/* Merge contiguous regions of the same type and attribute */
+static void efi_merge_regions(void)
+{
+	void *p;
+ 	efi_memory_desc_t *md, *prev_md = NULL;
 
-	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
 		md = p;
@@ -844,6 +822,19 @@ void __init efi_enter_virtual_mode(void)
 		prev_md = md;
 
 	}
+}
+
+/*
+ * Map efi memory ranges for runtime serivce
+ * Return the new memmap with updated virtual addrresses.
+ */
+void efi_map_regions(void **new_memmap, int *count)
+{
+	efi_memory_desc_t *md, *prev_md = NULL;
+	void *p;
+	unsigned long size;
+	efi_status_t status;
+	u64 end, systab;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -862,14 +853,44 @@ void __init efi_enter_virtual_mode(void)
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
+		*new_memmap = krealloc(*new_memmap,
+				      (*count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
-		memcpy(new_memmap + (count * memmap.desc_size), md,
+		memcpy(*new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
-		count++;
+		(*count)++;
+	}
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor and update
+ * that memory descriptor with the virtual address obtained from ioremap().
+ * This enables the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
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
 	}
 
+	efi_merge_regions();
+
+	efi_map_regions(&new_memmap, &count);
+
 #ifdef CONFIG_X86_64
 	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
 

--ikeVEW9yuYc//A+q--
