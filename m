From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v11 01/10] of/fdt: make generic early_init_dt_add_memory_arch() a weak alias
Date: Fri, 19 Feb 2016 17:13:10 -0800
Message-ID: <1455930799-5371-2-git-send-email-ddaney.cavm@gmail.com>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The function early_init_dt_add_memory_arch() is defined as __weak
so that archs can override it. However, in this override implementation,
it may still be useful to invoke the generic implementation, so instead,
rename the generic version to early_init_dt_add_memory() and turn the
original definition into a weak alias. This way, the generic version can
still be called even in the presence of an arch specific override.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Robert Richter <rrichter@cavium.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/of/fdt.c       | 7 +++++--
 include/linux/of_fdt.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 655f79d..cba8281 100644
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
index df9ef38..463a06b 100644
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
1.8.3.1
