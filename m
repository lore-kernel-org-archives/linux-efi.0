From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 2/2] x86/efi: Delete ACPI BGRT when booting via kexec
Date: Wed, 17 Feb 2016 15:45:10 +0000
Message-ID: <1455723910-16710-3-git-send-email-matt@codeblueprint.co.uk>
References: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1455723910-16710-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Dave reports that for kexec reboot the ACPI BGRT image region may
contain garbage data, because the image lives in EFI Boot Services
regions that were released and freed when the first kernel called
efi_free_boot_services().

Since the EFI Boot Services regions can be large (multiple gigabytes)
preserving them throughout the kernel's lifetime and across kexec
reboot is not a viable solution. Instead we need to avoid accessing
the BGRT image regions under kexec.

Rather than dirtying the ACPI BGRT driver with conditionals that check
whether we're booting via kexec, we can execute the existing code path
that exits if the table cannot be found - by removing the BGRT table.

It is unfortunate that this logic cannot be folded into the existing
kexec-specific EFI code, but there are dependencies on having loaded
the ACPI tables, which happens much later.

Reported-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     |  4 +++-
 arch/x86/platform/efi/efi.c | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 7bb206f73915..0e813da58be6 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -146,6 +146,7 @@ extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
+extern void __init efi_kexec_remove_acpi_tables(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3d80e6d42a2..8131962ce8c2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1249,8 +1249,10 @@ void __init setup_arch(char **cmdline_p)
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
-	if (efi_enabled(EFI_BOOT))
+	if (efi_enabled(EFI_BOOT)) {
 		efi_apply_memmap_quirks();
+		efi_kexec_remove_acpi_tables();
+	}
 #endif
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 39748d228e34..d87f42697ad0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -485,6 +485,44 @@ static int __init efi_kexec_override(void)
 	return 0;
 }
 
+/*
+ * The BGRT table, if present, refers to memory regions that are no
+ * longer reserved during kexec boot, having been released by the
+ * previous kernel. The BGRT image likely contains garbage.
+ *
+ * Delete the ACPI table, since it is useless for kexec, and so that
+ * it is impossible for the ACPI BGRT driver to distinguish between
+ * "Platform has no BGRT" and "We were booted via kexec".
+ *
+ * Note that this function must only be called after the ACPI tables
+ * have been initialised.
+ */
+void __init efi_kexec_remove_acpi_tables(void)
+{
+	struct acpi_table_header *header;
+	acpi_status status;
+
+	if (!efi_setup)
+		return;
+
+	status = acpi_get_table(ACPI_SIG_BGRT, 0, &header);
+	if (ACPI_FAILURE(status))
+		return;
+
+	status = acpi_remove_table(ACPI_SIG_BGRT, 0);
+	if (ACPI_FAILURE(status)) {
+		pr_err("Failed to remove ACPI BGRT table\n");
+		return;
+	}
+
+	/*
+	 * Since we've probably already told the user that we have a
+	 * BGRT when parsing the ACPI tables, inform them that we have
+	 * intentionally removed it now.
+	 */
+	pr_info("Removed ACPI BGRT table for kexec\n");
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
-- 
2.6.2
