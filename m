From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v13 4/6] arm64: Move unflatten_device_tree() call earlier.
Date: Wed,  2 Mar 2016 14:56:00 -0800
Message-ID: <1456959362-2036-5-git-send-email-ddaney.cavm@gmail.com>
References: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney@cavium.com>

In order to extract NUMA information from the device tree, we need to
have the tree in its unflattened form.

Move the call to unflatten_device_tree() into paging_init().  This
puts it before the call to bootmem_init(), which is where the NUMA
information is extracted.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/arm64/kernel/setup.c | 7 +++----
 arch/arm64/mm/mmu.c       | 5 +++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 8119479..feae073 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -328,12 +328,11 @@ void __init setup_arch(char **cmdline_p)
 
 	early_ioremap_reset();
 
-	if (acpi_disabled) {
-		unflatten_device_tree();
+	if (acpi_disabled)
 		psci_dt_init();
-	} else {
+	else
 		psci_acpi_init();
-	}
+
 	xen_early_init();
 
 	cpu_read_bootcpu_ops();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 58faeaa..ee6e6b0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -29,6 +29,8 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/stop_machine.h>
+#include <linux/acpi.h>
+#include <linux/of_fdt.h>
 
 #include <asm/cputype.h>
 #include <asm/fixmap.h>
@@ -459,6 +461,9 @@ void __init paging_init(void)
 	map_mem();
 	fixup_executable();
 
+	if (acpi_disabled)
+		unflatten_device_tree();
+
 	/* allocate the zero page. */
 	zero_page = early_alloc(PAGE_SIZE);
 
-- 
1.8.3.1
