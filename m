From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] efi: Add EFI_SECURE_BOOT bit
Date: Thu, 06 Apr 2017 13:50:05 +0100
Message-ID: <149148300512.3427.7213689013157799404.stgit@warthog.procyon.org.uk>
References: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
that can be passed to efi_enabled() to find out whether secure boot is
enabled.

This will be used by the SysRq+x handler, registered by the x86 arch, to
find out whether secure boot mode is enabled so that it can be disabled.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-efi@vger.kernel.org
---

 drivers/firmware/efi/secure_boot.c |    1 +
 include/linux/efi.h                |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/secure_boot.c b/drivers/firmware/efi/secure_boot.c
index cf5bccae15e8..730518061a14 100644
--- a/drivers/firmware/efi/secure_boot.c
+++ b/drivers/firmware/efi/secure_boot.c
@@ -24,6 +24,7 @@ void __init efi_set_secure_boot(enum efi_secureboot_mode mode)
 			pr_info("Secure boot disabled\n");
 			break;
 		case efi_secureboot_mode_enabled:
+			set_bit(EFI_SECURE_BOOT, &efi.flags);
 			pr_info("Secure boot enabled\n");
 			break;
 		default:
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d8938a780290..536a10111bde 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1069,6 +1069,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
 #define EFI_MEM_ATTR		10	/* Did firmware publish an EFI_MEMORY_ATTRIBUTES table? */
+#define EFI_SECURE_BOOT		11	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*

