From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Wed, 30 Jul 2014 12:59:02 +0200
Message-ID: <1406717944-24725-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406717944-24725-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

In certain cases the cpu-release-addr of a CPU may not fall in the
linear mapping (e.g. when the kernel is loaded above this address due to
the presence of other images in memory). This is problematic for the
spin-table code as it assumes that it can trivially convert a
cpu-release-addr to a valid VA in the linear map.

This patch modifies the spin-table code to use a temporary cached
mapping to write to a given cpu-release-addr, enabling us to support
addresses regardless of whether they are covered by the linear mapping.

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
[ardb: added (__force void *) cast]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/smp_spin_table.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index 0347d38eea29..4f93c67e63de 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/smp.h>
+#include <linux/types.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
@@ -65,12 +66,21 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 
 static int smp_spin_table_cpu_prepare(unsigned int cpu)
 {
-	void **release_addr;
+	__le64 __iomem *release_addr;
 
 	if (!cpu_release_addr[cpu])
 		return -ENODEV;
 
-	release_addr = __va(cpu_release_addr[cpu]);
+	/*
+	 * The cpu-release-addr may or may not be inside the linear mapping.
+	 * As ioremap_cache will either give us a new mapping or reuse the
+	 * existing linear mapping, we can use it to cover both cases. In
+	 * either case the memory will be MT_NORMAL.
+	 */
+	release_addr = ioremap_cache(cpu_release_addr[cpu],
+				     sizeof(*release_addr));
+	if (!release_addr)
+		return -ENOMEM;
 
 	/*
 	 * We write the release address as LE regardless of the native
@@ -79,15 +89,17 @@ static int smp_spin_table_cpu_prepare(unsigned int cpu)
 	 * boot-loader's endianess before jumping. This is mandated by
 	 * the boot protocol.
 	 */
-	release_addr[0] = (void *) cpu_to_le64(__pa(secondary_holding_pen));
-
-	__flush_dcache_area(release_addr, sizeof(release_addr[0]));
+	writeq_relaxed(__pa(secondary_holding_pen), release_addr);
+	__flush_dcache_area((__force void *)release_addr,
+			    sizeof(*release_addr));
 
 	/*
 	 * Send an event to wake up the secondary CPU.
 	 */
 	sev();
 
+	iounmap(release_addr);
+
 	return 0;
 }
 
-- 
1.8.3.2
