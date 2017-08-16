From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v10 1/2] efi: Introduce efi_early_memdesc_ptr to get pointer
 to memmap descriptor
Date: Wed, 16 Aug 2017 21:46:51 +0800
Message-ID: <20170816134651.GF21273@x1>
References: <1502722464-20614-1-git-send-email-bhe@redhat.com>
 <1502722464-20614-2-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502722464-20614-2-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, matt@codeblueprint.co.uk
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, hpa@zytor.com, izumi.taku@jp.fujitsu.com, fanc.fnst@cn.fujitsu.com, thgarnie@google.com, n-horiguchi@ah.jp.nec.com, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

The existing map iteration helper for_each_efi_memory_desc_in_map can
only be used after OS initializes EFI subsystem to fill data of struct
efi_memory_map. Before that we also need iterate map descriptors which
are stored in several intermediate structures, like struct efi_boot_memmap
for arch independent usage and struct efi_info for x86 arch only.

Introduce efi_early_memdesc_ptr to get pointer to a map descriptor, and
replace several places of open code with it.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
v9->v10:
  Use the 'EFI subsystem' instead of EFI since EFI usually means
  firmware. Here we are talking about EFI subsystem inside kernel.

 arch/x86/boot/compressed/eboot.c               |  2 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  4 ++--
 include/linux/efi.h                            | 21 +++++++++++++++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c3e869eaef0c..e007887a33b0 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -767,7 +767,7 @@ static efi_status_t setup_e820(struct boot_params *params,
 		m |= (u64)efi->efi_memmap_hi << 32;
 #endif
 
-		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
+		d = efi_early_memdesc_ptr(m, efi->efi_memdesc_size, i);
 		switch (d->type) {
 		case EFI_RESERVED_TYPE:
 		case EFI_RUNTIME_SERVICES_CODE:
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index b0184360efc6..50a9cab5a834 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -205,7 +205,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 		unsigned long m = (unsigned long)map;
 		u64 start, end;
 
-		desc = (efi_memory_desc_t *)(m + (i * desc_size));
+		desc = efi_early_memdesc_ptr(m, desc_size, i);
 		if (desc->type != EFI_CONVENTIONAL_MEMORY)
 			continue;
 
@@ -298,7 +298,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		unsigned long m = (unsigned long)map;
 		u64 start, end;
 
-		desc = (efi_memory_desc_t *)(m + (i * desc_size));
+		desc = efi_early_memdesc_ptr(m, desc_size, i);
 
 		if (desc->type != EFI_CONVENTIONAL_MEMORY)
 			continue;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8269bcb8ccf7..ec296bc96bc5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1020,6 +1020,27 @@ extern int efi_memattr_init(void);
 extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 					 efi_memattr_perm_setter fn);
 
+/*
+ * efi_early_memdesc_ptr - get the n-th efi memmap descriptor
+ * @map: the start of efi memmap
+ * @desc_size: the size of space for each efi memmap descriptor
+ * @n: the index of efi memmap descriptor
+ *
+ * EFI boot service provides function GetMemoryMap() to get a copy of the
+ * current memory map which is an array of memory descriptors, each of
+ * which describes a contiguous block of memory. And also get the size of
+ * map, and the size of each descriptor, etc. Note that per section 6.2 of
+ * UEFI Spec 2.6 Errata A, the returned size of each descriptor might not
+ * be equal to sizeof(efi_memory_memdesc_t) since efi_memory_memdesc_t may
+ * be extended in the future in response to hardware innovation. Thus OS
+ * MUST use the returned size of descriptor to find the start of each
+ * efi_memory_memdesc_t in the memory map array. This should only be used
+ * during bootup since for_each_efi_memory_desc_xxx is suggested after OS
+ * initializes EFI subsystem to fill data of struct efi_memory_map.
+ */
+#define efi_early_memdesc_ptr(map, desc_size, n)			\
+	(efi_memory_desc_t *)((void *)(map) + ((n) * (desc_size)))
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-- 
2.5.5
