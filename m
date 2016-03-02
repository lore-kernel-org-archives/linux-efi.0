From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/5] arm64: efi: apply strict permissons for UEFI Runtime
 Services regions
Date: Wed, 2 Mar 2016 12:10:36 +0000
Message-ID: <20160302121036.GD2649@codeblueprint.co.uk>
References: <1456151158-25849-1-git-send-email-ard.biesheuvel@linaro.org>
 <1456151158-25849-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456151158-25849-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Feb, at 03:25:55PM, Ard Biesheuvel wrote:
> Recent UEFI versions expose permission attributes for runtime services
> memory regions, either in the UEFI memory map or in the separate memory
> attributes table. This allows the kernel to map these regions with
> stricter permissions, rather than the RWX permissions that are used by
> default. So wire this up in our mapping routine.
> 
> Note that in the absence of permission attributes, we still only map
> regions of type EFI_RUNTIME_SERVICE_CODE with the executable bit set.
> Also, we base the mapping attributes of EFI_MEMORY_MAPPED_IO on the
> type directly rather than on the absence of the EFI_MEMORY_WB attribute.
> This is more correct, but is also required for compatibility with the
> upcoming support for the Memory Attributes Table, which only carries
> permission attributes, not memory type attributes.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 27 ++++++++++++++++----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index b6abc852f2a1..3364408c154f 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -24,15 +24,32 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
>  	/*
>  	 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
>  	 * executable, everything else can be mapped with the XN bits
> -	 * set.
> +	 * set. Also take the new (optional) RO/XP bits into account.
>  	 */
> -	if ((md->attribute & EFI_MEMORY_WB) == 0)
> +	if (md->type == EFI_MEMORY_MAPPED_IO)
>  		prot_val = PROT_DEVICE_nGnRE;
> -	else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
> -		 !PAGE_ALIGNED(md->phys_addr))
> +	else if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
> +			   "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
> +		/*
> +		 * If the region is not aligned to the page size of the OS, we
> +		 * can not use strict permissions, since that would also affect
> +		 * the mapping attributes of the adjacent regions.
> +		 */
>  		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
> -	else
> +	else if ((md->attribute & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
> +		 (EFI_MEMORY_XP | EFI_MEMORY_RO))
> +		/* R-- */
> +		prot_val = pgprot_val(PAGE_KERNEL_RO);
> +	else if (md->attribute & EFI_MEMORY_RO)
> +		/* R-X */
> +		prot_val = pgprot_val(PAGE_KERNEL_ROX);
> +	else if (md->attribute & EFI_MEMORY_XP ||
> +		 md->type != EFI_RUNTIME_SERVICES_CODE)
> +		/* RW- */
>  		prot_val = pgprot_val(PAGE_KERNEL);
> +	else
> +		/* RWX */
> +		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
>  
>  	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
>  			   md->num_pages << EFI_PAGE_SHIFT,

The actual logic looks fine but it seems like there's quite a lot
going on in this function which is fairly difficult to decipher with
the if/else if clauses.

Would you be open to splitting this out a little? It's just a
suggestion, but maybe something like this,

---

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 3364408c154f..33a6da160a50 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,39 +17,48 @@
 
 #include <asm/efi.h>
 
-int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+/*
+ * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
+ * executable, everything else can be mapped with the XN bits
+ * set. Also take the new (optional) RO/XP bits into account.
+ */
+static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 {
-	pteval_t prot_val;
+	u64 attr = md->attribute;
+	u32 type = md->type;
 
-	/*
-	 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
-	 * executable, everything else can be mapped with the XN bits
-	 * set. Also take the new (optional) RO/XP bits into account.
-	 */
-	if (md->type == EFI_MEMORY_MAPPED_IO)
-		prot_val = PROT_DEVICE_nGnRE;
-	else if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
-			   "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+	if (type == EFI_MEMORY_MAPPED_IO)
+		return PROT_DEVICE_nGnRE;
+
+	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
+		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
 		/*
 		 * If the region is not aligned to the page size of the OS, we
 		 * can not use strict permissions, since that would also affect
 		 * the mapping attributes of the adjacent regions.
 		 */
-		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
-	else if ((md->attribute & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
-		 (EFI_MEMORY_XP | EFI_MEMORY_RO))
-		/* R-- */
-		prot_val = pgprot_val(PAGE_KERNEL_RO);
-	else if (md->attribute & EFI_MEMORY_RO)
-		/* R-X */
-		prot_val = pgprot_val(PAGE_KERNEL_ROX);
-	else if (md->attribute & EFI_MEMORY_XP ||
-		 md->type != EFI_RUNTIME_SERVICES_CODE)
-		/* RW- */
-		prot_val = pgprot_val(PAGE_KERNEL);
-	else
-		/* RWX */
-		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
+		return pgprot_val(PAGE_KERNEL_EXEC);
+
+	/* R-- */
+	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
+	    (EFI_MEMORY_XP | EFI_MEMORY_RO))
+		return pgprot_val(PAGE_KERNEL_RO);
+
+	/* R-X */
+	if (attr & EFI_MEMORY_RO)
+		return pgprot_val(PAGE_KERNEL_ROX);
+
+	/* RW- */
+	if (attr & EFI_MEMORY_XP || type != EFI_RUNTIME_SERVICES_CODE)
+		return pgprot_val(PAGE_KERNEL);
+
+	/* RWX */
+	return pgprot_val(PAGE_KERNEL_EXEC);
+}
+
+int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	pteval_t prot_val = create_mapping_protection(md);
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
