From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 3/4] efi: Tweak efi_get_secureboot() and its data section assignment
Date: Tue,  9 Jan 2018 15:22:24 +0100
Message-ID: <1515507745-17391-4-git-send-email-daniel.kiper@oracle.com>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: ard.biesheuvel@linaro.org, boris.ostrovsky@oracle.com, hpa@zytor.com, jgross@suse.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

Otherwise they are not freed after the kernel proper init.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/efi.c                             |    3 +++
 drivers/firmware/efi/libstub/secureboot-core.c |   12 ++++++------
 drivers/firmware/efi/libstub/secureboot.c      |    3 +++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index e089fa7..5ad2b8f 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -28,6 +28,9 @@
 #include <asm/setup.h>
 #include <asm/xen/hypercall.h>
 
+#define __sb_init	__init
+#define __sb_initconst	__initconst
+
 #define pr_efi(sys_table, msg)
 #define pr_efi_err(sys_table, msg)
 
diff --git a/drivers/firmware/efi/libstub/secureboot-core.c b/drivers/firmware/efi/libstub/secureboot-core.c
index 11a4feb..d503ee4 100644
--- a/drivers/firmware/efi/libstub/secureboot-core.c
+++ b/drivers/firmware/efi/libstub/secureboot-core.c
@@ -11,24 +11,24 @@
  */
 
 /* BIOS variables */
-static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
-static const efi_char16_t efi_SecureBoot_name[] = {
+static const efi_guid_t efi_variable_guid __sb_initconst = EFI_GLOBAL_VARIABLE_GUID;
+static const efi_char16_t efi_SecureBoot_name[] __sb_initconst = {
 	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
 };
-static const efi_char16_t efi_SetupMode_name[] = {
+static const efi_char16_t efi_SetupMode_name[] __sb_initconst = {
 	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
 };
 
 /* SHIM variables */
-static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static const efi_char16_t shim_MokSBState_name[] = {
+static const efi_guid_t shim_guid __sb_initconst = EFI_SHIM_LOCK_GUID;
+static const efi_char16_t shim_MokSBState_name[] __sb_initconst = {
 	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
 };
 
 /*
  * Determine whether we're in secure boot mode.
  */
-enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+enum __sb_init efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
 	u32 attr;
 	u8 secboot, setupmode, moksbstate;
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 4a6159f..1142170 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -14,6 +14,9 @@
 
 #include "efistub.h"
 
+#define __sb_init
+#define __sb_initconst
+
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
 			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
-- 
1.7.10.4
