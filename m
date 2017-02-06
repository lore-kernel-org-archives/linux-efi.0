From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/7] efi: libstub: Make file I/O chunking x86-specific
Date: Mon,  6 Feb 2017 11:22:46 +0000
Message-ID: <1486380166-31868-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486380166-31868-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The ARM decompressor is finicky when it comes to uninitialized variables
with local linkage, the reason being that it may relocate .text and .bss
independently when executing from ROM. This is only possible if all
references into .bss from .text are absolute, and this happens to be the
case for references emitted under -fpic to symbols with external linkage,
and so all .bss references must involve symbols with external linkage.

When building the ARM stub using clang, the initialized local variable
__chunk_size is optimized into a zero-initialized flag that indicates
whether chunking is in effect or not. This flag is therefore emitted into
.bss, which triggers the ARM decompressor's diagnostics, resulting in a
failed build.

Under UEFI, we never execute the decompressor from ROM, so the diagnostic
makes little sense here. But we can easily work around the issue by making
__chunk_size global instead.

However, given that the file I/O chunking that is controlled by the
__chunk_size variable is intended to work around known bugs on various
x86 implementations of UEFI, we can simply make the chunking an x86
specific feature. This is an improvement by itself, and also removes the
need to parse the efi= options in the stub entirely.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 6ee9164251a9..2a07b867bec7 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -414,6 +414,14 @@ efi_status_t efi_parse_options(char *cmdline)
 	char *str;
 
 	/*
+	 * Currently, the only efi= option we look for is 'nochunk', which
+	 * is intended to work around known issues on certain x86 UEFI
+	 * versions. So ignore for now on other architectures.
+	 */
+	if (!IS_ENABLED(CONFIG_X86))
+		return EFI_SUCCESS;
+
+	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
 	 */
@@ -586,7 +594,9 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			size = files[j].size;
 			while (size) {
 				unsigned long chunksize;
-				if (size > __chunk_size)
+
+				if (IS_ENABLED(CONFIG_X86) &&
+				    size > __chunk_size)
 					chunksize = __chunk_size;
 				else
 					chunksize = size;
-- 
2.7.4
