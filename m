From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/12] pstore: return error code (if any) from efi_pstore_write
Date: Tue,  4 Apr 2017 17:02:42 +0100
Message-ID: <20170404160245.27812-9-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Evgeny Kalugin <evgeny.kalugin@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Evgeny Kalugin <evgeny.kalugin@intel.com>

For some reason return value from actual variable setting was ignored.
With this change error code get transferred upwards through call stack.

Signed-off-by: Evgeny Kalugin <evgeny.kalugin@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi-pstore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index f402ba2eed46..6b5acefce6b3 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -274,9 +274,9 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      !pstore_cannot_block_path(reason),
-			      size, psi->buf);
+	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
+				    !pstore_cannot_block_path(reason),
+				    size, psi->buf);
 
 	if (reason == KMSG_DUMP_OOPS)
 		efivar_run_worker();
-- 
2.9.3
