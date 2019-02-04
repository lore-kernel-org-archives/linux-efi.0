From: Qian Cai <cai@lca.pw>
Subject: [PATCH -next] efi/arm64: return zero from ptdump_init()
Date: Mon,  4 Feb 2019 16:01:01 -0500
Message-ID: <20190204210101.61733-1-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
List-Id: linux-efi@vger.kernel.org

The commit e2a2e56e4082 ("arm64: dump: no need to check return value of
debugfs_create functions") converted ptdump_debugfs_register() from
void, but forgot to fix the efi version of ptdump_init().

drivers/firmware/efi/arm-runtime.c: In function 'ptdump_init':
drivers/firmware/efi/arm-runtime.c:52:9: error: void value not ignored as it ought to be
   52 |  return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/firmware/efi/arm-runtime.c:53:1: warning: control reaches end of non-void function [-Wreturn-type]

Fixes: e2a2e56e4082 ("arm64: dump: no need to check return value of debugfs_create functions")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/firmware/efi/arm-runtime.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 352bd2473162..b308f5bb3737 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -46,10 +46,10 @@ static struct ptdump_info efi_ptdump_info = {
 
 static int __init ptdump_init(void)
 {
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
-		return 0;
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
 
-	return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
+	return 0;
 }
 device_initcall(ptdump_init);
 
-- 
2.17.2 (Apple Git-113)
