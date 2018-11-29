From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/11] efi: reduce the amount of memblock reservations for persistent allocations
Date: Thu, 29 Nov 2018 18:12:29 +0100
Message-ID: <20181129171230.18699-11-ard.biesheuvel@linaro.org>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
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
 drivers/firmware/efi/efi.c | 20 +++++++++++++++++---
 include/linux/efi.h        |  3 +++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 80b11521627a..e90bc32c2670 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -998,7 +998,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv;
 	int rsvsize = EFI_MEMRESERVE_SIZE(1);
-	int rc;
+	unsigned long prsv;
+	int rc, index;
 
 	if (efi_memreserve_root == (void *)ULONG_MAX)
 		return -ENODEV;
@@ -1009,11 +1010,24 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 			return rc;
 	}
 
-	rsv = kmalloc(rsvsize, GFP_ATOMIC);
+	/* first try to find a slot in an existing linked list entry */
+	for (prsv = efi_memreserve_root->next; prsv; prsv = rsv->next) {
+		rsv = __va(prsv);
+		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
+		if (index < rsv->size) {
+			rsv->entry[index].base = addr;
+			rsv->entry[index].size = size;
+
+			return 0;
+		}
+	}
+
+	/* no slot found - allocate a new linked list entry */
+	rsv = (struct linux_efi_memreserve *)__get_free_page(GFP_ATOMIC);
 	if (!rsv)
 		return -ENOMEM;
 
-	rsv->size = 1;
+	rsv->size = EFI_MEMRESERVE_COUNT(PAGE_SIZE);
 	atomic_set(&rsv->count, 1);
 	rsv->entry[0].base = addr;
 	rsv->entry[0].size = size;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4f27640fdcdc..becd5d76a207 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1724,4 +1724,7 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_SIZE(count) (sizeof(struct linux_efi_memreserve) + \
 	(count) * sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
 
+#define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
+	/ sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
+
 #endif /* _LINUX_EFI_H */
-- 
2.19.1
