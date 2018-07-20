From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/9] efi/x86: align efi_uga_draw_protocol typedef names to convention
Date: Fri, 20 Jul 2018 10:47:20 +0900
Message-ID: <20180720014726.24031-4-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

The linux-efi subsystem uses typedefs with the _t suffix to declare
data structures that originate in the UEFI spec. Our type mangling
for mixed mode depends on this convention, so rename the UGA drawing
protocols to allow efi_call_proto() to be used with them in a
subsequent patch.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c |  4 ++--
 arch/x86/boot/compressed/eboot.h | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c72550783c16..011d5c289449 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -321,7 +321,7 @@ static void setup_quirks(struct boot_params *boot_params)
 static efi_status_t
 setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
-	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
+	efi_uga_draw_protocol_t *uga = NULL, *first_uga;
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u32 *handles = (u32 *)uga_handle;
@@ -366,7 +366,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 static efi_status_t
 setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
-	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
+	efi_uga_draw_protocol_t *uga = NULL, *first_uga;
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u64 *handles = (u64 *)uga_handle;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index e799dc5c6448..8297387c4676 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -12,22 +12,22 @@
 
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
-struct efi_uga_draw_protocol_32 {
+typedef struct {
 	u32 get_mode;
 	u32 set_mode;
 	u32 blt;
-};
+} efi_uga_draw_protocol_32_t;
 
-struct efi_uga_draw_protocol_64 {
+typedef struct {
 	u64 get_mode;
 	u64 set_mode;
 	u64 blt;
-};
+} efi_uga_draw_protocol_64_t;
 
-struct efi_uga_draw_protocol {
+typedef struct {
 	void *get_mode;
 	void *set_mode;
 	void *blt;
-};
+} efi_uga_draw_protocol_t;
 
 #endif /* BOOT_COMPRESSED_EBOOT_H */
-- 
2.17.1
