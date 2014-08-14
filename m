From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 4/7] arm64/efi: uefi_init error handling fix
Date: Thu, 14 Aug 2014 17:15:29 +0800
Message-ID: <1408007731-15081-4-git-send-email-dyoung@redhat.com>
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

There's one early memmap leak in uefi_init error path, fix it and slightly tune
the error handling code.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/arm64/kernel/efi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f310..6ed0362 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -89,7 +89,8 @@ static int __init uefi_init(void)
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
 		pr_err("System table signature incorrect\n");
-		return -EINVAL;
+		retval = -EINVAL;
+		goto out;
 	}
 	if ((efi.systab->hdr.revision >> 16) < 2)
 		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
@@ -103,6 +104,7 @@ static int __init uefi_init(void)
 		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = c16[i];
 		vendor[i] = '\0';
+		early_memunmap(c16, sizeof(vendor));
 	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
@@ -113,9 +115,8 @@ static int __init uefi_init(void)
 	if (retval == 0)
 		set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
-	early_memunmap(c16, sizeof(vendor));
+out:
 	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
-
 	return retval;
 }
 
-- 
1.8.3.1
