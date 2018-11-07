From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 6/6] efi: reduce the amount of memblock reservations for
 persistent allocations
Date: Wed,  7 Nov 2018 15:16:11 +0100
Message-ID: <20181107141611.12076-7-ard.biesheuvel@linaro.org>
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

The current implementation of efi_mem_reserve_persistent() is rather
naive, in the sense that for each invocation, it creates a separate
linked list entry to describe the reservation. Since the linked list
entries themselves need to persist across subsequent kexec reboots,
every reservation created this way results in two memblock_reserve()
calls at the next boot.

On arm64 systems with 100s of CPUs, this may result in a excessive
number of memblock reservations, and needless fragmentation.

So instead, make use of the newly updated struct linux_efi_memreserve
layout to put multiple reservations into a single linked list entry.
This should get rid of the numerous tiny memblock reservations, and
effectively cut the total number of reservations in half on arm64
systems with many CPUs.

Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 29 ++++++++++++++------
 include/linux/efi.h        |  3 ++
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 59f8ac93c759..347028cb392f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -978,22 +978,35 @@ static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
 int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv, *parent;
-	int rsvsize = EFI_MEMRESERVE_SIZE(1);
+	unsigned long prsv;
+	int index;
 
 	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	rsv = kmalloc(rsvsize, GFP_KERNEL);
-	if (!rsv)
-		return -ENOMEM;
-
 	parent = memremap(efi.mem_reserve, sizeof(*rsv), MEMREMAP_WB);
-	if (!parent) {
-		kfree(rsv);
+	if (!parent)
 		return -ENOMEM;
+
+	/* first try to find a slot in an existing linked list entry */
+	for (prsv = parent->next; prsv; prsv = rsv->next) {
+		rsv = __va(prsv);
+		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
+		if (index < rsv->size) {
+			rsv->entry[index].base = addr;
+			rsv->entry[index].size = size;
+
+			memunmap(parent);
+			return 0;
+		}
 	}
 
-	rsv->size = 1;
+	/* no slot found - allocate a new linked list entry */
+	rsv = (struct linux_efi_memreserve *)__get_free_page(GFP_KERNEL);
+	if (!rsv)
+		return -ENOMEM;
+
+	rsv->size = EFI_MEMRESERVE_COUNT(PAGE_SIZE);
 	atomic_set(&rsv->count, 1);
 	rsv->entry[0].base = addr;
 	rsv->entry[0].size = size;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index dfce82b2ca8a..1a1a081f7244 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1727,4 +1727,7 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_SIZE(count) (sizeof(struct linux_efi_memreserve) + \
 	(count) * sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
 
+#define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
+	/ sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
+
 #endif /* _LINUX_EFI_H */
-- 
2.19.1
