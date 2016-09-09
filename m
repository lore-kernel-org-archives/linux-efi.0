From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 23/29] efi/arm64: Add debugfs node to dump UEFI runtime page tables
Date: Fri,  9 Sep 2016 16:18:45 +0100
Message-ID: <20160909151851.27577-24-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Register the debugfs node 'efi_page_tables' to allow the UEFI runtime
page tables to be inspected. Note that ARM does not have 'asm/ptdump.h'
[yet] so for now, this is arm64 only.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/arm-runtime.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index ae001450545f..7c75a8d9091a 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -39,6 +39,26 @@ static struct mm_struct efi_mm = {
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 };
 
+#ifdef CONFIG_ARM64_PTDUMP
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
2.9.3
