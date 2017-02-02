From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI fixes
Date: Thu, 2 Feb 2017 21:54:45 +0100
Message-ID: <20170202205444.GA32650@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: c8f325a59cfc718d13a50fbc746ed9b415c25e92 efi/fdt: Avoid FDT manipulation after ExitBootServices()

Two EFI boot fixes, one for arm64 and one for x86 systems with certain firmware 
versions.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      efi/fdt: Avoid FDT manipulation after ExitBootServices()

Jiri Kosina (1):
      x86/efi: Always map the first physical page into the EFI pagetables


 arch/x86/platform/efi/efi_64.c     | 16 ++++++++++++++++
 drivers/firmware/efi/libstub/fdt.c | 14 +++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 319148bd4b05..2f25a363068c 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -269,6 +269,22 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.use_pgd = true;
 
 	/*
+	 * Certain firmware versions are way too sentimential and still believe
+	 * they are exclusive and unquestionable owners of the first physical page,
+	 * even though they explicitly mark it as EFI_CONVENTIONAL_MEMORY
+	 * (but then write-access it later during SetVirtualAddressMap()).
+	 *
+	 * Create a 1:1 mapping for this page, to avoid triple faults during early
+	 * boot with such firmware. We are free to hand this page to the BIOS,
+	 * as trim_bios_range() will reserve the first page and isolate it away
+	 * from memory allocators anyway.
+	 */
+	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
+		pr_err("Failed to create 1:1 mapping for the first page!\n");
+		return 1;
+	}
+
+	/*
 	 * When making calls to the firmware everything needs to be 1:1
 	 * mapped and addressable with 32-bit pointers. Map the kernel
 	 * text and allocate a new stack because we can't rely on the
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 921dfa047202..260c4b4b492e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -187,6 +187,7 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
 struct exit_boot_struct {
 	efi_memory_desc_t *runtime_map;
 	int *runtime_entry_count;
+	void *new_fdt_addr;
 };
 
 static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
@@ -202,7 +203,7 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 	efi_get_virtmap(*map->map, *map->map_size, *map->desc_size,
 			p->runtime_map, p->runtime_entry_count);
 
-	return EFI_SUCCESS;
+	return update_fdt_memmap(p->new_fdt_addr, map);
 }
 
 /*
@@ -300,22 +301,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 	priv.runtime_map = runtime_map;
 	priv.runtime_entry_count = &runtime_entry_count;
+	priv.new_fdt_addr = (void *)*new_fdt_addr;
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
 					exit_boot_func);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
 
-		status = update_fdt_memmap((void *)*new_fdt_addr, &map);
-		if (status != EFI_SUCCESS) {
-			/*
-			 * The kernel won't get far without the memory map, but
-			 * may still be able to print something meaningful so
-			 * return success here.
-			 */
-			return EFI_SUCCESS;
-		}
-
 		/* Install the new virtual address map */
 		svam = sys_table->runtime->set_virtual_address_map;
 		status = svam(runtime_entry_count * desc_size, desc_size,
