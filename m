From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 1/5] efi: move noefi early param code out of x86 arch code
Date: Tue, 12 Aug 2014 14:10:18 +0800
Message-ID: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
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
To: Matt Fleming <matt.fleming@intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Randy Dunlap <rdunlap@infradead.org>, rtc-linux@googlegroups.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

noefi param can be used for arches other than X86 later, thus move it out of
x86 platform code.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 10 +---------
 drivers/firmware/efi/efi.c  | 13 +++++++++++++
 include/linux/efi.h         |  1 +
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94..dd7aaa1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -70,14 +70,6 @@ static efi_config_table_type_t arch_tables[] __initdata = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-static bool disable_runtime __initdata = false;
-static int __init setup_noefi(char *arg)
-{
-	disable_runtime = true;
-	return 0;
-}
-early_param("noefi", setup_noefi);
-
 int add_efi_memmap;
 EXPORT_SYMBOL(add_efi_memmap);
 
@@ -492,7 +484,7 @@ void __init efi_init(void)
 	if (!efi_runtime_supported())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (disable_runtime || efi_runtime_init())
+		if (efi_runtime_disabled() || efi_runtime_init())
 			return;
 	}
 	if (efi_memmap_init())
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb5..c8f01a7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -41,6 +41,19 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
+static bool disable_runtime;
+static int __init setup_noefi(char *arg)
+{
+	disable_runtime = true;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
+bool efi_runtime_disabled(void)
+{
+	return disable_runtime;
+}
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45cb4ff..06d7c03 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1227,4 +1227,5 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
+bool efi_runtime_disabled(void);
 #endif /* _LINUX_EFI_H */
-- 
1.8.3.1
