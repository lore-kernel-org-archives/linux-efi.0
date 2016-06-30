From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: arm64: add debugfs node to dump UEFI runtime page tables
Date: Thu, 30 Jun 2016 12:01:46 +0200
Message-ID: <1467280906-31158-1-git-send-email-ard.biesheuvel@linaro.org>
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
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, matt@codeblueprint.co.uk
Cc: leif.lindholm@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Register the debugfs node 'efi_page_tables' to allow the UEFI runtime
page tables to be inspected. Note that ARM does not have 'asm/ptdump.h'
[yet] so for now, this is arm64 only.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

This patch could be helpful in assessing the series 'arm64: avoid block
entries that we need to split later' that I sent out yesterday.

 drivers/firmware/efi/arm-runtime.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 17ccf0a8787a..4197a1da013d 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -39,6 +39,26 @@ static struct mm_struct efi_mm = {
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 };
 
+#ifdef CONFIG_ARM64
+#include <asm/ptdump.h>
+
+static struct ptdump_info efi_ptdump_info = {
+	.mm		= &efi_mm,
+	.markers	= (struct addr_marker[]){
+		{ 0,		"UEFI runtime start" },
+		{ TASK_SIZE_64,	"UEFI runtime end" }
+	},
+	.base_addr	= 0,
+};
+
+static int __init ptdump_init(void)
+{
+	return ptdump_register(&efi_ptdump_info, "efi_page_tables");
+}
+device_initcall(ptdump_init);
+
+#endif
+
 static bool __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
-- 
2.7.4
