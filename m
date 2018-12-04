From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 49/50] efi/libstub: Make file I/O chunking x86-specific
Date: Tue,  4 Dec 2018 11:50:44 +0100
Message-ID: <20181204103716.938039643@linuxfoundation.org>
References: <20181204103714.485546262@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204103714.485546262@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

(commit b3879a4d3a31ef14265a52e8d941cf4b0f6627ae upstream)

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

Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1486380166-31868-8-git-send-email-ard.biesheuvel@linaro.org
[ Small readability edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -356,6 +356,14 @@ efi_status_t efi_parse_options(char *cmd
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
@@ -528,7 +536,8 @@ efi_status_t handle_cmdline_files(efi_sy
 			size = files[j].size;
 			while (size) {
 				unsigned long chunksize;
-				if (size > __chunk_size)
+
+				if (IS_ENABLED(CONFIG_X86) && size > __chunk_size)
 					chunksize = __chunk_size;
 				else
 					chunksize = size;
