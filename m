From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 2/5] x86/efi: Map RAM into the identity page table for mixed mode
Date: Sat, 14 Nov 2015 22:00:48 +0000
Message-ID: <1447538451-5793-3-git-send-email-matt@codeblueprint.co.uk>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447538451-5793-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We are relying on the pre-existing mappings in 'trampoline_pgd' when
accessing function arguments in the EFI mixed mode thunking code.

Instead let's map memory explicitly so that things will continue to
work when we move to a separate page table in the future.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c8b58ac47b77..634536034e32 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -144,6 +144,7 @@ void efi_sync_low_kernel_mappings(void)
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long pfn, text;
+	efi_memory_desc_t *md;
 	struct page *page;
 	unsigned npages;
 	pgd_t *pgd;
@@ -200,6 +201,25 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
+	/*
+	 * Map all of RAM so that we can access arguments in the 1:1
+	 * mapping when making EFI runtime calls.
+	 */
+	for_each_efi_memory_desc(&memmap, md) {
+		if (md->type != EFI_CONVENTIONAL_MEMORY &&
+		    md->type != EFI_LOADER_DATA &&
+		    md->type != EFI_LOADER_CODE)
+			continue;
+
+		pfn = md->phys_addr >> PAGE_SHIFT;
+		npages = md->num_pages;
+
+		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, 0)) {
+			pr_err("Failed to map 1:1 memory\n");
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.6.2
