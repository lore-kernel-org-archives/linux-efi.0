From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 09/11] efi: permit multiple entries in persistent memreserve data structure
Date: Thu, 29 Nov 2018 18:12:28 +0100
Message-ID: <20181129171230.18699-10-ard.biesheuvel@linaro.org>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org

In preparation of updating efi_mem_reserve_persistent() to cause less
fragmentation when dealing with many persistent reservations, update
the struct definition and the code that handles it currently so it
can describe an arbitrary number of reservations using a single linked
list entry. The actual optimization will be implemented in a subsequent
patch.

Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c              | 39 +++++++++++++++++--------
 drivers/firmware/efi/libstub/arm-stub.c |  2 +-
 include/linux/efi.h                     | 13 +++++++--
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 415849bab233..80b11521627a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -602,21 +602,33 @@ int __init efi_apply_persistent_mem_reservations(void)
 
 		while (prsv) {
 			struct linux_efi_memreserve *rsv;
-
-			/* reserve the entry itself */
-			memblock_reserve(prsv, sizeof(*rsv));
-
-			rsv = early_memremap(prsv, sizeof(*rsv));
-			if (rsv == NULL) {
+			u8 *p;
+			int i;
+
+			/*
+			 * Just map a full page: that is what we will get
+			 * anyway, and it permits us to map the entire entry
+			 * before knowing its size.
+			 */
+			p = early_memremap(ALIGN_DOWN(prsv, PAGE_SIZE),
+					   PAGE_SIZE);
+			if (p == NULL) {
 				pr_err("Could not map UEFI memreserve entry!\n");
 				return -ENOMEM;
 			}
 
-			if (rsv->size)
-				memblock_reserve(rsv->base, rsv->size);
+			rsv = (void *)(p + prsv % PAGE_SIZE);
+
+			/* reserve the entry itself */
+			memblock_reserve(prsv, EFI_MEMRESERVE_SIZE(rsv->size));
+
+			for (i = 0; i < atomic_read(&rsv->count); i++) {
+				memblock_reserve(rsv->entry[i].base,
+						 rsv->entry[i].size);
+			}
 
 			prsv = rsv->next;
-			early_memunmap(rsv, sizeof(*rsv));
+			early_memunmap(p, PAGE_SIZE);
 		}
 	}
 
@@ -985,6 +997,7 @@ static int __init efi_memreserve_map_root(void)
 int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv;
+	int rsvsize = EFI_MEMRESERVE_SIZE(1);
 	int rc;
 
 	if (efi_memreserve_root == (void *)ULONG_MAX)
@@ -996,12 +1009,14 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 			return rc;
 	}
 
-	rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);
+	rsv = kmalloc(rsvsize, GFP_ATOMIC);
 	if (!rsv)
 		return -ENOMEM;
 
-	rsv->base = addr;
-	rsv->size = size;
+	rsv->size = 1;
+	atomic_set(&rsv->count, 1);
+	rsv->entry[0].base = addr;
+	rsv->entry[0].size = size;
 
 	spin_lock(&efi_mem_reserve_persistent_lock);
 	rsv->next = efi_memreserve_root->next;
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 3d36142cf812..9e20159ea5f5 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -86,8 +86,8 @@ void install_memreserve_table(efi_system_table_t *sys_table_arg)
 	}
 
 	rsv->next = 0;
-	rsv->base = 0;
 	rsv->size = 0;
+	atomic_set(&rsv->count, 0);
 
 	status = efi_call_early(install_configuration_table,
 				&memreserve_table_guid,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2b3b33c83b05..4f27640fdcdc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1712,9 +1712,16 @@ extern struct efi_runtime_work efi_rts_work;
 extern struct workqueue_struct *efi_rts_wq;
 
 struct linux_efi_memreserve {
-	phys_addr_t	next;
-	phys_addr_t	base;
-	phys_addr_t	size;
+	int		size;			// allocated size of the array
+	atomic_t	count;			// number of entries used
+	phys_addr_t	next;			// pa of next struct instance
+	struct {
+		phys_addr_t	base;
+		phys_addr_t	size;
+	} entry[0];
 };
 
+#define EFI_MEMRESERVE_SIZE(count) (sizeof(struct linux_efi_memreserve) + \
+	(count) * sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
+
 #endif /* _LINUX_EFI_H */
-- 
2.19.1
