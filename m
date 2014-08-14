From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 2/7] Add a generic cmdline parse function parse_option_str
Date: Thu, 14 Aug 2014 17:15:27 +0800
Message-ID: <1408007731-15081-2-git-send-email-dyoung@redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Russ Anderson <rja@sgi.com>, Alessandro Zummo <a.zummo@towertech.it>, Randy Dunlap <rdunlap@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Daniel Kiper <daniel.kiper@oracle.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

There should be a generic function to parse params like a=b,c
Adding parse_option_str in lib/cmdline.c which will return true
if there's specified option set in the params.

Also updated efi=old_map parsing code to use the new function

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 22 ++--------------------
 include/linux/kernel.h      |  1 +
 lib/cmdline.c               | 29 +++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c90d3cd..c73a7df5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -932,26 +932,8 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 
 static int __init parse_efi_cmdline(char *str)
 {
-	if (*str == '=')
-		str++;
-
-	while (*str) {
-		if (!strncmp(str, "old_map", 7)) {
-			set_bit(EFI_OLD_MEMMAP, &efi.flags);
-			str += strlen("old_map");
-		}
-
-		/*
-		 * Skip any options we don't understand. Presumably
-		 * they apply to the EFI boot stub.
-		 */
-		while (*str && *str != ',')
-			str++;
-
-		/* If we hit a delimiter, skip it */
-		if (*str == ',')
-			str++;
-	}
+	if (parse_option_str(str, "old_map"))
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..d612718 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -407,6 +407,7 @@ int vsscanf(const char *, const char *, va_list);
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern bool parse_option_str(const char *str, const char *option);
 
 extern int core_kernel_text(unsigned long addr);
 extern int core_kernel_data(unsigned long addr);
diff --git a/lib/cmdline.c b/lib/cmdline.c
index d4932f7..7f1a182 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -155,3 +155,32 @@ unsigned long long memparse(const char *ptr, char **retptr)
 	return ret;
 }
 EXPORT_SYMBOL(memparse);
+
+/**
+ *	parse_option_str - Parse a string and check an option is set or not
+ *	@str: String to be parsed
+ *	@option: option name
+ *
+ *	This function parses a string containing a comma-separated list of
+ *	strings like a=b,c.
+ *
+ *	Return true if there's such option in the string, or return false.
+ */
+bool parse_option_str(const char *str, const char *option)
+{
+	while (*str) {
+		if (!strncmp(str, option, strlen(option))) {
+			str += strlen(option);
+			if (!*str || *str == ',')
+				return true;
+		}
+
+		while (*str && *str != ',')
+			str++;
+
+		if (*str == ',')
+			str++;
+	}
+
+	return false;
+}
-- 
1.8.3.1
