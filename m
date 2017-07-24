From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 10/17] resource: Provide resource struct in resource walk callback
Date: Mon, 24 Jul 2017 14:07:50 -0500
Message-ID: <20170724190757.11278-11-brijesh.singh@amd.com>
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

In prep for a new function that will need additional resource information
during the resource walk, update the resource walk callback to pass the
resource structure.  Since the current callback start and end arguments
are pulled from the resource structure, the callback functions can obtain
them from the resource structure directly.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/powerpc/kernel/machine_kexec_file_64.c | 12 +++++++++---
 arch/x86/kernel/crash.c                     | 18 +++++++++---------
 arch/x86/kernel/pmem.c                      |  2 +-
 include/linux/ioport.h                      |  4 ++--
 include/linux/kexec.h                       |  2 +-
 kernel/kexec_file.c                         |  5 +++--
 kernel/resource.c                           |  9 +++++----
 7 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kernel/machine_kexec_file_64.c b/arch/powerpc/kernel/machine_kexec_file_64.c
index 992c0d2..e4395f9 100644
--- a/arch/powerpc/kernel/machine_kexec_file_64.c
+++ b/arch/powerpc/kernel/machine_kexec_file_64.c
@@ -91,11 +91,13 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
  * and that value will be returned. If all free regions are visited without
  * func returning non-zero, then zero will be returned.
  */
-int arch_kexec_walk_mem(struct kexec_buf *kbuf, int (*func)(u64, u64, void *))
+int arch_kexec_walk_mem(struct kexec_buf *kbuf,
+			int (*func)(struct resource *, void *))
 {
 	int ret = 0;
 	u64 i;
 	phys_addr_t mstart, mend;
+	struct resource res = { };
 
 	if (kbuf->top_down) {
 		for_each_free_mem_range_reverse(i, NUMA_NO_NODE, 0,
@@ -105,7 +107,9 @@ int arch_kexec_walk_mem(struct kexec_buf *kbuf, int (*func)(u64, u64, void *))
 			 * range while in kexec, end points to the last byte
 			 * in the range.
 			 */
-			ret = func(mstart, mend - 1, kbuf);
+			res.start = mstart;
+			res.end = mend - 1;
+			ret = func(&res, kbuf);
 			if (ret)
 				break;
 		}
@@ -117,7 +121,9 @@ int arch_kexec_walk_mem(struct kexec_buf *kbuf, int (*func)(u64, u64, void *))
 			 * range while in kexec, end points to the last byte
 			 * in the range.
 			 */
-			ret = func(mstart, mend - 1, kbuf);
+			res.start = mstart;
+			res.end = mend - 1;
+			ret = func(&res, kbuf);
 			if (ret)
 				break;
 		}
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 44404e2..815008c 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -209,7 +209,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_KEXEC_FILE
-static int get_nr_ram_ranges_callback(u64 start, u64 end, void *arg)
+static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 {
 	unsigned int *nr_ranges = arg;
 
@@ -342,7 +342,7 @@ static int elf_header_exclude_ranges(struct crash_elf_data *ced,
 	return ret;
 }
 
-static int prepare_elf64_ram_headers_callback(u64 start, u64 end, void *arg)
+static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
 {
 	struct crash_elf_data *ced = arg;
 	Elf64_Ehdr *ehdr;
@@ -355,7 +355,7 @@ static int prepare_elf64_ram_headers_callback(u64 start, u64 end, void *arg)
 	ehdr = ced->ehdr;
 
 	/* Exclude unwanted mem ranges */
-	ret = elf_header_exclude_ranges(ced, start, end);
+	ret = elf_header_exclude_ranges(ced, res->start, res->end);
 	if (ret)
 		return ret;
 
@@ -518,14 +518,14 @@ static int add_e820_entry(struct boot_params *params, struct e820_entry *entry)
 	return 0;
 }
 
-static int memmap_entry_callback(u64 start, u64 end, void *arg)
+static int memmap_entry_callback(struct resource *res, void *arg)
 {
 	struct crash_memmap_data *cmd = arg;
 	struct boot_params *params = cmd->params;
 	struct e820_entry ei;
 
-	ei.addr = start;
-	ei.size = end - start + 1;
+	ei.addr = res->start;
+	ei.size = res->end - res->start + 1;
 	ei.type = cmd->type;
 	add_e820_entry(params, &ei);
 
@@ -619,12 +619,12 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 	return ret;
 }
 
-static int determine_backup_region(u64 start, u64 end, void *arg)
+static int determine_backup_region(struct resource *res, void *arg)
 {
 	struct kimage *image = arg;
 
-	image->arch.backup_src_start = start;
-	image->arch.backup_src_sz = end - start + 1;
+	image->arch.backup_src_start = res->start;
+	image->arch.backup_src_sz = res->end - res->start + 1;
 
 	/* Expecting only one range for backup region */
 	return 1;
diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
index 0c5315d..297bb71 100644
--- a/arch/x86/kernel/pmem.c
+++ b/arch/x86/kernel/pmem.c
@@ -6,7 +6,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 
-static int found(u64 start, u64 end, void *data)
+static int found(struct resource *res, void *data)
 {
 	return 1;
 }
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 6230064..1c66b9c 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -269,10 +269,10 @@ walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
-		    int (*func)(u64, u64, void *));
+		    int (*func)(struct resource *, void *));
 extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
-		    void *arg, int (*func)(u64, u64, void *));
+		    void *arg, int (*func)(struct resource *, void *));
 
 /* True if any part of r1 overlaps r2 */
 static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 2b7590f..d672f95 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -159,7 +159,7 @@ struct kexec_buf {
 };
 
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
-			       int (*func)(u64, u64, void *));
+			       int (*func)(struct resource *, void *));
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
 #endif /* CONFIG_KEXEC_FILE */
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 9f48f44..e5bcd94 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -406,9 +406,10 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 	return 1;
 }
 
-static int locate_mem_hole_callback(u64 start, u64 end, void *arg)
+static int locate_mem_hole_callback(struct resource *res, void *arg)
 {
 	struct kexec_buf *kbuf = (struct kexec_buf *)arg;
+	u64 start = res->start, end = res->end;
 	unsigned long sz = end - start + 1;
 
 	/* Returning 0 will take to next memory range */
@@ -437,7 +438,7 @@ static int locate_mem_hole_callback(u64 start, u64 end, void *arg)
  * func returning non-zero, then zero will be returned.
  */
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
-			       int (*func)(u64, u64, void *))
+			       int (*func)(struct resource *, void *))
 {
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return walk_iomem_res_desc(crashk_res.desc,
diff --git a/kernel/resource.c b/kernel/resource.c
index 7b20b3e..5f9ee7bb0 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -403,14 +403,15 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 
 static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
 				 bool first_level_children_only,
-				 void *arg, int (*func)(u64, u64, void *))
+				 void *arg,
+				 int (*func)(struct resource *, void *))
 {
 	u64 orig_end = res->end;
 	int ret = -1;
 
 	while ((res->start < res->end) &&
 	       !find_next_iomem_res(res, desc, first_level_children_only)) {
-		ret = (*func)(res->start, res->end, arg);
+		ret = (*func)(res, arg);
 		if (ret)
 			break;
 
@@ -436,7 +437,7 @@ static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
  * <linux/ioport.h> and set it in 'desc' of a target resource entry.
  */
 int walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start,
-		u64 end, void *arg, int (*func)(u64, u64, void *))
+		u64 end, void *arg, int (*func)(struct resource *, void *))
 {
 	struct resource res;
 
@@ -455,7 +456,7 @@ int walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start,
  * ranges.
  */
 int walk_system_ram_res(u64 start, u64 end, void *arg,
-				int (*func)(u64, u64, void *))
+				int (*func)(struct resource *, void *))
 {
 	struct resource res;
 
-- 
2.9.4
