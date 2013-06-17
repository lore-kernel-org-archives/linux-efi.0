From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH -v2 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Mon, 17 Jun 2013 19:50:15 +0200
Message-ID: <1371491416-11037-4-git-send-email-bp@alien8.de>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1371491416-11037-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

.. for passing miscellaneous options from the kernel command line.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 82089d8b1954..5af5b97bf203 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -88,6 +88,11 @@ static u64 active_size;
 
 unsigned long x86_efi_facility;
 
+ /* 1:1 mapping of services regions */
+#define EFI_CFG_MAP11	BIT(0)
+
+static unsigned long efi_config;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -1167,3 +1172,17 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	return EFI_SUCCESS;
 }
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+
+#ifdef CONFIG_X86_64
+	if (!strncmp(str, "1:1_map", 7))
+		efi_config |= EFI_CFG_MAP11;
+#endif
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
-- 
1.8.3
