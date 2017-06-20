From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 1/2] efi: Process MEMATTR table only if EFI_MEMMAP
Date: Tue, 20 Jun 2017 22:14:27 +0200
Message-ID: <1497989668-6238-2-git-send-email-daniel.kiper@oracle.com>
References: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

Otherwise e.g. Xen dom0 on x86_64 EFI platforms crashes.

In theory we can check EFI_PARAVIRT too, however,
EFI_MEMMAP looks more generic and covers more cases.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/firmware/efi/efi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b372aad..045d6d3 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -528,7 +528,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
-	efi_memattr_init();
+	if (efi_enabled(EFI_MEMMAP))
+		efi_memattr_init();
 
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
-- 
1.7.10.4
