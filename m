From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: [PATCH v9 5/8] x86/boot: Add get_acpi_rsdp() to parse RSDP in cmdlien from kexec
Date: Wed, 17 Oct 2018 18:20:09 +0800
Message-ID: <20181017102012.872-6-fanc.fnst@cn.fujitsu.com>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com
Cc: indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com, fanc.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

If KEXEC write the RSDP pointer to cmdline, parse the cmdline
and use it.
Imitate from early_param of "acpi_rsdp".

Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/acpitb.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/boot/compressed/acpitb.c b/arch/x86/boot/compressed/acpitb.c
index 50fa65cf824d..37b1f4407be8 100644
--- a/arch/x86/boot/compressed/acpitb.c
+++ b/arch/x86/boot/compressed/acpitb.c
@@ -8,6 +8,9 @@
 #include <linux/numa.h>
 #include <linux/acpi.h>
 
+#define STATIC
+#include <linux/decompress/mm.h>
+
 /* Search EFI table for RSDP table. */
 static void efi_get_rsdp_addr(acpi_physical_address *rsdp_addr)
 {
@@ -200,3 +203,23 @@ static void bios_get_rsdp_addr(acpi_physical_address *rsdp_addr)
 		*rsdp_addr = (acpi_physical_address)address;
 	}
 }
+
+static void get_acpi_rsdp(acpi_physical_address *rsdp_addr)
+{
+#ifdef CONFIG_KEXEC
+	unsigned long long res;
+	int len = 0;
+	char *val;
+
+	val = malloc(20);
+	len = cmdline_find_option("acpi_rsdp", val, 20);
+
+	if (len == -1)
+		return;
+
+	if (len > 0) {
+		val[len] = 0;
+		*rsdp_addr = (acpi_physical_address)kstrtoull(val, 0, &res);
+	}
+#endif
+}
-- 
2.17.2
