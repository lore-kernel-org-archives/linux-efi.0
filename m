From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH] efi/fdt: Indentation fix
Date: Mon,  1 Oct 2018 11:29:36 +0100
Message-ID: <1538389776-8432-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Closing bracket seems to end a for statement when it is actually ending
the contained if.

No functional change/fix, just fix the indentation.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 8830fa6..3b8337c 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -381,7 +381,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 			}
 			*fdt_size = fdt_totalsize(fdt);
 			break;
-	 }
+		}

 	return fdt;
 }
--
1.9.1
