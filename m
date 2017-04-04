From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/12] efi: bgrt: Enable ACPI BGRT handling on arm64
Date: Tue,  4 Apr 2017 17:02:41 +0100
Message-ID: <20170404160245.27812-8-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Bhupesh Sharma <bhsharma@redhat.com>

Now that the ACPI BGRT handling code has been made generic, we can
enable it for arm64.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
[ardb: - update commit log to reflect that BGRT is only enabled for arm64
       - add missing 'return' statement to dummy acpi_parse_bgrt()]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/acpi.c    | 3 +++
 arch/x86/kernel/acpi/boot.c | 6 ------
 drivers/acpi/Kconfig        | 2 +-
 drivers/acpi/bgrt.c         | 6 ++++++
 include/linux/efi-bgrt.h    | 5 +++++
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 64d9cbd61678..e25c11e727fe 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/bootmem.h>
 #include <linux/cpumask.h>
+#include <linux/efi-bgrt.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
@@ -233,6 +234,8 @@ void __init acpi_boot_table_init(void)
 			early_init_dt_scan_chosen_stdout();
 	} else {
 		parse_spcr(earlycon_init_is_deferred);
+		if (IS_ENABLED(CONFIG_ACPI_BGRT))
+			acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
 	}
 }
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ae32838cac5f..a9d4fbcd1fd6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1559,12 +1559,6 @@ int __init early_acpi_boot_init(void)
 	return 0;
 }
 
-static int __init acpi_parse_bgrt(struct acpi_table_header *table)
-{
-	efi_bgrt_init(table);
-	return 0;
-}
-
 int __init acpi_boot_init(void)
 {
 	/* those are executed after early-quirks are executed */
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 83e5f7e1a20d..dad02c0f21b9 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -440,7 +440,7 @@ config ACPI_CUSTOM_METHOD
 
 config ACPI_BGRT
 	bool "Boottime Graphics Resource Table support"
-	depends on EFI && X86
+	depends on EFI && (X86 || ARM64)
         help
 	  This driver adds support for exposing the ACPI Boottime Graphics
 	  Resource Table, which allows the operating system to obtain
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index ca28aa572aa9..df1c629205e7 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -81,6 +81,12 @@ static struct attribute_group bgrt_attribute_group = {
 	.bin_attrs = bgrt_bin_attributes,
 };
 
+int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	efi_bgrt_init(table);
+	return 0;
+}
+
 static int __init bgrt_init(void)
 {
 	int ret;
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index 2fd3993c370b..e6f624b53c3d 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_ACPI_BGRT
 
 void efi_bgrt_init(struct acpi_table_header *table);
+int __init acpi_parse_bgrt(struct acpi_table_header *table);
 
 /* The BGRT data itself; only valid if bgrt_image != NULL. */
 extern size_t bgrt_image_size;
@@ -14,6 +15,10 @@ extern struct acpi_table_bgrt bgrt_tab;
 #else /* !CONFIG_ACPI_BGRT */
 
 static inline void efi_bgrt_init(struct acpi_table_header *table) {}
+static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	return 0;
+}
 
 #endif /* !CONFIG_ACPI_BGRT */
 
-- 
2.9.3
