From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/2] efi/libstub: refactor load option command line
 processing for reuse
Date: Wed,  4 Jul 2018 17:49:18 +0200
Message-ID: <20180704154919.18564-2-ard.biesheuvel@linaro.org>
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

As a preparatory step towards adding support for extra kernel command
line arguments passed via a UEFI variable, do a slight refactor of the
existing code so we can extend it more cleanly in a subsequent patch.
No change is functionality is intended.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 43 ++++++++++++--------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 50a9cab5a834..97a2423782af 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -726,6 +726,22 @@ static int efi_utf8_bytes(u16 c)
 	return 1 + (c >= 0x80) + (c >= 0x800);
 }
 
+/*
+ * Get an upper bound for the number of UTF-8 bytes corresponding
+ * to a \n or \0 terminated UTF-16 string.
+ */
+static int count_utf8_bytes(const u16 *s, int max_chars, int *num_chars)
+{
+	int ret = 0;
+
+	while (*s != '\0' && *s != '\n' && --max_chars >= 0) {
+		ret += efi_utf8_bytes(*s++);
+		++*num_chars;
+	}
+
+	return ret;
+}
+
 /*
  * Convert an UTF-16 string, not necessarily null terminated, to UTF-8.
  */
@@ -779,44 +795,35 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 			  efi_loaded_image_t *image,
 			  int *cmd_line_len)
 {
-	const u16 *s2;
-	u8 *s1 = NULL;
+	u8 *s1;
 	unsigned long cmdline_addr = 0;
 	int load_options_chars = image->load_options_size / 2; /* UTF-16 */
 	const u16 *options = image->load_options;
-	int options_bytes = 0;  /* UTF-8 bytes */
+	int cmd_line_bytes = 0;  /* UTF-8 bytes */
 	int options_chars = 0;  /* UTF-16 chars */
 	efi_status_t status;
 	u16 zero = 0;
 
-	if (options) {
-		s2 = options;
-		while (*s2 && *s2 != '\n'
-		       && options_chars < load_options_chars) {
-			options_bytes += efi_utf8_bytes(*s2++);
-			options_chars++;
-		}
-	}
+	if (options)
+		cmd_line_bytes = count_utf8_bytes(options, load_options_chars,
+						  &options_chars);
 
 	if (!options_chars) {
 		/* No command line options, so return empty string*/
 		options = &zero;
 	}
 
-	options_bytes++;	/* NUL termination */
+	cmd_line_bytes++;	/* NUL termination */
 
-	status = efi_high_alloc(sys_table_arg, options_bytes, 0,
+	status = efi_high_alloc(sys_table_arg, cmd_line_bytes, 0,
 				&cmdline_addr, MAX_CMDLINE_ADDRESS);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-	s1 = (u8 *)cmdline_addr;
-	s2 = (const u16 *)options;
-
-	s1 = efi_utf16_to_utf8(s1, s2, options_chars);
+	s1 = efi_utf16_to_utf8((u8 *)cmdline_addr, options, options_chars);
 	*s1 = '\0';
 
-	*cmd_line_len = options_bytes;
+	*cmd_line_len = cmd_line_bytes;
 	return (char *)cmdline_addr;
 }
 
-- 
2.17.1
