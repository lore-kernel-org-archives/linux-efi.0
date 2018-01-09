From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 4/4] efi: Rename efi_get_secureboot() to __efi_get_secureboot() and make it static
Date: Tue,  9 Jan 2018 15:22:25 +0100
Message-ID: <1515507745-17391-5-git-send-email-daniel.kiper@oracle.com>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: ard.biesheuvel@linaro.org, boris.ostrovsky@oracle.com, hpa@zytor.com, jgross@suse.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

This may help compiler to do some function call optimization.

This is rather cosmetic. If you like this patch apply.
If you do not you may ignore it.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/efi.c                             |    2 +-
 drivers/firmware/efi/libstub/secureboot-core.c |    2 +-
 drivers/firmware/efi/libstub/secureboot.c      |    5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 5ad2b8f..d45677f 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -141,7 +141,7 @@ void __init xen_efi_init(void)
 	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
 	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
 
-	boot_params.secure_boot = efi_get_secureboot(efi_systab_xen);
+	boot_params.secure_boot = __efi_get_secureboot(efi_systab_xen);
 
 	set_bit(EFI_BOOT, &efi.flags);
 	set_bit(EFI_PARAVIRT, &efi.flags);
diff --git a/drivers/firmware/efi/libstub/secureboot-core.c b/drivers/firmware/efi/libstub/secureboot-core.c
index d503ee4..07526a6 100644
--- a/drivers/firmware/efi/libstub/secureboot-core.c
+++ b/drivers/firmware/efi/libstub/secureboot-core.c
@@ -28,7 +28,7 @@
 /*
  * Determine whether we're in secure boot mode.
  */
-enum __sb_init efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+static enum __sb_init efi_secureboot_mode __efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
 	u32 attr;
 	u8 secboot, setupmode, moksbstate;
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 1142170..f872afd 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -23,3 +23,8 @@
 			 __VA_ARGS__);
 
 #include "secureboot-core.c"
+
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+{
+	return __efi_get_secureboot(sys_table_arg);
+}
-- 
1.7.10.4
