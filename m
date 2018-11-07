From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 5/6] efi: permit multiple entries in persistent memreserve
 data structure
Date: Wed,  7 Nov 2018 15:16:10 +0100
Message-ID: <20181107141611.12076-6-ard.biesheuvel@linaro.org>
References: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc: marc.zyngier@arm.com, bhsharma@redhat.com, linux-efi@vger.kernel.org, will.deacon@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
 drivers/firmware/efi/efi.c              | 32 +++++++++++++-------
 drivers/firmware/efi/libstub/arm-stub.c |  2 +-
 include/linux/efi.h                     | 13 ++++++--
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 72a4da76d274..59f8ac93c759 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -602,21 +602,28 @@ int __init efi_apply_persistent_mem_reservations(void)
 
 		while (prsv) {
 			struct linux_efi_memreserve *rsv;
+			u8 *p;
+			int i;
 
-			/* reserve the entry itself */
-			memblock_reserve(prsv, sizeof(*rsv));
-
-			rsv = early_memremap(prsv, sizeof(*rsv));
-			if (rsv == NULL) {
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
 
@@ -971,11 +978,12 @@ static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
 int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv, *parent;
+	int rsvsize = EFI_MEMRESERVE_SIZE(1);
 
 	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	rsv = kmalloc(sizeof(*rsv), GFP_KERNEL);
+	rsv = kmalloc(rsvsize, GFP_KERNEL);
 	if (!rsv)
 		return -ENOMEM;
 
@@ -985,8 +993,10 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 		return -ENOMEM;
 	}
 
-	rsv->base = addr;
-	rsv->size = size;
+	rsv->size = 1;
+	atomic_set(&rsv->count, 1);
+	rsv->entry[0].base = addr;
+	rsv->entry[0].size = size;
 
 	spin_lock(&efi_mem_reserve_persistent_lock);
 	rsv->next = parent->next;
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 30ac0c975f8a..5bcfa08e8bb1 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -83,8 +83,8 @@ void install_memreserve_table(efi_system_table_t *sys_table_arg)
 	}
 
 	rsv->next = 0;
-	rsv->base = 0;
 	rsv->size = 0;
+	atomic_set(&rsv->count, 0);
 
 	status = efi_call_early(install_configuration_table,
 				&memreserve_table_guid,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 100ce4a4aff6..dfce82b2ca8a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1715,9 +1715,16 @@ extern struct efi_runtime_work efi_rts_work;
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
