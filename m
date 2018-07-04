From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/2] efi/libstub: taken contents of LinuxExtraArgs UEFI
 variable into account
Date: Wed,  4 Jul 2018 17:49:19 +0200
Message-ID: <20180704154919.18564-3-ard.biesheuvel@linaro.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Geoff Levand <geoff@infradead.org>, catalin.marinas@arm.com, Riku Voipio <riku.voipio@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, will.deacon@arm.com, leif.lindholm@linaro.org, linux-acpi@vger.kernel.org, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

In order to allow UEFI platforms to persistently configure Linux kernel
options without relying on the contents of the EFI System Partition (ESP)
or other block devices, implement support for passing extra kernel
command line arguments via the LinuxExtraArgs UEFI variable.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 51 ++++++++++++++++++++
 include/linux/efi.h                            |  1 +
 2 files changed, 52 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 97a2423782af..49a3b03b9f1f 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -35,6 +35,9 @@ static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 static int __section(.data) __nokaslr;
 static int __section(.data) __quiet;
 
+static const efi_guid_t linux_args_guid = LINUX_EFI_EXTRA_ARGS_GUID;
+static const efi_char16_t linux_args_name[] = L"LinuxExtraArgs";
+
 int __pure nokaslr(void)
 {
 	return __nokaslr;
@@ -786,6 +789,33 @@ static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
 #define MAX_CMDLINE_ADDRESS	ULONG_MAX
 #endif
 
+static u16 *get_extra_args(efi_system_table_t *sys_table_arg,
+			   unsigned long *extra_args_size)
+{
+	u16 *extra_args;
+	efi_status_t status;
+
+	*extra_args_size = 0;
+	status = efi_call_runtime(get_variable, (efi_char16_t *)linux_args_name,
+				  (efi_guid_t *)&linux_args_guid, NULL,
+				  extra_args_size, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL)
+		return NULL;
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				*extra_args_size, (void **)&extra_args);
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	status = efi_call_runtime(get_variable, (efi_char16_t *)linux_args_name,
+				  (efi_guid_t *)&linux_args_guid, NULL,
+				  extra_args_size, extra_args);
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	return extra_args;
+}
+
 /*
  * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
@@ -799,9 +829,12 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 	unsigned long cmdline_addr = 0;
 	int load_options_chars = image->load_options_size / 2; /* UTF-16 */
 	const u16 *options = image->load_options;
+	u16 *extra_args;
 	int cmd_line_bytes = 0;  /* UTF-8 bytes */
 	int options_chars = 0;  /* UTF-16 chars */
+	int extra_args_chars = 0;  /* UTF-16 chars */
 	efi_status_t status;
+	unsigned long extra_args_size;
 	u16 zero = 0;
 
 	if (options)
@@ -813,6 +846,19 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 		options = &zero;
 	}
 
+	extra_args = get_extra_args(sys_table_arg, &extra_args_size);
+	if (extra_args) {
+		cmd_line_bytes += 1 + count_utf8_bytes(extra_args,
+						       extra_args_size / 2,
+						       &extra_args_chars);
+
+		pr_efi(sys_table_arg,
+		       "Appending contents of 'LinuxExtraArgs' UEFI variable to kernel command line.\n");
+	} else if (extra_args_size > 0) {
+		pr_efi_err(sys_table_arg,
+			   "Failed to read 'LinuxExtraArgs' UEFI variable\n");
+	}
+
 	cmd_line_bytes++;	/* NUL termination */
 
 	status = efi_high_alloc(sys_table_arg, cmd_line_bytes, 0,
@@ -821,6 +867,11 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 		return NULL;
 
 	s1 = efi_utf16_to_utf8((u8 *)cmdline_addr, options, options_chars);
+	if (extra_args) {
+		*s1++ = ' ';
+		s1 = efi_utf16_to_utf8(s1, extra_args, extra_args_chars);
+		efi_call_early(free_pool, extra_args);
+	}
 	*s1 = '\0';
 
 	*cmd_line_len = cmd_line_bytes;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 56add823f190..c0902384fa13 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -672,6 +672,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
 #define LINUX_EFI_RANDOM_SEED_TABLE_GUID	EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
 #define LINUX_EFI_TPM_EVENT_LOG_GUID		EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
+#define LINUX_EFI_EXTRA_ARGS_GUID		EFI_GUID(0x7cae4e6a, 0x08d7, 0x4079,  0x8e, 0xcd, 0x8c, 0x2e, 0xf4, 0x72, 0x30, 0x40)
 
 typedef struct {
 	efi_guid_t guid;
-- 
2.17.1
