From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 17/29] x86/efi: Initialize status to ensure garbage is not returned on small size
Date: Fri,  9 Sep 2016 16:18:39 +0100
Message-ID: <20160909151851.27577-18-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Colin Ian King <colin.king@canonical.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Although very unlikey, if size is too small or zero, then we end up with
status not being set and returning garbage. Instead, initializing status to
EFI_INVALID_PARAMETER to indicate that size is invalid in the calls to
setup_uga32 and setup_uga64.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ff574dad95cc..ec6d2ef12baf 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -578,7 +578,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u32 *handles = (u32 *)uga_handle;;
-	efi_status_t status;
+	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
 	first_uga = NULL;
@@ -623,7 +623,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u64 *handles = (u64 *)uga_handle;;
-	efi_status_t status;
+	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
 	first_uga = NULL;
-- 
2.9.3
