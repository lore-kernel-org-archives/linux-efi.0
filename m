From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 11/17] x86/mm, resource: Use PAGE_KERNEL protection for ioremap of memory pages
Date: Mon, 24 Jul 2017 14:07:51 -0500
Message-ID: <20170724190757.11278-12-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In order for memory pages to be properly mapped when SEV is active, we
need to use the PAGE_KERNEL protection attribute as the base protection.
This will insure that memory mapping of, e.g. ACPI tables, receives the
proper mapping attributes.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/ioremap.c  | 28 ++++++++++++++++++++++++++++
 include/linux/ioport.h |  3 +++
 kernel/resource.c      | 17 +++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c0be7cf..7b27332 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -69,6 +69,26 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
 	return 0;
 }
 
+static int __ioremap_res_desc_other(struct resource *res, void *arg)
+{
+	return (res->desc != IORES_DESC_NONE);
+}
+
+/*
+ * This function returns true if the target memory is marked as
+ * IORESOURCE_MEM and IORESOURCE_BUSY and described as other than
+ * IORES_DESC_NONE (e.g. IORES_DESC_ACPI_TABLES).
+ */
+static bool __ioremap_check_if_mem(resource_size_t addr, unsigned long size)
+{
+	u64 start, end;
+
+	start = (u64)addr;
+	end = start + size - 1;
+
+	return (walk_mem_res(start, end, NULL, __ioremap_res_desc_other) == 1);
+}
+
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. It transparently creates kernel huge I/O mapping when
@@ -146,7 +166,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		pcm = new_pcm;
 	}
 
+	/*
+	 * If the page being mapped is in memory and SEV is active then
+	 * make sure the memory encryption attribute is enabled in the
+	 * resulting mapping.
+	 */
 	prot = PAGE_KERNEL_IO;
+	if (sev_active() && __ioremap_check_if_mem(phys_addr, size))
+		prot = pgprot_encrypted(prot);
+
 	switch (pcm) {
 	case _PAGE_CACHE_MODE_UC:
 	default:
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 1c66b9c..297f5b8 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -268,6 +268,9 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 extern int
+walk_mem_res(u64 start, u64 end, void *arg,
+	     int (*func)(struct resource *, void *));
+extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 		    int (*func)(struct resource *, void *));
 extern int
diff --git a/kernel/resource.c b/kernel/resource.c
index 5f9ee7bb0..ec3fa0c 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -468,6 +468,23 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 				     arg, func);
 }
 
+/*
+ * This function calls the @func callback against all memory ranges, which
+ * are ranges marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ */
+int walk_mem_res(u64 start, u64 end, void *arg,
+		 int (*func)(struct resource *, void *))
+{
+	struct resource res;
+
+	res.start = start;
+	res.end = end;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
+	return __walk_iomem_res_desc(&res, IORES_DESC_NONE, true,
+				     arg, func);
+}
+
 #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 
 /*
-- 
2.9.4
