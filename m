From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] efi: Add EFI_SECURE_BOOT bit
Date: Wed, 24 May 2017 15:45:32 +0100
Message-ID: <149563713211.9419.13591529902587407094.stgit@warthog.procyon.org.uk>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149563711758.9419.11406612723056598045.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
that can be passed to efi_enabled() to find out whether secure boot is
enabled.

This will be used by the SysRq+x handler, registered by the x86 arch, to
find out whether secure boot mode is enabled so that it can be disabled.

Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/firmware/efi/secureboot.c |    1 +
 include/linux/efi.h               |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/secureboot.c b/drivers/firmware/efi/secureboot.c
index cf5bccae15e8..730518061a14 100644
--- a/drivers/firmware/efi/secureboot.c
+++ b/drivers/firmware/efi/secureboot.c
@@ -24,6 +24,7 @@ void __init efi_set_secure_boot(enum efi_secureboot_mode mode)
 			pr_info("Secure boot disabled\n");
 			break;
 		case efi_secureboot_mode_enabled:
+			set_bit(EFI_SECURE_BOOT, &efi.flags);
 			pr_info("Secure boot enabled\n");
 			break;
 		default:
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e2f53edccf15..5e9a2d7df089 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1081,6 +1081,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
 #define EFI_MEM_ATTR		10	/* Did firmware publish an EFI_MEMORY_ATTRIBUTES table? */
+#define EFI_SECURE_BOOT		11	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
