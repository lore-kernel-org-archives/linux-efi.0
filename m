From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 3/7] efi: add kernel param efi=noruntime
Date: Thu, 14 Aug 2014 17:15:28 +0800
Message-ID: <1408007731-15081-3-git-send-email-dyoung@redhat.com>
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

noefi kernel param means actually disabling efi runtime, Per suggestion from
Leif Lindholm efi=noruntime should be better. But since noefi is already used
in X86 thus just adding another param efi=noruntime for same purpose.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/kernel-parameters.txt | 3 ++-
 arch/x86/platform/efi/efi.c         | 4 ++--
 drivers/firmware/efi/efi.c          | 9 +++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 31c50c1..7afbf6a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -981,13 +981,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: {"off" | "on" | "skip[mbr]"}
 
 	efi=		[EFI]
-			Format: { "old_map", "nochunk" }
+			Format: { "old_map", "nochunk", "noruntime" }
 			old_map [X86-64]: switch to the old ioremap-based EFI
 			runtime services mapping. 32-bit still uses this one by
 			default.
 			nochunk: disable reading files in "chunks" in the EFI
 			boot stub, as chunking can cause problems with some
 			firmware implementations.
+			noruntime : disable EFI runtime services support
 
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c73a7df5..00f4cc5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -930,11 +930,11 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
-static int __init parse_efi_cmdline(char *str)
+static int __init arch_parse_efi_cmdline(char *str)
 {
 	if (parse_option_str(str, "old_map"))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
-early_param("efi", parse_efi_cmdline);
+early_param("efi", arch_parse_efi_cmdline);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1f396eb..49eb18b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -54,6 +54,15 @@ bool efi_runtime_disabled(void)
 	return disable_runtime;
 }
 
+static int __init parse_efi_cmdline(char *str)
+{
+	if (parse_option_str(str, "noruntime"))
+		disable_runtime = true;
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
-- 
1.8.3.1
