From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 6/6] efi: Fix unaligned fake memmap entries corrupting efi memory map
Date: Mon,  2 Jul 2018 18:50:54 -0700
Message-ID: <1530582654-25662-7-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1530582654-25662-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530582654-25662-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>, Laszlo Ersek <lersek@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Nicolai Stange <nicstange@gmail.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

efi_fake_memmap() inserts user given fake memory map entries into the
original efi memory map using efi_memmmap_insert(). efi_memmmap_insert()
checks for EFI_PAGE_SIZE alignment and could fail if an unaligned efi
memory region is passed (Eg: efi_fake_memmap=1K@0x73ae0000:
0x8000000000000000). Since EFI_PAGE_SIZE is 4K the above request fails,
but efi_fake_memmap() doesn't check for failures in efi_memmap_insert()
and installs an empty efi memory map from efi_memmap_alloc(). Since efi
memory map is corrupted all the later efi calls fail too. Hence, fix
this bug by changing the return type of efi_memmap_insert() from void to
int.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Laszlo Ersek <lersek@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/platform/efi/quirks.c  |  8 +++++++-
 drivers/firmware/efi/fake_mem.c | 11 +++++++++--
 drivers/firmware/efi/memmap.c   | 12 ++++++++----
 include/linux/efi.h             |  4 ++--
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 8fce327387e5..0e607ac24a3b 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -290,7 +290,13 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
-	efi_memmap_insert(&efi.memmap, new, &mr);
+	if (efi_memmap_insert(&efi.memmap, new, &mr)) {
+		pr_err("Failed to reserve EFI memory region\n");
+		early_memunmap(new, new_size);
+		efi_memmap_free(new_phys, num_entries, alloc_type);
+		return;
+	}
+
 	early_memunmap(new, new_size);
 
 	/* Free existing memory map before installing new memory map */
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 09b0fabf07fd..ae373af6931b 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -84,8 +84,15 @@ void __init efi_fake_memmap(void)
 		return;
 	}
 
-	for (i = 0; i < nr_fake_mem; i++)
-		efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
+	for (i = 0; i < nr_fake_mem; i++) {
+		if (efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i])) {
+			pr_err("efi_fake_mem: Failed to create fake memmap\n");
+			early_memunmap(new_memmap,
+				       efi.memmap.desc_size * new_nr_map);
+			efi_memmap_free(new_memmap_phy, new_nr_map, alloc_type);
+			return;
+		}
+	}
 
 	/* swap into new EFI memmap */
 	early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index d4e3e114cf86..05a556e63ec2 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -290,9 +290,11 @@ int __init efi_memmap_split_count(efi_memory_desc_t *md, struct range *range)
  *
  * It is suggested that you call efi_memmap_split_count() first
  * to see how large @buf needs to be.
+ *
+ * Returns zero on success, a negative error code on failure.
  */
-void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
-			      struct efi_mem_range *mem)
+int __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
+			     struct efi_mem_range *mem)
 {
 	u64 m_start, m_end, m_attr;
 	efi_memory_desc_t *md;
@@ -311,8 +313,9 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 	 */
 	if (!IS_ALIGNED(m_start, EFI_PAGE_SIZE) ||
 	    !IS_ALIGNED(m_end + 1, EFI_PAGE_SIZE)) {
-		WARN_ON(1);
-		return;
+		WARN(1, "Address 0x%llx - 0x%llx is not EFI_PAGE_SIZE aligned",
+		     m_start, m_end);
+		return -EINVAL;
 	}
 
 	for (old = old_memmap->map, new = buf;
@@ -379,4 +382,5 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 			md->attribute |= m_attr;
 		}
 	}
+	return 0;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c9752c67d184..bca955205a3f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1023,8 +1023,8 @@ extern int __init efi_memmap_install(phys_addr_t addr, unsigned int nr_map,
 				     enum efi_memmap_type alloc_type);
 extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
 					 struct range *range);
-extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
-				     void *buf, struct efi_mem_range *mem);
+extern int __init efi_memmap_insert(struct efi_memory_map *old_memmap,
+				    void *buf, struct efi_mem_range *mem);
 extern void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries,
 				   enum efi_memmap_type alloc_type);
 
-- 
2.7.4
