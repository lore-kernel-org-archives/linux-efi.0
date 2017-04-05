From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/24] efi: Add EFI_SECURE_BOOT bit
Date: Wed, 05 Apr 2017 18:07:10 +0100
Message-ID: <149141203027.30815.5857690501853492224.stgit@warthog.procyon.org.uk>
References: <149141201983.30815.1240162780237131881.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149141201983.30815.1240162780237131881.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
that can be passed to efi_enabled() to find out whether secure boot is
enabled.

This will be used by the SysRq+x handler, registered by the x86 arch, to find
out whether secure boot mode is enabled so that it can be disabled.

Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/x86/kernel/setup.c |    1 +
 include/linux/efi.h     |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4bf0c8926a1c..396285bddb93 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1184,6 +1184,7 @@ void __init setup_arch(char **cmdline_p)
 			pr_info("Secure boot disabled\n");
 			break;
 		case efi_secureboot_mode_enabled:
+			set_bit(EFI_SECURE_BOOT, &efi.flags);
 			pr_info("Secure boot enabled\n");
 			break;
 		default:
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0be24f..6049600e5475 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1069,6 +1069,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
 #define EFI_MEM_ATTR		10	/* Did firmware publish an EFI_MEMORY_ATTRIBUTES table? */
+#define EFI_SECURE_BOOT		11	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
