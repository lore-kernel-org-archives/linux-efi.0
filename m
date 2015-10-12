From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 09/11] efi: Auto-load the efi-pstore module
Date: Mon, 12 Oct 2015 14:56:12 +0100
Message-ID: <1444658174-23378-10-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, "Lee, Chun-Yi" <jlee@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

efi-pstore should be auto-loaded on EFI systems, same as efivars.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efi-pstore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index e992abc5ef26..c8d794c58479 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -400,3 +400,4 @@ module_exit(efivars_pstore_exit);
 
 MODULE_DESCRIPTION("EFI variable backend for pstore");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:efivars");
-- 
2.1.0
