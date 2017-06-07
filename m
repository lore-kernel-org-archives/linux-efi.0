From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v6 14/34] x86/mm: Insure that boot memory areas are mapped
	properly
Date: Wed, 07 Jun 2017 14:15:39 -0500
Message-ID: <20170607191539.28645.70161.stgit@tlendack-t1.amdoffice.net>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170607191309.28645.15241.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The boot data and command line data are present in memory in a decrypted
state and are copied early in the boot process.  The early page fault
support will map these areas as encrypted, so before attempting to copy
them, add decrypted mappings so the data is accessed properly when copied.

For the initrd, encrypt this data in place. Since the future mapping of the
initrd area will be mapped as encrypted the data will be accessed properly.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/mem_encrypt.h |   11 +++++
 arch/x86/include/asm/pgtable.h     |    3 +
 arch/x86/kernel/head64.c           |   30 ++++++++++++--
 arch/x86/kernel/setup.c            |    9 ++++
 arch/x86/mm/mem_encrypt.c          |   77 ++++++++++++++++++++++++++++++++++++
 5 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 7c395cf..61a7049 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -26,6 +26,9 @@ void __init sme_early_encrypt(resource_size_t paddr,
 void __init sme_early_decrypt(resource_size_t paddr,
 			      unsigned long size);
 
+void __init sme_map_bootdata(char *real_mode_data);
+void __init sme_unmap_bootdata(char *real_mode_data);
+
 void __init sme_early_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
@@ -42,6 +45,14 @@ static inline void __init sme_early_decrypt(resource_size_t paddr,
 {
 }
 
+static inline void __init sme_map_bootdata(char *real_mode_data)
+{
+}
+
+static inline void __init sme_unmap_bootdata(char *real_mode_data)
+{
+}
+
 static inline void __init sme_early_init(void)
 {
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3f789ec..16657e7 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -23,6 +23,9 @@
 #ifndef __ASSEMBLY__
 #include <asm/x86_init.h>
 
+extern pgd_t early_level4_pgt[PTRS_PER_PGD];
+int __init __early_make_pgtable(unsigned long address, pmdval_t pmd);
+
 void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd);
 void ptdump_walk_pgd_level_checkwx(void);
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 00ae2c5..f1fe5df 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,7 +34,6 @@
 /*
  * Manage page tables very early on.
  */
-extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
 pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
@@ -48,12 +47,12 @@ static void __init reset_early_page_tables(void)
 }
 
 /* Create a new PMD entry */
-int __init early_make_pgtable(unsigned long address)
+int __init __early_make_pgtable(unsigned long address, pmdval_t pmd)
 {
 	unsigned long physaddr = address - __PAGE_OFFSET;
 	pgdval_t pgd, *pgd_p;
 	pudval_t pud, *pud_p;
-	pmdval_t pmd, *pmd_p;
+	pmdval_t *pmd_p;
 
 	/* Invalid address or early pgt is done ?  */
 	if (physaddr >= MAXMEM || read_cr3_pa() != __pa_nodebug(early_level4_pgt))
@@ -95,12 +94,21 @@ int __init early_make_pgtable(unsigned long address)
 		memset(pmd_p, 0, sizeof(*pmd_p) * PTRS_PER_PMD);
 		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	pmd = (physaddr & PMD_MASK) + early_pmd_flags;
 	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;
 }
 
+int __init early_make_pgtable(unsigned long address)
+{
+	unsigned long physaddr = address - __PAGE_OFFSET;
+	pmdval_t pmd;
+
+	pmd = (physaddr & PMD_MASK) + early_pmd_flags;
+
+	return __early_make_pgtable(address, pmd);
+}
+
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
 static void __init clear_bss(void)
@@ -123,6 +131,12 @@ static void __init copy_bootdata(char *real_mode_data)
 	char * command_line;
 	unsigned long cmd_line_ptr;
 
+	/*
+	 * If SME is active, this will create decrypted mappings of the
+	 * boot data in advance of the copy operations.
+	 */
+	sme_map_bootdata(real_mode_data);
+
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
 	sanitize_boot_params(&boot_params);
 	cmd_line_ptr = get_cmd_line_ptr();
@@ -130,6 +144,14 @@ static void __init copy_bootdata(char *real_mode_data)
 		command_line = __va(cmd_line_ptr);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
+
+	/*
+	 * The old boot data is no longer needed and won't be reserved,
+	 * freeing up that memory for use by the system. If SME is active,
+	 * we need to remove the mappings that were created so that the
+	 * memory doesn't remain mapped as decrypted.
+	 */
+	sme_unmap_bootdata(real_mode_data);
 }
 
 asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f818236..d1414a1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -115,6 +115,7 @@
 #include <asm/microcode.h>
 #include <asm/mmu_context.h>
 #include <asm/kaslr.h>
+#include <asm/mem_encrypt.h>
 
 /*
  * max_low_pfn_mapped: highest direct mapped pfn under 4GB
@@ -374,6 +375,14 @@ static void __init reserve_initrd(void)
 	    !ramdisk_image || !ramdisk_size)
 		return;		/* No initrd provided by bootloader */
 
+	/*
+	 * If SME is active, this memory will be marked encrypted by the
+	 * kernel when it is accessed (including relocation). However, the
+	 * ramdisk image was loaded decrypted by the bootloader, so make
+	 * sure that it is encrypted before accessing it.
+	 */
+	sme_early_encrypt(ramdisk_image, ramdisk_end - ramdisk_image);
+
 	initrd_start = 0;
 
 	mapped_size = memblock_mem_size(max_pfn_mapped);
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 18c0887..2321f05 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -19,6 +19,8 @@
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
+#include <asm/setup.h>
+#include <asm/bootparam.h>
 
 /*
  * Since SME related variables are set early in the boot process they must
@@ -101,6 +103,81 @@ void __init sme_early_decrypt(resource_size_t paddr, unsigned long size)
 	__sme_early_enc_dec(paddr, size, false);
 }
 
+static void __init sme_early_pgtable_flush(void)
+{
+	write_cr3(__sme_pa_nodebug(early_level4_pgt));
+}
+
+static void __init __sme_early_map_unmap_mem(void *vaddr, unsigned long size,
+					     bool map)
+{
+	unsigned long paddr = (unsigned long)vaddr - __PAGE_OFFSET;
+	pmdval_t pmd_flags, pmd;
+
+	/* Use early_pmd_flags but remove the encryption mask */
+	pmd_flags = __sme_clr(early_pmd_flags);
+
+	do {
+		pmd = map ? (paddr & PMD_MASK) + pmd_flags : 0;
+		__early_make_pgtable((unsigned long)vaddr, pmd);
+
+		vaddr += PMD_SIZE;
+		paddr += PMD_SIZE;
+		size = (size <= PMD_SIZE) ? 0 : size - PMD_SIZE;
+	} while (size);
+}
+
+static void __init __sme_map_unmap_bootdata(char *real_mode_data, bool map)
+{
+	struct boot_params *boot_data;
+	unsigned long cmdline_paddr;
+
+	__sme_early_map_unmap_mem(real_mode_data, sizeof(boot_params), map);
+	boot_data = (struct boot_params *)real_mode_data;
+
+	/*
+	 * Determine the command line address only after having established
+	 * the decrypted mapping.
+	 */
+	cmdline_paddr = boot_data->hdr.cmd_line_ptr |
+			((u64)boot_data->ext_cmd_line_ptr << 32);
+
+	if (cmdline_paddr)
+		__sme_early_map_unmap_mem(__va(cmdline_paddr),
+					  COMMAND_LINE_SIZE, map);
+}
+
+void __init sme_unmap_bootdata(char *real_mode_data)
+{
+	/* If SME is not active, the bootdata is in the correct state */
+	if (!sme_active())
+		return;
+
+	/*
+	 * The bootdata and command line aren't needed anymore so clear
+	 * any mapping of them.
+	 */
+	__sme_map_unmap_bootdata(real_mode_data, false);
+
+	sme_early_pgtable_flush();
+}
+
+void __init sme_map_bootdata(char *real_mode_data)
+{
+	/* If SME is not active, the bootdata is in the correct state */
+	if (!sme_active())
+		return;
+
+	/*
+	 * The bootdata and command line will not be encrypted, so they
+	 * need to be mapped as decrypted memory so they can be copied
+	 * properly.
+	 */
+	__sme_map_unmap_bootdata(real_mode_data, true);
+
+	sme_early_pgtable_flush();
+}
+
 void __init sme_early_init(void)
 {
 	unsigned int i;
