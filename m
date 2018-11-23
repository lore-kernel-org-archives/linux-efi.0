From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] efi: prevent GICv3 WARN() by mapping memreserve table before first use
Date: Fri, 23 Nov 2018 22:51:32 +0100
Message-ID: <20181123215132.7951-2-ard.biesheuvel@linaro.org>
References: <20181123215132.7951-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181123215132.7951-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Mapping the MEMRESERVE EFI configuration table from an early initcall
is too late: the GICv3 ITS code that creates persistent reservations
for the boot CPU's LPI tables is invoked from init_IRQ(), which runs
much earlier than the handling of the initcalls. This results in a
WARN() splat because the LPI tables cannot be reserved persistently,
which will result in silent memory corruption after a kexec reboot.

So instead, invoke the initialization performed by the initcall from
efi_mem_reserve_persistent() itself as well, but keep the initcall so
that the init is guaranteed to have been called before SMP boot.

Fixes: 63eb322d89c8 ("efi: Permit calling efi_mem_reserve_persistent() ...")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Jan Glauber <jglauber@cavium.com>
Tested-by: John Garry <john.garry@huawei.com>
---
 drivers/firmware/efi/efi.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fad7c62cfc0e..415849bab233 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -969,13 +969,33 @@ bool efi_is_table_address(unsigned long phys_addr)
 static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
 static struct linux_efi_memreserve *efi_memreserve_root __ro_after_init;
 
-int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
+static int __init efi_memreserve_map_root(void)
+{
+	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
+		return -ENODEV;
+
+	efi_memreserve_root = memremap(efi.mem_reserve,
+				       sizeof(*efi_memreserve_root),
+				       MEMREMAP_WB);
+	if (WARN_ON_ONCE(!efi_memreserve_root))
+		return -ENOMEM;
+	return 0;
+}
+
+int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 {
 	struct linux_efi_memreserve *rsv;
+	int rc;
 
-	if (!efi_memreserve_root)
+	if (efi_memreserve_root == (void *)ULONG_MAX)
 		return -ENODEV;
 
+	if (!efi_memreserve_root) {
+		rc = efi_memreserve_map_root();
+		if (rc)
+			return rc;
+	}
+
 	rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);
 	if (!rsv)
 		return -ENOMEM;
@@ -993,14 +1013,10 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 
 static int __init efi_memreserve_root_init(void)
 {
-	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
-		return -ENODEV;
-
-	efi_memreserve_root = memremap(efi.mem_reserve,
-				       sizeof(*efi_memreserve_root),
-				       MEMREMAP_WB);
-	if (!efi_memreserve_root)
-		return -ENOMEM;
+	if (efi_memreserve_root)
+		return 0;
+	if (efi_memreserve_map_root())
+		efi_memreserve_root = (void *)ULONG_MAX;
 	return 0;
 }
 early_initcall(efi_memreserve_root_init);
-- 
2.19.1
