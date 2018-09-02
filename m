From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 3/6] x86/efi: Permanently save the EFI_MEMORY_MAP passed by the firmware
Date: Sun,  2 Sep 2018 02:46:31 -0700
Message-ID: <1535881594-25469-4-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

The efi page fault handler that fixes up page faults caused by the
firmware needs the original memory map passed by the firmware. It looks
up this memory map to find the type of the memory region at which the
page fault occurred. Presently, EFI subsystem discards the original
memory map passed by the firmware and replaces it with a new memory map
that has only EFI_RUNTIME_SERVICES_<CODE/DATA> regions. But illegal
accesses by firmware can occur at any region. Hence, _only_ if
CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS is defined, create a backup of the
original memory map passed by the firmware, so that efi page fault
handler could detect/fix illegal accesses to *any* efi region.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/include/asm/efi.h     |  6 ++++++
 arch/x86/platform/efi/efi.c    |  2 ++
 arch/x86/platform/efi/quirks.c | 49 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 9b70743400f3..d9e5d9a6d138 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -142,6 +142,12 @@ extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
 
+#ifdef CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS
+extern void __init efi_save_original_memmap(void);
+#else
+static inline void __init efi_save_original_memmap(void) { }
+#endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
+
 struct efi_setup_data {
 	u64 fw_vendor;
 	u64 runtime;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 439c2c40bf03..7d18b7ed5d41 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -946,6 +946,8 @@ static void __init __efi_enter_virtual_mode(void)
 
 	pa = __pa(new_memmap);
 
+	efi_save_original_memmap();
+
 	/*
 	 * Unregister the early EFI memmap from efi_init() and install
 	 * the new EFI memory map that we are about to pass to the
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 844d31cb8a0c..7fd53fa8c4dd 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -654,3 +654,52 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 }
 
 #endif
+
+#ifdef CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS
+
+static bool original_memory_map_present;
+static struct efi_memory_map original_memory_map;
+
+/*
+ * The page fault handler that fixes up page faults caused by buggy
+ * firmware needs original memory map (memory map passed by firmware).
+ * Hence, build a new EFI memmap that has *all* entries and save it for
+ * later use.
+ */
+void __init efi_save_original_memmap(void)
+{
+	efi_memory_desc_t *md;
+	void *remapped_phys, *new_md;
+	phys_addr_t new_phys, new_size;
+
+	new_size = efi.memmap.desc_size * efi.memmap.nr_map;
+	new_phys = efi_memmap_alloc(efi.memmap.nr_map);
+	if (!new_phys) {
+		pr_err("Failed to allocate new EFI memmap\n");
+		return;
+	}
+
+	remapped_phys = memremap(new_phys, new_size, MEMREMAP_WB);
+	if (!remapped_phys) {
+		pr_err("Failed to remap new EFI memmap\n");
+		__free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
+		return;
+	}
+
+	new_md = remapped_phys;
+	for_each_efi_memory_desc(md) {
+		memcpy(new_md, md, efi.memmap.desc_size);
+		new_md += efi.memmap.desc_size;
+	}
+
+	original_memory_map.late = 1;
+	original_memory_map.phys_map = new_phys;
+	original_memory_map.map = remapped_phys;
+	original_memory_map.nr_map = efi.memmap.nr_map;
+	original_memory_map.desc_size = efi.memmap.desc_size;
+	original_memory_map.map_end = remapped_phys + new_size;
+	original_memory_map.desc_version = efi.memmap.desc_version;
+
+	original_memory_map_present = true;
+}
+#endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
-- 
2.7.4
