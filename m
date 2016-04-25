From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 10/40] ARM: efi: Apply strict permissons for UEFI Runtime Services regions
Date: Mon, 25 Apr 2016 21:06:42 +0100
Message-ID: <1461614832-17633-11-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Recent UEFI versions expose permission attributes for runtime services
memory regions, either in the UEFI memory map or in the separate memory
attributes table.  This allows the kernel to map these regions with
stricter permissions, rather than the RWX permissions that are used by
default. So wire this up in our mapping routine.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/arm/include/asm/efi.h |  1 +
 arch/arm/kernel/efi.c      | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e0eea72deb87..b0c341d7ceee 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -22,6 +22,7 @@
 void efi_init(void);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
+int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define efi_call_virt(f, ...)						\
 ({									\
diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
index ff8a9d8acfac..9f43ba012d10 100644
--- a/arch/arm/kernel/efi.c
+++ b/arch/arm/kernel/efi.c
@@ -11,6 +11,41 @@
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
 
+static int __init set_permissions(pte_t *ptep, pgtable_t token,
+				  unsigned long addr, void *data)
+{
+	efi_memory_desc_t *md = data;
+	pte_t pte = *ptep;
+
+	if (md->attribute & EFI_MEMORY_RO)
+		pte = set_pte_bit(pte, __pgprot(L_PTE_RDONLY));
+	if (md->attribute & EFI_MEMORY_XP)
+		pte = set_pte_bit(pte, __pgprot(L_PTE_XN));
+	set_pte_ext(ptep, pte, PTE_EXT_NG);
+	return 0;
+}
+
+int __init efi_set_mapping_permissions(struct mm_struct *mm,
+				       efi_memory_desc_t *md)
+{
+	unsigned long base, size;
+
+	base = md->virt_addr;
+	size = md->num_pages << EFI_PAGE_SHIFT;
+
+	/*
+	 * We can only use apply_to_page_range() if we can guarantee that the
+	 * entire region was mapped using pages. This should be the case if the
+	 * region does not cover any naturally aligned SECTION_SIZE sized
+	 * blocks.
+	 */
+	if (round_down(base + size, SECTION_SIZE) <
+	    round_up(base, SECTION_SIZE) + SECTION_SIZE)
+		return apply_to_page_range(mm, base, size, set_permissions, md);
+
+	return 0;
+}
+
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	struct map_desc desc = {
@@ -34,5 +69,11 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 		desc.type = MT_DEVICE;
 
 	create_mapping_late(mm, &desc, true);
+
+	/*
+	 * If stricter permissions were specified, apply them now.
+	 */
+	if (md->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))
+		return efi_set_mapping_permissions(mm, md);
 	return 0;
 }
-- 
2.7.3
