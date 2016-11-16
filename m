From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/16] efi: Add EFI_SECURE_BOOT bit
Date: Wed, 16 Nov 2016 21:47:52 +0000
Message-ID: <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
for use with efi_enabled.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/setup.c |    1 +
 include/linux/efi.h     |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9521acce8378..539f29587712 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1164,6 +1164,7 @@ void __init setup_arch(char **cmdline_p)
 	if (boot_params.secure_boot &&
 	    IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
 		lock_kernel_down();
+		set_bit(EFI_SECURE_BOOT, &efi.flags);
 		pr_info("Secure boot enabled\n");
 	}
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 11372fb8784c..5d7fb3e3400b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1079,6 +1079,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_SECURE_BOOT		10	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
