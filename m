From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: libstub: Make file I/O chunking x86-specific
Date: Tue, 31 Jan 2017 15:52:29 +0000
Message-ID: <1485877949-21981-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: matt@codeblueprint.co.uk, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 757badc1debb..5a418a6a33bf 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -351,6 +351,14 @@ efi_status_t efi_parse_options(char *cmdline)
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
@@ -523,7 +531,9 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
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
