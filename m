From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI fixes
Date: Fri, 2 Jun 2017 08:46:48 +0200
Message-ID: <20170602064648.kfdqqbfjggyqlfx6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: 7425826f4f7ac60f2538b06a7f0a5d1006405159 efi/bgrt: Skip efi_bgrt_init() in case of non-EFI boot

Misc fixes:

 - three boot crash fixes for uncommon configurations,
 - silence a boot warning under virtualization,
 - plus a GCC 7 related (harmless) build warning fix.

 Thanks,

	Ingo

------------------>
Arnd Bergmann (1):
      efi: Remove duplicate 'const' specifiers

Baoquan He (1):
      x86/efi: Correct EFI identity mapping under 'efi=old_map' when KASLR is enabled

Dave Young (1):
      efi/bgrt: Skip efi_bgrt_init() in case of non-EFI boot

Juergen Gross (1):
      efi: Don't issue error message when booted under Xen

Sai Praneeth (1):
      x86/efi: Disable runtime services on kexec kernel if booted with efi=old_map


 arch/x86/platform/efi/efi.c               |  6 ++-
 arch/x86/platform/efi/efi_64.c            | 79 +++++++++++++++++++++++++++----
 arch/x86/platform/efi/quirks.c            |  3 ++
 drivers/firmware/efi/efi-bgrt.c           |  3 ++
 drivers/firmware/efi/libstub/secureboot.c |  4 +-
 5 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7e76a4d8304b..43b96f5f78ba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -828,9 +828,11 @@ static void __init kexec_enter_virtual_mode(void)
 
 	/*
 	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
+	 * non-native EFI. With efi=old_map, we don't do runtime services in
+	 * kexec kernel because in the initial boot something else might
+	 * have been mapped at these virtual addresses.
 	 */
-	if (!efi_is_native()) {
+	if (!efi_is_native() || efi_enabled(EFI_OLD_MEMMAP)) {
 		efi_memmap_unmap();
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c488625c9712..eb8dff15a7f6 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -71,11 +71,13 @@ static void __init early_code_mapping_set_exec(int executable)
 
 pgd_t * __init efi_call_phys_prolog(void)
 {
-	unsigned long vaddress;
-	pgd_t *save_pgd;
+	unsigned long vaddr, addr_pgd, addr_p4d, addr_pud;
+	pgd_t *save_pgd, *pgd_k, *pgd_efi;
+	p4d_t *p4d, *p4d_k, *p4d_efi;
+	pud_t *pud;
 
 	int pgd;
-	int n_pgds;
+	int n_pgds, i, j;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
 		save_pgd = (pgd_t *)read_cr3();
@@ -88,10 +90,49 @@ pgd_t * __init efi_call_phys_prolog(void)
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
 	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
 
+	/*
+	 * Build 1:1 identity mapping for efi=old_map usage. Note that
+	 * PAGE_OFFSET is PGDIR_SIZE aligned when KASLR is disabled, while
+	 * it is PUD_SIZE ALIGNED with KASLR enabled. So for a given physical
+	 * address X, the pud_index(X) != pud_index(__va(X)), we can only copy
+	 * PUD entry of __va(X) to fill in pud entry of X to build 1:1 mapping.
+	 * This means here we can only reuse the PMD tables of the direct mapping.
+	 */
 	for (pgd = 0; pgd < n_pgds; pgd++) {
-		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
-		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
-		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
+		addr_pgd = (unsigned long)(pgd * PGDIR_SIZE);
+		vaddr = (unsigned long)__va(pgd * PGDIR_SIZE);
+		pgd_efi = pgd_offset_k(addr_pgd);
+		save_pgd[pgd] = *pgd_efi;
+
+		p4d = p4d_alloc(&init_mm, pgd_efi, addr_pgd);
+		if (!p4d) {
+			pr_err("Failed to allocate p4d table!\n");
+			goto out;
+		}
+
+		for (i = 0; i < PTRS_PER_P4D; i++) {
+			addr_p4d = addr_pgd + i * P4D_SIZE;
+			p4d_efi = p4d + p4d_index(addr_p4d);
+
+			pud = pud_alloc(&init_mm, p4d_efi, addr_p4d);
+			if (!pud) {
+				pr_err("Failed to allocate pud table!\n");
+				goto out;
+			}
+
+			for (j = 0; j < PTRS_PER_PUD; j++) {
+				addr_pud = addr_p4d + j * PUD_SIZE;
+
+				if (addr_pud > (max_pfn << PAGE_SHIFT))
+					break;
+
+				vaddr = (unsigned long)__va(addr_pud);
+
+				pgd_k = pgd_offset_k(vaddr);
+				p4d_k = p4d_offset(pgd_k, vaddr);
+				pud[j] = *pud_offset(p4d_k, vaddr);
+			}
+		}
 	}
 out:
 	__flush_tlb_all();
@@ -104,8 +145,11 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	int pgd_idx;
+	int pgd_idx, i;
 	int nr_pgds;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
 
 	if (!efi_enabled(EFI_OLD_MEMMAP)) {
 		write_cr3((unsigned long)save_pgd);
@@ -115,9 +159,28 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 
 	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
 
-	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
+	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
+		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
 		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
 
+		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+			continue;
+
+		for (i = 0; i < PTRS_PER_P4D; i++) {
+			p4d = p4d_offset(pgd,
+					 pgd_idx * PGDIR_SIZE + i * P4D_SIZE);
+
+			if (!(p4d_val(*p4d) & _PAGE_PRESENT))
+				continue;
+
+			pud = (pud_t *)p4d_page_vaddr(*p4d);
+			pud_free(&init_mm, pud);
+		}
+
+		p4d = (p4d_t *)pgd_page_vaddr(*pgd);
+		p4d_free(&init_mm, p4d);
+	}
+
 	kfree(save_pgd);
 
 	__flush_tlb_all();
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 26615991d69c..e0cf95a83f3f 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -360,6 +360,9 @@ void __init efi_free_boot_services(void)
 		free_bootmem_late(start, size);
 	}
 
+	if (!num_entries)
+		return;
+
 	new_size = efi.memmap.desc_size * num_entries;
 	new_phys = efi_memmap_alloc(num_entries);
 	if (!new_phys) {
diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index 04ca8764f0c0..8bf27323f7a3 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 	if (acpi_disabled)
 		return;
 
+	if (!efi_enabled(EFI_BOOT))
+		return;
+
 	if (table->length < sizeof(bgrt_tab)) {
 		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
 		       table->length, sizeof(bgrt_tab));
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 8c34d50a4d80..959777ec8a77 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -16,10 +16,10 @@
 
 /* BIOS variables */
 static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
-static const efi_char16_t const efi_SecureBoot_name[] = {
+static const efi_char16_t efi_SecureBoot_name[] = {
 	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
 };
-static const efi_char16_t const efi_SetupMode_name[] = {
+static const efi_char16_t efi_SetupMode_name[] = {
 	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
 };
 
