From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 6/6] key: enforce the secure boot checking when loading efi root key
Date: Sun,  5 Aug 2018 11:21:19 +0800
Message-ID: <20180805032119.20485-7-jlee@suse.com>
References: <20180805032119.20485-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

The EFI root key is not completely secure insecure when the
secure boot is disabled because it can be changed by unsigned EFI
binary before system be handed over to kernel. But in some use
case user does not want the EFI secure key functions be blocked
when secure boot is disabled.

Like the kernel module verification, this patch adds a enforce
kernel configuration option that it can be used to enforce kernel
to checking the secure boot before loading efi root key. And user
can also use kernel parameter to enable it. When this option be
enabled, the EFI root key will not be loaded by kernel when secure
boot is diabled.

Without this option, kernel will be tainted but the EFI root key
can still be loaded.

Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Ryan Chen <yu.chen.surf@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  6 +++++
 drivers/firmware/efi/Kconfig                    |  8 ++++++
 drivers/firmware/efi/efi-secure-key.c           | 33 ++++++++++++++++++++++---
 include/linux/kernel.h                          |  3 ++-
 kernel/panic.c                                  |  1 +
 5 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 533ff5c68970..7a9ac358793f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1122,6 +1122,12 @@
 			vendor GUIDs, all of them will be loaded. See
 			Documentation/acpi/ssdt-overlays.txt for details.
 
+	efi-secure-key.sb_enforce [EFI; X86]
+			When EFI_SECURE_KEY is set, this means that
+			EFI root key will not be loaded when secure boot is
+			not enabled. Note that if EFI_SECURE_KEY_SB_ENFORCE
+			is set, that is always true, so this option does
+			nothing.
 
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 048cf91ae8e8..fba894a4e7b0 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -187,6 +187,14 @@ config EFI_SECURE_KEY
 
 	  If unsure, say N.
 
+config EFI_SECURE_KEY_SB_ENFORCE
+	bool "Force checking secure boot when loading EFI root key"
+	default y
+	depends on EFI_SECURE_KEY
+	help
+	  Skip EFI root key when secure boot is not enabled. Without this,
+	  EFI root key will simply taint the kernel when no secure boot.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/efi-secure-key.c b/drivers/firmware/efi/efi-secure-key.c
index aa422ee87f70..417d73768887 100644
--- a/drivers/firmware/efi/efi-secure-key.c
+++ b/drivers/firmware/efi/efi-secure-key.c
@@ -15,6 +15,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
+#include <linux/moduleparam.h>
 #include <keys/efi-type.h>
 #include <keys/user-type.h>
 #include <crypto/algapi.h>
@@ -27,6 +28,9 @@ static unsigned long rkey_size;
 static bool is_loaded;
 static bool is_secure;
 
+static bool sb_enforce = IS_ENABLED(CONFIG_EFI_SECURE_KEY_SB_ENFORCE);
+module_param(sb_enforce, bool_enable_only, 0644);
+
 static void __init
 print_efi_rkey_setup_data(struct efi_rkey_setup_data *rkey_setup)
 {
@@ -59,11 +63,13 @@ void __init parse_efi_root_key_setup(u64 phys_addr, u32 data_len)
 
 	/* keep efi root key */
 	if (rkey_setup->final_status == EFI_SUCCESS) {
-		memcpy(root_key, rkey_setup->root_key, rkey_setup->key_size);
-		rkey_size = rkey_setup->key_size;
-		is_loaded = true;
 		is_secure = rkey_setup->is_secure;
-		pr_info("EFI root key is loaded.\n");
+		if (is_secure || !sb_enforce) {
+			memcpy(root_key, rkey_setup->root_key, rkey_setup->key_size);
+			rkey_size = rkey_setup->key_size;
+			is_loaded = true;
+			pr_info("EFI root key is loaded.\n");
+		}
 		if (!is_secure) {
 			pr_warn("EFI root key is insecure when no secure boot.\n");
 		}
@@ -75,6 +81,14 @@ void __init parse_efi_root_key_setup(u64 phys_addr, u32 data_len)
 	early_iounmap(setup_data, data_len);
 }
 
+static void __init clean_efi_root_key(void)
+{
+	memzero_explicit(root_key, ROOT_KEY_SIZE);
+	rkey_size = 0;
+	is_loaded = false;
+	is_secure = false;
+}
+
 #define ERK_HASH_SIZE SHA256_DIGEST_SIZE
 #define HMAC_HASH_SIZE SHA256_DIGEST_SIZE
 #define DKEY_SIZE SHA256_DIGEST_SIZE
@@ -705,6 +719,17 @@ static int __init init_efi_secure_key(void)
 	if (!is_loaded)
 		return 0;
 
+	if (!is_secure) {
+		if (sb_enforce) {
+			clean_efi_root_key();
+			pr_info("EFI root key is unloaded because insecure.\n");
+			return 0;
+		} else {
+			add_taint(TAINT_INSECURE_KEY, LOCKDEP_STILL_OK);
+			pr_warn("Tainted kernel because EFI root key is insecure.\n");
+		}
+	}
+
 	hash_tfm = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hash_tfm)) {
 		pr_err("can't allocate %s transform: %ld\n",
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 941dc0a5a877..b45716e54a97 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -565,7 +565,8 @@ extern enum system_states {
 #define TAINT_LIVEPATCH			15
 #define TAINT_AUX			16
 #define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
+#define TAINT_INSECURE_KEY		18
+#define TAINT_FLAGS_COUNT		19
 
 struct taint_flag {
 	char c_true;	/* character printed when tainted */
diff --git a/kernel/panic.c b/kernel/panic.c
index 8b2e002d52eb..d641098a814d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -327,6 +327,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
 	[ TAINT_AUX ]			= { 'X', ' ', true },
 	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
+	[TAINT_INSECURE_KEY]		= { 'Y', ' ', false },
 };
 
 /**
-- 
2.13.6
