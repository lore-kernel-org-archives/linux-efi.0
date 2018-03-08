From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/12] efi/x86: Fix trailing semicolons
Date: Thu,  8 Mar 2018 08:00:12 +0000
Message-ID: <20180308080020.22828-5-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Luis de Bethencourt <luisbg@kernel.org>

The trailing semicolon is an empty statement that does no operation.
Removing them since they don't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 353e20c3f114..886a9115af62 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -439,7 +439,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
-	u32 *handles = (u32 *)uga_handle;;
+	u32 *handles = (u32 *)uga_handle;
 	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
@@ -484,7 +484,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
-	u64 *handles = (u64 *)uga_handle;;
+	u64 *handles = (u64 *)uga_handle;
 	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
-- 
2.15.1
