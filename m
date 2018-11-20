From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFT PATCH v2] efi: map memreserve table before first use
Date: Tue, 20 Nov 2018 20:16:34 +0100
Message-ID: <20181120191634.7376-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: marc.zyngier@arm.com, john.garry@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, Jan.Glauber@cavium.com
List-Id: linux-efi@vger.kernel.org

Mapping the MEMRESERVE EFI configuration table from an early initcall
is too late: the GICv3 ITS code that creates persistent reservations
for the boot CPU's LPI tables is invoked from init_IRQ(), which runs
much earlier than the handling of the initcalls.

So instead, move the initialization performed by the initcall into
efi_mem_reserve_persistent() itself, but keep the initcall as well
so that the init is guaranteed to have been called before SMP boot.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fad7c62cfc0e..0e2d52a0c50e 100644
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
@@ -993,14 +1013,12 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 
 static int __init efi_memreserve_root_init(void)
 {
-	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
-		return -ENODEV;
+	if (efi_memreserve_root)
+		return 0;
 
-	efi_memreserve_root = memremap(efi.mem_reserve,
-				       sizeof(*efi_memreserve_root),
-				       MEMREMAP_WB);
+	efi_memreserve_map_root();
 	if (!efi_memreserve_root)
-		return -ENOMEM;
+		efi_memreserve_root = (void *)ULONG_MAX;
 	return 0;
 }
 early_initcall(efi_memreserve_root_init);
-- 
2.17.1
