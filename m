From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/libstub: arm: don't randomize runtime regions when CONFIG_HIBERNATION=y
Date: Mon, 23 Oct 2017 10:03:28 +0100
Message-ID: <20171023090328.6701-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit

  e69176d68d26 ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region

implemented randomization of the virtual mapping that the OS chooses for
the UEFI runtime services. This was motivated by the fact that UEFI usually
does not bother to specify any permission restrictions for those regions,
making them prime real estate for exploitation now that the OS is getting
more and more careful not to leave any R+W+X mapped regions lying around.

However, this randomization breaks assumptions in the resume from
hibernation code, which expects all memory regions populated by UEFI to
remain in the same place, including their virtual mapping into the OS
memory space. While this assumption may not be entirely reasonable in the
first place, breaking it deliberately does not make a lot of sense either.
So let's refrain from this randomization pass if CONFIG_HIBERNATION=y.

Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm-stub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 3061e4057483..01a9d78ee415 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -238,7 +238,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
-	if (!nokaslr()) {
+	/* hibernation expects the runtime regions to stay in the same place */
+	if (!IS_ENABLED(CONFIG_HIBERNATION) && !nokaslr()) {
 		/*
 		 * Randomize the base of the UEFI runtime services region.
 		 * Preserve the 2 MB alignment of the region by taking a
-- 
2.11.0
