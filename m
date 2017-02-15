From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: [PATCH 2/2] bgrt: Make ACPI BGRT parsing code common for ARCHs
Date: Wed, 15 Feb 2017 18:34:52 +0530
Message-ID: <1487163892-27701-3-git-send-email-bhsharma@redhat.com>
References: <1487163892-27701-1-git-send-email-bhsharma@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487163892-27701-1-git-send-email-bhsharma@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org
Cc: nicstange@gmail.com, leif.lindholm@linaro.org, sai.praneeth.prakhya@intel.com, pjones@redhat.com, bhupesh.linux@gmail.com, Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

This patch (2) of a patchset containing (2) patches, allows
the ACPI BGRT table parsing code to be invoked in a similar
fashion accross x86 and AARCH64 ARCHs (which can be later easily extended
for other ARCHs which support ACPI tables in future).

The approach has been tested on QEMU based VMs for both
x86 and AARCH64.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
---
 arch/arm64/kernel/acpi.c    | 3 +++
 arch/x86/kernel/acpi/boot.c | 6 ------
 drivers/acpi/Kconfig        | 2 +-
 drivers/acpi/bgrt.c         | 6 ++++++
 include/linux/efi-bgrt.h    | 2 ++
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 64d9cbd6..e25c11e 100644
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
index 7ff007e..4a6ee24 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1558,12 +1558,6 @@ int __init early_acpi_boot_init(void)
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
index 83e5f7e..dad02c0 100644
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
index ca28aa57..df1c629 100644
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
index 2fd3993..33640cd 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_ACPI_BGRT
 
 void efi_bgrt_init(struct acpi_table_header *table);
+int __init acpi_parse_bgrt(struct acpi_table_header *table);
 
 /* The BGRT data itself; only valid if bgrt_image != NULL. */
 extern size_t bgrt_image_size;
@@ -14,6 +15,7 @@ extern struct acpi_table_bgrt bgrt_tab;
 #else /* !CONFIG_ACPI_BGRT */
 
 static inline void efi_bgrt_init(struct acpi_table_header *table) {}
+static inline int __init acpi_parse_bgrt(struct acpi_table_header *table) {}
 
 #endif /* !CONFIG_ACPI_BGRT */
 
-- 
2.7.4
