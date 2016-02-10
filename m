From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5sub3 3/4] efi: stub: use high allocation for converted command line
Date: Wed, 10 Feb 2016 18:55:04 +0100
Message-ID: <1455126905-22688-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1455126905-22688-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455126905-22688-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Before we can move the command line processing before the allocation
of the kernel, which is required for detecting the 'nokaslr' option
which controls that allocation, move the converted command line higher
up in memory, to prevent it from interfering with the kernel itself.

Since x86 needs the address to fit in 32 bits, use UINT_MAX as the upper
bound there. Otherwise, use ULONG_MAX (i.e., no limit)

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/include/asm/efi.h                     | 2 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0010c78c4998..08b1f2f6ea50 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -25,6 +25,8 @@
 #define EFI32_LOADER_SIGNATURE	"EL32"
 #define EFI64_LOADER_SIGNATURE	"EL64"
 
+#define MAX_CMDLINE_ADDRESS	UINT_MAX
+
 #ifdef CONFIG_X86_32
 
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f07d4a67fa76..29ed2f9b218c 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -649,6 +649,10 @@ static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
 	return dst;
 }
 
+#ifndef MAX_CMDLINE_ADDRESS
+#define MAX_CMDLINE_ADDRESS	ULONG_MAX
+#endif
+
 /*
  * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
@@ -684,7 +688,8 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 
 	options_bytes++;	/* NUL termination */
 
-	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
+	status = efi_high_alloc(sys_table_arg, options_bytes, 0,
+				&cmdline_addr, MAX_CMDLINE_ADDRESS);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-- 
2.5.0
