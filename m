From: Robert Richter <rrichter@caviumnetworks.com>
Subject: [PATCH v4 1/6] of/fdt: make generic early_init_dt_add_memory_arch() a
 weak alias
Date: Tue, 9 Feb 2016 14:53:41 +0100
Message-ID: <1455026026-11571-2-git-send-email-rrichter@caviumnetworks.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Robert Richter <rrichter@cavium.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The function early_init_dt_add_memory_arch() is defined as __weak
so that archs can override it. However, in this override implementation,
it may still be useful to invoke the generic implementation, so instead,
rename the generic version to early_init_dt_add_memory() and turn the
original definition into a weak alias. This way, the generic version can
still be called even in the presence of an arch specific override.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Message-Id: <1442881288-13962-2-git-send-email-ard.biesheuvel@linaro.org>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 drivers/of/fdt.c       | 7 +++++--
 include/linux/of_fdt.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 655f79db7899..cba8281ab5fd 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -980,7 +980,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 #define MAX_MEMBLOCK_ADDR	((phys_addr_t)~0)
 #endif
 
-void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+void __init early_init_dt_add_memory(u64 base, u64 size)
 {
 	const u64 phys_offset = __pa(PAGE_OFFSET);
 
@@ -1038,7 +1038,7 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __va(memblock_alloc(size, align));
 }
 #else
-void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+void __init early_init_dt_add_memory(u64 base, u64 size)
 {
 	WARN_ON(1);
 }
@@ -1058,6 +1058,9 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 #endif
 
+__weak __alias(early_init_dt_add_memory)
+void early_init_dt_add_memory_arch(u64 base, u64 size);
+
 bool __init early_init_dt_verify(void *params)
 {
 	if (!params)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index df9ef3801812..463a06ba87ac 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -65,6 +65,7 @@ extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_fdt_reserve_self(void);
+extern void early_init_dt_add_memory(u64 base, u64 size);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t size,
 					     bool no_map);
-- 
2.7.0.rc3
