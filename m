From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] x86/efi: Fix trailing semicolons
Date: Tue, 23 Jan 2018 13:20:34 +0000
Message-ID: <20180123132034.21744-1-luisbg@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, Luis de Bethencourt <luisbg@kernel.org>
List-Id: linux-efi@vger.kernel.org

The trailing semicolon is an empty statement that does no operation.
Removing them since they don't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards 
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

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
