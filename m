From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/4] efi/arm: re-enable the memreserve table for 32-bit ARM
Date: Mon, 10 Dec 2018 17:29:49 +0100
Message-ID: <20181210162949.8597-5-ard.biesheuvel@linaro.org>
References: <20181210162949.8597-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181210162949.8597-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-efi@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Now that we have readded the call to efi_apply_persistent_mem_reservations
in the 32-bit ARM boot path in a place where potentially creating
many memblock reservations is permissible, re-enable the MEMRESERVE
table in the 32-bit ARM EFI stub. This brings ARM back in line with
arm64 in terms of support for efi_mem_reserve_persistent().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 3d36142cf812..30ac0c975f8a 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -75,9 +75,6 @@ void install_memreserve_table(efi_system_table_t *sys_table_arg)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
-	if (IS_ENABLED(CONFIG_ARM))
-		return;
-
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 				(void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.19.2
