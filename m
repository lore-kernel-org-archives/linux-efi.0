From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] firmware: efi: arm-runtime: fix build error void value not ignored
Date: Mon,  4 Feb 2019 14:29:04 +0100
Message-ID: <20190204132904.9288-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-efi@vger.kernel.org

Commit e2a2e56e4082 ("arm64: dump: no need to check return value of debugfs_create functions")
changed the return value from 'int' to 'void'.

../drivers/firmware/efi/arm-runtime.c: In function ‘ptdump_init’:
../drivers/firmware/efi/arm-runtime.c:52:9: error: void value not ignored as it ought to be
  return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/firmware/efi/arm-runtime.c:53:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^

Rework so that function 'ptdump_init' doesn't 'return
ptdump_debug_fs_register(...' since the function can work or not, but
the code logic should never do something different based on this.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/firmware/efi/arm-runtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 352bd2473162..b9ae798192d6 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -49,7 +49,8 @@ static int __init ptdump_init(void)
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
-	return ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
+	ptdump_debugfs_register(&efi_ptdump_info, "efi_page_tables");
+	return 0;
 }
 device_initcall(ptdump_init);
 
-- 
2.20.1
