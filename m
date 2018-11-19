From: Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 3/3] x86/ima: retry detecting secure boot mode
Date: Mon, 19 Nov 2018 14:56:11 -0500
Message-ID: <1542657371-7019-4-git-send-email-zohar@linux.ibm.com>
References: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542657371-7019-1-git-send-email-zohar@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com, seth.forshee@canonical.com, kexec@lists.infradead.org, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

The secure boot mode may not be detected on boot for some reason (eg.
buggy firmware).  This patch attempts one more time to detect the
secure boot mode.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 arch/x86/kernel/Makefile   |  2 ++
 arch/x86/kernel/ima_arch.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/ima.h        |  2 +-
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f0910a1e1db7..eb51b0e1189c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -151,4 +151,6 @@ ifeq ($(CONFIG_X86_64),y)
 	obj-y				+= vsmp_64.o
 endif
 
+ifdef CONFIG_EFI
 obj-$(CONFIG_IMA)			+= ima_arch.o
+endif
diff --git a/arch/x86/kernel/ima_arch.c b/arch/x86/kernel/ima_arch.c
index 6c248616ee57..e47cd9390ab4 100644
--- a/arch/x86/kernel/ima_arch.c
+++ b/arch/x86/kernel/ima_arch.c
@@ -7,10 +7,52 @@
 
 extern struct boot_params boot_params;
 
+static enum efi_secureboot_mode get_sb_mode(void)
+{
+	efi_char16_t efi_SecureBoot_name[] = L"SecureBoot";
+	efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+	efi_status_t status;
+	unsigned long size;
+	u8 secboot;
+
+	size = sizeof(secboot);
+
+	/* Get variable contents into buffer */
+	status = efi.get_variable(efi_SecureBoot_name, &efi_variable_guid,
+				  NULL, &size, &secboot);
+	if (status == EFI_NOT_FOUND) {
+		pr_info("ima: secureboot mode disabled\n");
+		return efi_secureboot_mode_disabled;
+	}
+
+	if (status != EFI_SUCCESS) {
+		pr_info("ima: secureboot mode unknown\n");
+		return efi_secureboot_mode_unknown;
+	}
+
+	if (secboot == 0) {
+		pr_info("ima: secureboot mode disabled\n");
+		return efi_secureboot_mode_disabled;
+	}
+
+	pr_info("ima: secureboot mode enabled\n");
+	return efi_secureboot_mode_enabled;
+}
+
 bool arch_ima_get_secureboot(void)
 {
-	if (efi_enabled(EFI_BOOT) &&
-		(boot_params.secure_boot == efi_secureboot_mode_enabled))
+	static enum efi_secureboot_mode sb_mode;
+	static bool initialized;
+
+	if (!initialized && efi_enabled(EFI_BOOT)) {
+		sb_mode = boot_params.secure_boot;
+
+		if (sb_mode == efi_secureboot_mode_unset)
+			sb_mode = get_sb_mode();
+		initialized = true;
+	}
+
+	if (sb_mode == efi_secureboot_mode_enabled)
 		return true;
 	else
 		return false;
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 5ab9134d4fd7..b5e16b8c50b7 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -30,7 +30,7 @@ extern void ima_post_path_mknod(struct dentry *dentry);
 extern void ima_add_kexec_buffer(struct kimage *image);
 #endif
 
-#ifdef CONFIG_X86
+#if defined(CONFIG_X86) && defined(CONFIG_EFI)
 extern bool arch_ima_get_secureboot(void);
 extern const char * const *arch_get_ima_policy(void);
 #else
-- 
2.7.5
