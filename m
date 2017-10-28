From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH] efi: setting secure boot flag in EFI stub when the sentinel is tainted.
Date: Sat, 28 Oct 2017 20:34:19 +0800
Message-ID: <20171028123419.5696-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

We knew that old grub2 doesn't initialize the boot_params correctly
(reference to brc#1418360). It causes sanitize_boot_params() to be
triggered so that the secure_boot entry in boot_params be cleared.

This is a bootloader problem. When the issue occurred, it doesn't have
any symptom. The EFI secure boot flag in kernel just invalid at runtime.

This patch adds logic to EFI stub for checking the value of sentinel.
When sentinel was tainted, the secure_boot flag from boot loader should
be discarded then EFI stub gets secure boot flag again.

In later sanitize_boot_params(), the secure boot flag can be kept when
the secure mode is not _unset_. Therefore the flag value from EFI stub
can also be kept.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=1418360
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       | 3 ++-
 arch/x86/include/asm/bootparam_utils.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index e56dbc6..40c6570 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -994,7 +994,8 @@ struct boot_params *efi_main(struct efi_config *c,
 	 * If the boot loader gave us a value for secure_boot then we use that,
 	 * otherwise we ask the BIOS.
 	 */
-	if (boot_params->secure_boot == efi_secureboot_mode_unset)
+	if (boot_params->secure_boot == efi_secureboot_mode_unset ||
+	    boot_params->sentinel)
 		boot_params->secure_boot = efi_get_secureboot(sys_table);
 
 	/* Ask the firmware to clear memory on unclean shutdown */
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 4a8cb8d..42e1b09 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -34,6 +34,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 	 * problems again.
 	 */
 	if (boot_params->sentinel) {
+		__u8 secure_boot = boot_params->secure_boot;
 		/* fields in boot_params are left uninitialized, clear them */
 		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
@@ -48,6 +49,8 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 		       (char *)&boot_params->eddbuf[0] -
 			(char *)&boot_params->_pad8[0]);
 		memset(&boot_params->_pad9[0], 0, sizeof(boot_params->_pad9));
+		if (secure_boot)
+			boot_params->secure_boot = secure_boot;
 	}
 }
 
-- 
2.10.2
