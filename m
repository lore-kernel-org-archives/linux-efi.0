Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FF44503F5;
	Tue, 11 Aug 2026 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465640; cv=none; b=XpXPWtACO30OJAcBGXscml5fUAQDpVTLp0xzvRoLRHuxmGDtCWTNYCjmVoVQpkczh7VZj5zbyVWTiUkzlVVBmbBUE1V6wohVvISLivoJFNJ3iY74S1MQD56NU5MvJLQQAhGU7tUJoQanot4lV5MC+BLRmtQTJEETn39xaxKoh2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465640; c=relaxed/simple;
	bh=Hy0T0FglTlY/327sevPowE172XFXK3vXl+5W+R01taQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESvoa07zIEOv6J6yrePHQ/9Lzvn4n8cdAxod3hBIf3tG83zLXawdzclWrwhMv1d3DJFhCwtVnrPGRvMTJ+CGisiTKKrQkTReyrmaAKX4Ga8SKY6ATWTdAtiKHltEGWnJ0ux8TAqn1MM55xkK40/fJ6pl2vLMFrqPAGaHJAtDOLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJP8d9Ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJP8d9Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101A1F00A3A;
	Tue, 11 Aug 2026 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465632;
	bh=5rHWiKFwpkHZWnf3oJsyWXwHkCpb2VhI6ZUDyK6lHGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJP8d9RoV0TJc9jq1wKXFmzoJcrAifzGTK8ys0tvGrGQq9aV4jEEmr1HcZoDVL9kS
	 +k9DayXI5mK71lCJL4NyjT6QpgxZpG10FgOTwETOrT9Nc4FfVkwY1STTwNKX+bIPU6
	 68B1+jV01fKQBdIIQjcSNwMKOHVP9wxNBp+9MWBO2mT8QPS60cWLHfb4RqWHM7fLTP
	 2da0+rAwm3gKzCkMxGvezqa1357bdrve3OKzcKCjDO4YIChHGX3pAANI4PfQI53klK
	 q1x9Ba+TQkafbOxR4/nX+MwZcoW1wPYS3zpasIw4oB59rWNLGBdofN6bo+VzYS3x/g
	 z1aTFzpuL0tag==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <baoquan.he@linux.dev>
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH 3/4] kho: rename KHO scratch to KHO bootmem
Date: Tue, 11 Aug 2026 18:26:39 +0200
Message-ID: <20260811162642.3504565-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <20260811162642.3504565-1-pratyush@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The term "KHO scratch" is vague and overloaded.

For one, it does not accurately describe what the memory is for. From
KHO's perspective, it is memory passed by the previous kernel that is
guaranteed to have no allocations and hence it is safe to allocate from.

For another, the term is overloaded. KHO also knows to discover other
ranges of memory that don't have any preservations and are safe to
allocate from. This is done by kho_extend_scratch(). These areas, while
called "scratch", are completely different from the chunk of memory
passed by the previous kernel for early boot allocations.

Rename "KHO scratch" to "KHO boot memory", or "KHO bootmem" in short.
Update all function names, variable names, comments, and documentation
to use this.

Call the discovered areas "noprsrv", matching what memblock would see
them as. Rename kho_extend_scratch() to reflect this.

This patch largely has no functional changes. The only functional
changes are renames of debugfs files from "scratch_phys" and
"scratch_len" to "bootmem_phys" and "bootmem_len" respectively.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---

Note that while all the documentation and internal naming around the
kho_scratch= parameter have changed, the parameter name stays the same.
This is to avoid functional changes (outside debugfs) in this big
commit. The name will be changed in the next patch.
---
 .../admin-guide/kernel-parameters.txt         |  13 +-
 Documentation/admin-guide/mm/kho.rst          |  16 +-
 Documentation/core-api/kho/index.rst          |  36 +-
 arch/x86/boot/compressed/kaslr.c              |  12 +-
 arch/x86/include/uapi/asm/setup_data.h        |   4 +-
 arch/x86/kernel/kexec-bzimage64.c             |   6 +-
 arch/x86/kernel/setup.c                       |   2 +-
 drivers/firmware/efi/efi-init.c               |   4 +-
 drivers/of/kexec.c                            |  16 +-
 include/asm-generic/kexec_handover.h          |   2 +-
 include/linux/kexec.h                         |   2 +-
 include/linux/kexec_handover.h                |  16 +-
 kernel/liveupdate/kexec_handover.c            | 328 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  24 +-
 kernel/liveupdate/kexec_handover_internal.h   |   4 +-
 mm/memblock.c                                 |   8 +-
 mm/mm_init.c                                  |   6 +-
 tools/testing/memblock/internal.h             |   2 +-
 18 files changed, 252 insertions(+), 249 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..e2212f058812 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2991,9 +2991,10 @@ Kernel parameters
 
 	kho_scratch=	[KEXEC,EARLY]
 			Format: ll[KMG],mm[KMG],nn[KMG] | nn%
-			Defines the size of the KHO scratch region. The KHO
-			scratch regions are physically contiguous memory
-			ranges that can only be used for non-kernel
+
+			Defines the size of the KHO boot memory region. The
+			KHO boot memory regions are physically contiguous
+			memory ranges that can only be used for non-kernel
 			allocations. That way, even when memory is heavily
 			fragmented with handed over memory, the kexeced
 			kernel will always have enough contiguous ranges to
@@ -3002,10 +3003,10 @@ Kernel parameters
 			It is possible to specify the exact amount of
 			memory in the form of "ll[KMG],mm[KMG],nn[KMG]"
 			where the first parameter defines the size of a low
-			memory scratch area, the second parameter defines
-			the size of a global scratch area and the third
+			memory bootmem area, the second parameter defines
+			the size of a global bootmem area and the third
 			parameter defines the size of additional per-node
-			scratch areas.  The form "nn%" defines scale factor
+			bootmem areas.  The form "nn%" defines scale factor
 			(in percents) of memory that was used during boot.
 
 	kmac=		[MIPS] Korina ethernet MAC address.
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 2c26e560bd78..4fae09096038 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -21,9 +21,9 @@ kexec.
 
 To use KHO, please boot the kernel with the ``kho=on`` command line
 parameter. You may use ``kho_scratch`` parameter to define size of the
-scratch regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
-16 MiB low memory scratch area, a 512 MiB global scratch region, and 256 MiB
-per NUMA node scratch regions on boot.
+boot memory regions. For example ``kho_scratch=16M,512M,256M`` will reserve a
+16 MiB low memory bootmem area, a 512 MiB global bootmem region, and 256 MiB
+per NUMA node bootmem regions on boot.
 
 Perform a KHO kexec
 ===================
@@ -96,15 +96,15 @@ stabilized.
     current KHO state in this file. Kexec user space tooling can use this
     as input file for the KHO payload image.
 
-``/sys/kernel/debug/kho/out/scratch_len``
-    Lengths of KHO scratch regions, which are physically contiguous
+``/sys/kernel/debug/kho/out/bootmem_len``
+    Lengths of KHO bootmem regions, which are physically contiguous
     memory regions that will always stay available for future kexec
     allocations. Kexec user space tools can use this file to determine
     where it should place its payload images.
 
-``/sys/kernel/debug/kho/out/scratch_phys``
-    Physical locations of KHO scratch regions. Kexec user space tools
-    can use this file in conjunction to scratch_phys to determine where
+``/sys/kernel/debug/kho/out/bootmem_phys``
+    Physical locations of KHO bootmem regions. Kexec user space tools
+    can use this file in conjunction to bootmem_phys to determine where
     it should place its payload images.
 
 ``/sys/kernel/debug/kho/out/sub_fdts/``
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index 320914a42178..e78a2bbe2be1 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -13,8 +13,8 @@ Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
 regions, which could contain serialized system states, across kexec.
 
 KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
-the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
-memory regions <kho_scratch>` to ensure integrity of the preserved memory.
+the preserved state from pre-exec kernel to post-kexec kernel and :ref:`boot
+memory regions <kho_bootmem>` to ensure integrity of the preserved memory.
 
 .. _kho_fdt:
 
@@ -40,31 +40,31 @@ and post-kexec kernels. This ABI is defined by header files in
 
    abi.rst
 
-.. _kho_scratch:
+.. _kho_bootmem:
 
-Scratch Regions
-===============
+Boot Memory Regions
+===================
 
 To boot into kexec, we need to have a physically contiguous memory range that
 contains no handed over memory. Kexec then places the target kernel and initrd
 into that region. The new kernel exclusively uses this region for memory
 allocations before during boot up to the initialization of the page allocator.
 
-We guarantee that we always have such regions through the scratch regions: On
-first boot KHO allocates several physically contiguous memory regions. Since
+We guarantee that we always have such regions through the boot memory regions:
+On first boot KHO allocates several physically contiguous memory regions. Since
 after kexec these regions will be used by early memory allocations, there is a
-scratch region per NUMA node plus a scratch region to satisfy allocations
-requests that do not require particular NUMA node assignment.
-By default, size of the scratch region is calculated based on amount of memory
-allocated during boot. The ``kho_scratch`` kernel command line option may be
-used to explicitly define size of the scratch regions.
-The scratch regions are declared as CMA when page allocator is initialized so
-that their memory can be used during system lifetime. CMA gives us the
-guarantee that no handover pages land in that region, because handover pages
-must be at a static physical memory location and CMA enforces that only
-movable pages can be located inside.
+boot memory region per NUMA node plus a boot memory region to satisfy
+allocations requests that do not require particular NUMA node assignment. By
+default, size of the boot memory region is calculated based on amount of memory
+allocated during boot. The ``kho_bootmem`` kernel command line option may be
+used to explicitly define size of the boot memory regions. The boot memory
+regions are declared as CMA when page allocator is initialized so that their
+memory can be used during system lifetime. CMA gives us the guarantee that no
+handover pages land in that region, because handover pages must be at a static
+physical memory location and CMA enforces that only movable pages can be located
+inside.
 
-After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
+After KHO kexec, we ignore the ``kho_bootmem`` kernel command line option and
 instead reuse the exact same region that was originally allocated. This allows
 us to recursively execute any amount of KHO kexecs. Because we used this region
 for boot memory allocations and as target memory for kexec blobs, some parts
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 22267a83e064..290153818d0f 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -764,12 +764,12 @@ static void process_e820_entries(unsigned long minimum,
 }
 
 /*
- * If KHO is active, only process its scratch areas to ensure we are not
+ * If KHO is active, only process its bootmem areas to ensure we are not
  * stepping onto preserved memory.
  */
 static bool process_kho_entries(unsigned long minimum, unsigned long image_size)
 {
-	struct kho_scratch *kho_scratch;
+	struct kho_bootmem *kho_bootmem;
 	struct setup_data *ptr;
 	struct kho_data *kho;
 	int i, nr_areas = 0;
@@ -781,8 +781,8 @@ static bool process_kho_entries(unsigned long minimum, unsigned long image_size)
 	while (ptr) {
 		if (ptr->type == SETUP_KEXEC_KHO) {
 			kho = (struct kho_data *)(unsigned long)ptr->data;
-			kho_scratch = (void *)(unsigned long)kho->scratch_addr;
-			nr_areas = kho->scratch_size / sizeof(*kho_scratch);
+			kho_bootmem = (void *)(unsigned long)kho->bootmem_addr;
+			nr_areas = kho->bootmem_size / sizeof(*kho_bootmem);
 			break;
 		}
 
@@ -793,7 +793,7 @@ static bool process_kho_entries(unsigned long minimum, unsigned long image_size)
 		return false;
 
 	for (i = 0; i < nr_areas; i++) {
-		struct kho_scratch *area = &kho_scratch[i];
+		struct kho_bootmem *area = &kho_bootmem[i];
 		struct mem_vector region = {
 			.start = area->addr,
 			.size = area->size,
@@ -822,7 +822,7 @@ static unsigned long find_random_phys_addr(unsigned long minimum,
 	}
 
 	/*
-	 * During kexec handover only process KHO scratch areas that are known
+	 * During kexec handover only process KHO bootmem areas that are known
 	 * not to contain any data that must be preserved.
 	 */
 	if (!process_kho_entries(minimum, image_size) &&
diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
index 2671c4e1b3a0..61090db5065c 100644
--- a/arch/x86/include/uapi/asm/setup_data.h
+++ b/arch/x86/include/uapi/asm/setup_data.h
@@ -85,8 +85,8 @@ struct ima_setup_data {
 struct kho_data {
 	__u64 fdt_addr;
 	__u64 fdt_size;
-	__u64 scratch_addr;
-	__u64 scratch_size;
+	__u64 bootmem_addr;
+	__u64 bootmem_size;
 } __attribute__((packed));
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 7e980ea49d8d..3aa77006adab 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -285,14 +285,14 @@ static void setup_kho(const struct kimage *image, struct boot_params *params,
 	sd->len = sizeof(struct kho_data);
 
 	/* Only add if we have all KHO images in place */
-	if (!image->kho.fdt || !image->kho.scratch)
+	if (!image->kho.fdt || !image->kho.bootmem)
 		return;
 
 	/* Add setup data */
 	kho->fdt_addr = image->kho.fdt;
 	kho->fdt_size = PAGE_SIZE;
-	kho->scratch_addr = image->kho.scratch->mem;
-	kho->scratch_size = image->kho.scratch->bufsz;
+	kho->bootmem_addr = image->kho.bootmem->mem;
+	kho->bootmem_size = image->kho.bootmem->bufsz;
 	sd->next = params->hdr.setup_data;
 	params->hdr.setup_data = params_load_addr + setup_data_offset;
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5ebb521e136d..d1618c4cf7fb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -472,7 +472,7 @@ static void __init add_kho(u64 phys_addr, u32 data_len)
 		return;
 	}
 
-	kho_populate(kho->fdt_addr, kho->fdt_size, kho->scratch_addr, kho->scratch_size);
+	kho_populate(kho->fdt_addr, kho->fdt_size, kho->bootmem_addr, kho->bootmem_size);
 
 	early_memunmap(kho, size);
 }
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index a2edaf3766eb..9f09b0d2daa0 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -165,10 +165,10 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	/*
-	 * Discard memblocks discovered so far except for KHO scratch
+	 * Discard memblocks discovered so far except for KHO bootmem
 	 * regions. Most memblocks at this point originate from memory nodes
 	 * in the DT and UEFI uses its own memory map instead. However, if
-	 * KHO is enabled, scratch regions, which are good known memory
+	 * KHO is enabled, bootmem regions, which are good known memory
 	 * must be preserved.
 	 */
 	memblock_dump_all();
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index b6837e299e7f..1970d0bdb671 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -261,23 +261,23 @@ static int kho_add_chosen(const struct kimage *image, void *fdt, int chosen_node
 #ifdef CONFIG_KEXEC_HANDOVER
 	phys_addr_t fdt_mem = 0;
 	phys_addr_t fdt_len = 0;
-	phys_addr_t scratch_mem = 0;
-	phys_addr_t scratch_len = 0;
+	phys_addr_t bootmem_arr = 0;
+	phys_addr_t bootmem_len = 0;
 
 	ret = fdt_delprop(fdt, chosen_node, "linux,kho-fdt");
 	if (ret && ret != -FDT_ERR_NOTFOUND)
 		return ret;
-	ret = fdt_delprop(fdt, chosen_node, "linux,kho-scratch");
+	ret = fdt_delprop(fdt, chosen_node, "linux,kho-bootmem");
 	if (ret && ret != -FDT_ERR_NOTFOUND)
 		return ret;
 
-	if (!image->kho.fdt || !image->kho.scratch)
+	if (!image->kho.fdt || !image->kho.bootmem)
 		return 0;
 
 	fdt_mem = image->kho.fdt;
 	fdt_len = PAGE_SIZE;
-	scratch_mem = image->kho.scratch->mem;
-	scratch_len = image->kho.scratch->bufsz;
+	bootmem_arr = image->kho.bootmem->mem;
+	bootmem_len = image->kho.bootmem->bufsz;
 
 	pr_debug("Adding kho metadata to DT");
 
@@ -285,8 +285,8 @@ static int kho_add_chosen(const struct kimage *image, void *fdt, int chosen_node
 				       fdt_mem, fdt_len);
 	if (ret)
 		return ret;
-	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-scratch",
-				       scratch_mem, scratch_len);
+	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-bootmem",
+				       bootmem_arr, bootmem_len);
 
 #endif /* CONFIG_KEXEC_HANDOVER */
 	return ret;
diff --git a/include/asm-generic/kexec_handover.h b/include/asm-generic/kexec_handover.h
index 50839fb5ee8e..cf73d9b34c3c 100644
--- a/include/asm-generic/kexec_handover.h
+++ b/include/asm-generic/kexec_handover.h
@@ -4,7 +4,7 @@
 
 #include <linux/types.h>
 
-struct kho_scratch {
+struct kho_bootmem {
 	phys_addr_t addr;
 	phys_addr_t size;
 };
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 8a22bc9b8c6c..20a874e19dfa 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -418,7 +418,7 @@ struct kimage {
 #endif
 
 	struct {
-		struct kexec_segment *scratch;
+		struct kexec_segment *bootmem;
 		phys_addr_t fdt;
 	} kho;
 
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 46de86dc343e..ef2b188c8ed0 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -36,15 +36,15 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 void kho_memory_init(void);
 void kho_memory_init_early(void);
 
-void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
-		  u64 scratch_len);
+void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t bootmem_phys,
+		  u64 bootmem_len);
 
-bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+bool kho_bootmem_overlap(phys_addr_t phys, size_t size);
 
-static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+static inline enum migratetype kho_bootmem_migratetype(unsigned long pfn,
 						       enum migratetype mt)
 {
-	if (kho_scratch_overlap(PFN_PHYS(pfn), pageblock_nr_pages << PAGE_SHIFT))
+	if (kho_bootmem_overlap(PFN_PHYS(pfn), pageblock_nr_pages << PAGE_SHIFT))
 		return MIGRATE_CMA;
 	return mt;
 }
@@ -123,16 +123,16 @@ static inline void kho_memory_init(void) { }
 static inline void kho_memory_init_early(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-				phys_addr_t scratch_phys, u64 scratch_len)
+				phys_addr_t bootmem_phys, u64 bootmem_len)
 {
 }
 
-static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 {
 	return false;
 }
 
-static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+static inline enum migratetype kho_bootmem_migratetype(unsigned long pfn,
 						       enum migratetype mt)
 {
 	return mt;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 13db1534c746..3bfdbe86aaf9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -41,12 +41,12 @@
 /*
  * This is the minimal alignment required by deferred struct page init.
  * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
- * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
- * If KHO scratch is not aligned to that value, buddy can access uninitialized
- * struct pages, which can cause a crash.
+ * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them. If KHO bootmem
+ * is not aligned to that value, buddy can access uninitialized struct pages,
+ * which can cause a crash.
  */
-#define SCRATCH_ALIGNMENT_BYTES (PAGE_SIZE * MAX_ORDER_NR_PAGES)
-static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
+#define BOOTMEM_ALIGNMENT_BYTES (PAGE_SIZE * MAX_ORDER_NR_PAGES)
+static_assert(BOOTMEM_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
 
 /* The magic token for preserved pages */
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
@@ -96,7 +96,7 @@ static struct kho_out kho_out = {
 
 struct kho_in {
 	phys_addr_t fdt_phys;
-	phys_addr_t scratch_phys;
+	phys_addr_t bootmem_phys;
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
@@ -656,34 +656,34 @@ static void __init *kho_get_mem_map(const void *fdt)
 
 /*
  * With KHO enabled, memory can become fragmented because KHO regions may
- * be anywhere in physical address space. The scratch regions give us a
+ * be anywhere in physical address space. The bootmem regions give us a
  * safe zones that we will never see KHO allocations from. This is where we
- * can later safely load our new kexec images into and then use the scratch
+ * can later safely load our new kexec images into and then use the bootmem
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-struct kho_scratch *kho_scratch;
-unsigned int kho_scratch_cnt;
+struct kho_bootmem *kho_bootmem;
+unsigned int kho_bootmem_cnt;
 
 /*
- * The scratch areas are scaled by default as percent of memory allocated from
+ * The bootmem areas are scaled by default as percent of memory allocated from
  * memblock. A user can override the scale with command line parameter:
  *
  * kho_scratch=N%
  *
  * It is also possible to explicitly define size for a lowmem, a global and
- * per-node scratch areas:
+ * per-node bootmem areas:
  *
  * kho_scratch=l[KMG],n[KMG],m[KMG]
  *
  * The explicit size definition takes precedence over scale definition.
  */
-static unsigned int scratch_scale __initdata = 200;
-static phys_addr_t scratch_size_global __initdata;
-static phys_addr_t scratch_size_pernode __initdata;
-static phys_addr_t scratch_size_lowmem __initdata;
+static unsigned int bootmem_scale __initdata = 200;
+static phys_addr_t bootmem_size_global __initdata;
+static phys_addr_t bootmem_size_pernode __initdata;
+static phys_addr_t bootmem_size_lowmem __initdata;
 
-static int __init kho_parse_scratch_size(char *p)
+static int __init kho_parse_bootmem_size(char *p)
 {
 	size_t len;
 	unsigned long sizes[3];
@@ -707,9 +707,9 @@ static int __init kho_parse_scratch_size(char *p)
 			return -EINVAL;
 
 		memcpy(s_scale, p, len - 1);
-		ret = kstrtouint(s_scale, 10, &scratch_scale);
+		ret = kstrtouint(s_scale, 10, &bootmem_scale);
 		if (!ret)
-			pr_notice("scratch scale is %d%%\n", scratch_scale);
+			pr_notice("bootmem scale is %d%%\n", bootmem_scale);
 		return ret;
 	}
 
@@ -737,81 +737,81 @@ static int __init kho_parse_scratch_size(char *p)
 	if (*p)
 		return -EINVAL;
 
-	scratch_size_lowmem = sizes[0];
-	scratch_size_global = sizes[1];
-	scratch_size_pernode = sizes[2];
-	scratch_scale = 0;
+	bootmem_size_lowmem = sizes[0];
+	bootmem_size_global = sizes[1];
+	bootmem_size_pernode = sizes[2];
+	bootmem_scale = 0;
 
-	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB pernode: %lldMiB\n",
-		  (u64)(scratch_size_lowmem >> 20),
-		  (u64)(scratch_size_global >> 20),
-		  (u64)(scratch_size_pernode >> 20));
+	pr_notice("bootmem areas: lowmem: %lluMiB global: %lluMiB pernode: %lldMiB\n",
+		  (u64)(bootmem_size_lowmem >> 20),
+		  (u64)(bootmem_size_global >> 20),
+		  (u64)(bootmem_size_pernode >> 20));
 
 	return 0;
 }
-early_param("kho_scratch", kho_parse_scratch_size);
+early_param("kho_scratch", kho_parse_bootmem_size);
 
-static void __init scratch_size_update(void)
+static void __init bootmem_size_update(void)
 {
 	/*
 	 * If fixed sizes are not provided via command line, calculate them now.
 	 * Remove HugeTLB allocations from it because they never get allocated
-	 * from scratch.
+	 * from bootmem.
 	 */
-	if (scratch_scale) {
+	if (bootmem_scale) {
 		phys_addr_t size;
 
 		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
 						   NUMA_NO_NODE);
 		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
 						       NUMA_NO_NODE);
-		size = size * scratch_scale / 100;
-		scratch_size_lowmem = size;
+		size = size * bootmem_scale / 100;
+		bootmem_size_lowmem = size;
 
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   NUMA_NO_NODE);
 		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
 						       NUMA_NO_NODE);
-		size = size * scratch_scale / 100 - scratch_size_lowmem;
-		scratch_size_global = size;
+		size = size * bootmem_scale / 100 - bootmem_size_lowmem;
+		bootmem_size_global = size;
 	}
 
 	/*
-	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
+	 * bootmem areas are released as MIGRATE_CMA. Round them up to the right
 	 * size.
 	 */
-	scratch_size_lowmem = round_up(scratch_size_lowmem, SCRATCH_ALIGNMENT_BYTES);
-	scratch_size_global = round_up(scratch_size_global, SCRATCH_ALIGNMENT_BYTES);
+	bootmem_size_lowmem = round_up(bootmem_size_lowmem, BOOTMEM_ALIGNMENT_BYTES);
+	bootmem_size_global = round_up(bootmem_size_global, BOOTMEM_ALIGNMENT_BYTES);
 }
 
-static phys_addr_t __init scratch_size_node(int nid)
+static phys_addr_t __init bootmem_size_node(int nid)
 {
 	phys_addr_t size;
 
-	if (scratch_scale) {
+	if (bootmem_scale) {
 		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
 						   nid);
 		/* Do not count HugeTLB pages. */
 		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
 						       nid);
-		size = size * scratch_scale / 100;
+		size = size * bootmem_scale / 100;
 	} else {
-		size = scratch_size_pernode;
+		size = bootmem_size_pernode;
 	}
 
-	return round_up(size, SCRATCH_ALIGNMENT_BYTES);
+	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
 }
 
-bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 {
-	phys_addr_t scratch_start, scratch_end;
+	phys_addr_t bootmem_start, bootmem_end;
 	unsigned int i;
 
-	for (i = 0; i < kho_scratch_cnt; i++) {
-		scratch_start = kho_scratch[i].addr;
-		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+	for (i = 0; i < kho_bootmem_cnt; i++) {
+		bootmem_start = kho_bootmem[i].addr;
+		bootmem_end = kho_bootmem[i].addr + kho_bootmem[i].size;
 
-		if (phys < scratch_end && (phys + size) > scratch_start)
+		if (phys < bootmem_end && (phys + size) > bootmem_start)
 			return true;
 	}
 
@@ -819,7 +819,7 @@ bool kho_scratch_overlap(phys_addr_t phys, size_t size)
 }
 
 /**
- * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
+ * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
  *
  * With KHO we can preserve arbitrary pages in the system. To ensure we still
  * have a large contiguous region of memory when we search the physical address
@@ -827,7 +827,7 @@ bool kho_scratch_overlap(phys_addr_t phys, size_t size)
  * active. This CMA region will only be used for movable pages which are not a
  * problem for us during KHO because we can just move them somewhere else.
  */
-static void __init kho_reserve_scratch(void)
+static void __init kho_reserve_bootmem(void)
 {
 	phys_addr_t addr, size;
 	int nid, i = 0;
@@ -835,73 +835,73 @@ static void __init kho_reserve_scratch(void)
 	if (!kho_enable)
 		return;
 
-	scratch_size_update();
+	bootmem_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_scratch_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
-	size = kho_scratch_cnt * sizeof(*kho_scratch);
-	kho_scratch = memblock_alloc(size, PAGE_SIZE);
-	if (!kho_scratch) {
-		pr_err("Failed to reserve scratch array\n");
+	kho_bootmem_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
+	size = kho_bootmem_cnt * sizeof(*kho_bootmem);
+	kho_bootmem = memblock_alloc(size, PAGE_SIZE);
+	if (!kho_bootmem) {
+		pr_err("Failed to reserve bootmem array\n");
 		goto err_disable_kho;
 	}
 
 	/*
-	 * reserve scratch area in low memory for lowmem allocations in the
+	 * reserve bootmem area in low memory for lowmem allocations in the
 	 * next kernel
 	 */
-	size = scratch_size_lowmem;
-	addr = memblock_phys_alloc_range(size, SCRATCH_ALIGNMENT_BYTES, 0,
+	size = bootmem_size_lowmem;
+	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
 					 ARCH_LOW_ADDRESS_LIMIT);
 	if (!addr) {
-		pr_err("Failed to reserve lowmem scratch buffer\n");
-		goto err_free_scratch_desc;
+		pr_err("Failed to reserve lowmem bootmem\n");
+		goto err_free_bootmem_desc;
 	}
 
-	kho_scratch[i].addr = addr;
-	kho_scratch[i].size = size;
+	kho_bootmem[i].addr = addr;
+	kho_bootmem[i].size = size;
 	i++;
 
 	/* reserve large contiguous area for allocations without nid */
-	size = scratch_size_global;
-	addr = memblock_phys_alloc(size, SCRATCH_ALIGNMENT_BYTES);
+	size = bootmem_size_global;
+	addr = memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
 	if (!addr) {
-		pr_err("Failed to reserve global scratch buffer\n");
-		goto err_free_scratch_areas;
+		pr_err("Failed to reserve global bootmem\n");
+		goto err_free_bootmem_areas;
 	}
 
-	kho_scratch[i].addr = addr;
-	kho_scratch[i].size = size;
+	kho_bootmem[i].addr = addr;
+	kho_bootmem[i].size = size;
 	i++;
 
 	/*
 	 * Loop over nodes that have both memory and are online. Skip
-	 * memoryless nodes, as we can not allocate scratch areas there.
+	 * memoryless nodes, as we can not allocate bootmem areas there.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
-		size = scratch_size_node(nid);
-		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
+		size = bootmem_size_node(nid);
+		addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
 		if (!addr) {
-			pr_err("Failed to reserve nid %d scratch buffer\n", nid);
-			goto err_free_scratch_areas;
+			pr_err("Failed to reserve nid %d bootmem\n", nid);
+			goto err_free_bootmem_areas;
 		}
 
-		kho_scratch[i].addr = addr;
-		kho_scratch[i].size = size;
+		kho_bootmem[i].addr = addr;
+		kho_bootmem[i].size = size;
 		i++;
 	}
 
 	return;
 
-err_free_scratch_areas:
+err_free_bootmem_areas:
 	for (i--; i >= 0; i--)
-		memblock_phys_free(kho_scratch[i].addr, kho_scratch[i].size);
-err_free_scratch_desc:
-	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
+		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
+err_free_bootmem_desc:
+	memblock_free(kho_bootmem, kho_bootmem_cnt * sizeof(*kho_bootmem));
 err_disable_kho:
-	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
+	pr_warn("Failed to reserve bootmem, disabling kexec handover\n");
 	kho_enable = false;
 }
 
@@ -911,11 +911,11 @@ static void __init kho_reserve_scratch(void)
  * on smaller systems. The algorithm itself doesn't depend on the actual value,
  * so it can be changed to a different heuristic later if needed.
  */
-#define KHO_SCRATCH_EXT_BLKSIZE		SZ_1G
-#define KHO_SCRATCH_EXT_BLKSHIFT	const_ilog2(KHO_SCRATCH_EXT_BLKSIZE)
+#define KHO_DISCOVER_BLKSIZE		SZ_1G
+#define KHO_DISCOVER_BLKSHIFT	const_ilog2(KHO_DISCOVER_BLKSIZE)
 
 /* Called for the KHO preserved memory radix tree. */
-static int __init kho_ext_walk_leaf(unsigned long key, void *data)
+static int __init kho_discover_walk_leaf(unsigned long key, void *data)
 {
 	struct kho_radix_tree *busy_blocks = data;
 	phys_addr_t start, end;
@@ -930,29 +930,29 @@ static int __init kho_ext_walk_leaf(unsigned long key, void *data)
 	end = start + (1UL << (order + PAGE_SHIFT));
 
 	while (start < end) {
-		err = kho_radix_add_key(busy_blocks, start >> KHO_SCRATCH_EXT_BLKSHIFT);
+		err = kho_radix_add_key(busy_blocks, start >> KHO_DISCOVER_BLKSHIFT);
 		if (err)
 			return err;
 
-		start += (1UL << KHO_SCRATCH_EXT_BLKSHIFT);
+		start += (1UL << KHO_DISCOVER_BLKSHIFT);
 	}
 
 	return 0;
 }
 
 /* Called for the KHO preserved memory radix tree. */
-static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
+static int __init kho_discover_walk_node(phys_addr_t phys, void *data)
 {
 	struct kho_radix_tree *busy_blocks = data;
 
-	return kho_radix_add_key(busy_blocks, phys >> KHO_SCRATCH_EXT_BLKSHIFT);
+	return kho_radix_add_key(busy_blocks, phys >> KHO_DISCOVER_BLKSHIFT);
 }
 
 /* Called for the busy block radix tree. */
-static int __init kho_ext_mark_scratch(unsigned long key, void *data)
+static int __init kho_discover_mark_noprsrv(unsigned long key, void *data)
 {
 	phys_addr_t *prev_end = data;
-	phys_addr_t start = key << KHO_SCRATCH_EXT_BLKSHIFT;
+	phys_addr_t start = key << KHO_DISCOVER_BLKSHIFT;
 	int err;
 
 	if (start > *prev_end) {
@@ -961,23 +961,26 @@ static int __init kho_ext_mark_scratch(unsigned long key, void *data)
 			return err;
 	}
 
-	*prev_end = start + (1UL << KHO_SCRATCH_EXT_BLKSHIFT);
+	*prev_end = start + (1UL << KHO_DISCOVER_BLKSHIFT);
 	return 0;
 }
 
 /*
- * kho_extend_scratch - Extend the scratch regions
+ * kho_discover_noprsrv - Discover memory with no preservations
+ *
+ * Discovers memory ranges with no preserved memory and marks it as NOPRSRV.
+ * This lets memblock allocate memory from areas outside KHO bootmem.
  *
  * The KHO preserved memory radix tree mixes both physical address and order
  * into a single key. This makes it hard to look for free ranges directly. This
  * function first walks the radix tree and digests it down into another radix
- * tree, whose keys identify blocks of size KHO_SCRATCH_EXT_BLKSIZE which
- * contain preserved memory.
+ * tree, whose keys identify blocks of size KHO_DISCOVER_BLKSIZE which contain
+ * preserved memory.
  *
  * Then it walks the digested radix tree and marks everything that doesn't have
- * preserved memory as scratch.
+ * preserved memory as NOPRSRV.
  *
- * NOTE: This function allocates memory so it should be called when scratch has
+ * NOTE: This function allocates memory so it should be called when bootmem has
  * available space.
  *
  * NOTE: The pages of the KHO preserved memory radix tree tables are not marked
@@ -986,18 +989,18 @@ static int __init kho_ext_mark_scratch(unsigned long key, void *data)
  * them to be "preserved memory" and marks their blocks as busy.
  *
  * NOTE: efi_init()::reserve_regions() removes all regions except
- * MEMBLOCK_KHO_SCRATCH. This function adds such regions but they are not KHO
- * scratch memory, so they should not be removed. This function should always be
+ * MEMBLOCK_KHO_NOPRSRV. This function adds such regions but they are not KHO
+ * boot memory, so they should not be removed. This function should always be
  * called after reserve_regions().
  */
-static void __init kho_extend_scratch(void)
+static void __init kho_discover_noprsrv(void)
 {
 	const struct kho_radix_walk_cb kho_cb = {
-		.leaf = kho_ext_walk_leaf,
-		.node = kho_ext_walk_node,
+		.leaf = kho_discover_walk_leaf,
+		.node = kho_discover_walk_node,
 	};
 	const struct kho_radix_walk_cb ext_cb = {
-		.leaf = kho_ext_mark_scratch,
+		.leaf = kho_discover_mark_noprsrv,
 	};
 	static struct lock_class_key busy_radix_class;
 	struct kho_radix_tree busy_blocks;
@@ -1022,7 +1025,7 @@ static void __init kho_extend_scratch(void)
 	if (err)
 		goto out;
 
-	/* Walk the busy blocks and mark everything between keys as scratch. */
+	/* Walk the busy blocks and mark everything between keys as noprsrv. */
 	err = kho_radix_walk_tree(&busy_blocks, &ext_cb, &prev_end);
 	if (err)
 		goto out;
@@ -1036,7 +1039,7 @@ static void __init kho_extend_scratch(void)
 	kho_radix_destroy_tree(&busy_blocks);
 print:
 	if (err)
-		pr_err("Failed to extend scratch: %pe\n", ERR_PTR(err));
+		pr_err("Failed to discover extra allocatable memory: %pe\n", ERR_PTR(err));
 }
 
 /**
@@ -1150,7 +1153,7 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 
 	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
-	    WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+	    WARN_ON(kho_bootmem_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
 
 	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
@@ -1228,7 +1231,7 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	int err = 0;
 
 	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
-	    WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+	    WARN_ON(kho_bootmem_overlap(start_pfn << PAGE_SHIFT,
 					nr_pages << PAGE_SHIFT))) {
 		return -EINVAL;
 	}
@@ -1825,7 +1828,7 @@ static __init int kho_init(void)
 
 	err = kho_radix_init_tree(tree, NULL);
 	if (err)
-		goto err_free_scratch;
+		goto err_free_bootmem;
 
 	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
 	if (IS_ERR(kho_out.fdt)) {
@@ -1854,9 +1857,9 @@ static __init int kho_init(void)
 		return 0;
 	}
 
-	for (int i = 0; i < kho_scratch_cnt; i++) {
-		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
-		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
+	for (int i = 0; i < kho_bootmem_cnt; i++) {
+		unsigned long base_pfn = PHYS_PFN(kho_bootmem[i].addr);
+		unsigned long count = kho_bootmem[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
 		/*
@@ -1864,10 +1867,10 @@ static __init int kho_init(void)
 		 * corresponding PRESENT bit in the kernel page table.
 		 * Subsequent kmemleak scans of these pages cause the
 		 * non-PRESENT page faults.
-		 * Mark scratch areas with kmemleak_ignore_phys() to exclude
+		 * Mark bootmem areas with kmemleak_ignore_phys() to exclude
 		 * them from kmemleak scanning.
 		 */
-		kmemleak_ignore_phys(kho_scratch[i].addr);
+		kmemleak_ignore_phys(kho_bootmem[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
@@ -1883,11 +1886,11 @@ static __init int kho_init(void)
 	kho_unpreserve_free(kho_out.fdt);
 err_free_kho_radix_tree:
 	kho_radix_destroy_tree(tree);
-err_free_scratch:
+err_free_bootmem:
 	kho_out.fdt = NULL;
-	for (int i = 0; i < kho_scratch_cnt; i++) {
-		void *start = __va(kho_scratch[i].addr);
-		void *end = start + kho_scratch[i].size;
+	for (int i = 0; i < kho_bootmem_cnt; i++) {
+		void *start = __va(kho_bootmem[i].addr);
+		void *end = start + kho_bootmem[i].size;
 
 		free_reserved_area(start, end, -1, "");
 	}
@@ -1906,7 +1909,7 @@ void __init kho_memory_init_early(void)
 
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
-	 * catches that and never sets kho_in.scratch_phys, which stops memory
+	 * catches that and never sets kho_in.bootmem_phys, which stops memory
 	 * retrieval.
 	 */
 	mem_map = kho_get_mem_map(fdt);
@@ -1914,41 +1917,40 @@ void __init kho_memory_init_early(void)
 		goto err;
 
 	/*
-	 * kho_scratch_overlap() needs kho_scratch to be initialized. It
-	 * is used by free_area_init() on KHO boots, so initialize it
-	 * early.
+	 * kho_bootmem_overlap() needs kho_bootmem to be initialized. It is used
+	 * by free_area_init() on KHO boots, so initialize it early.
 	 */
-	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+	kho_bootmem = phys_to_virt(kho_in.bootmem_phys);
 
 	if (kho_radix_init_tree(&kho_in.radix_tree, mem_map))
 		goto err;
 
-	kho_extend_scratch();
+	kho_discover_noprsrv();
 
 	return;
 
 err:
 	/*
 	 * Failed to initialize preserved memory radix tree. Clear FDT
-	 * and scratch so KHO users don't treat it as a KHO boot.
+	 * and bootmem so KHO users don't treat it as a KHO boot.
 	 */
 	kho_in.fdt_phys = 0;
-	kho_in.scratch_phys = 0;
+	kho_in.bootmem_phys = 0;
 }
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys)
+	if (kho_in.bootmem_phys)
 		kho_mem_retrieve();
 	else
-		kho_reserve_scratch();
+		kho_reserve_bootmem();
 }
 
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-			 phys_addr_t scratch_phys, u64 scratch_len)
+			 phys_addr_t bootmem_phys, u64 bootmem_len)
 {
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
-	struct kho_scratch *scratch = NULL;
+	unsigned int bootmem_cnt = bootmem_len / sizeof(*kho_bootmem);
+	struct kho_bootmem *bootmem = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
 	bool populated = false;
@@ -1977,36 +1979,36 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	if (!mem_map_phys)
 		goto unmap_fdt;
 
-	scratch = early_memremap(scratch_phys, scratch_len);
-	if (!scratch) {
-		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
-			scratch_phys, scratch_len);
+	bootmem = early_memremap(bootmem_phys, bootmem_len);
+	if (!bootmem) {
+		pr_warn("setup: failed to memremap bootmem (phys=0x%llx, len=%lld)\n",
+			bootmem_phys, bootmem_len);
 		goto unmap_fdt;
 	}
 
 	/*
-	 * We pass a safe contiguous blocks of memory to use for early boot
-	 * purporses from the previous kernel so that we can resize the
-	 * memblock array as needed.
+	 * We pass a safe contiguous blocks of memory with no preservations to
+	 * use for early boot purporses from the previous kernel so that we can
+	 * resize the memblock array as needed.
 	 */
-	for (int i = 0; i < scratch_cnt; i++) {
-		struct kho_scratch *area = &scratch[i];
+	for (int i = 0; i < bootmem_cnt; i++) {
+		struct kho_bootmem *area = &bootmem[i];
 		u64 size = area->size;
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_noprsrv(area->addr, size);
 		if (err) {
-			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
+			pr_warn("failed to mark the bootmem region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto unmap_scratch;
+			goto unmap_bootmem;
 		}
-		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
+		pr_debug("Marked 0x%pa+0x%pa as bootmem", &area->addr, &size);
 	}
 
-	memblock_reserve(scratch_phys, scratch_len);
+	memblock_reserve(bootmem_phys, bootmem_len);
 
 	/*
-	 * Now that we have a viable region of scratch memory, let's tell
+	 * Now that we have a viable region of boot memory, let's tell
 	 * the memblocks allocator to only use that for any allocations.
 	 * That way we ensure that nothing scribbles over in use data while
 	 * we initialize the page tables which we will need to ingest all
@@ -2015,14 +2017,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	memblock_set_kho_noprsrv_only();
 
 	kho_in.fdt_phys = fdt_phys;
-	kho_in.scratch_phys = scratch_phys;
-	kho_scratch_cnt = scratch_cnt;
+	kho_in.bootmem_phys = bootmem_phys;
+	kho_bootmem_cnt = bootmem_cnt;
 
 	populated = true;
 	pr_info("found kexec handover data.\n");
 
-unmap_scratch:
-	early_memunmap(scratch, scratch_len);
+unmap_bootmem:
+	early_memunmap(bootmem, bootmem_len);
 unmap_fdt:
 	early_memunmap(fdt, fdt_len);
 report:
@@ -2034,47 +2036,47 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 int kho_fill_kimage(struct kimage *image)
 {
-	ssize_t scratch_size;
+	ssize_t bootmem_size;
 	int err = 0;
-	struct kexec_buf scratch;
+	struct kexec_buf bootmem;
 
 	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
 
-	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
-	scratch = (struct kexec_buf){
+	bootmem_size = sizeof(*kho_bootmem) * kho_bootmem_cnt;
+	bootmem = (struct kexec_buf){
 		.image = image,
-		.buffer = kho_scratch,
-		.bufsz = scratch_size,
+		.buffer = kho_bootmem,
+		.bufsz = bootmem_size,
 		.mem = KEXEC_BUF_MEM_UNKNOWN,
-		.memsz = scratch_size,
+		.memsz = bootmem_size,
 		.buf_align = SZ_64K, /* Makes it easier to map */
 		.buf_max = ULONG_MAX,
 		.top_down = true,
 	};
-	err = kexec_add_buffer(&scratch);
+	err = kexec_add_buffer(&bootmem);
 	if (err)
 		return err;
-	image->kho.scratch = &image->segment[image->nr_segments - 1];
+	image->kho.bootmem = &image->segment[image->nr_segments - 1];
 
 	return 0;
 }
 
-static int kho_walk_scratch(struct kexec_buf *kbuf,
+static int kho_walk_bootmem(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
 	int ret = 0;
 	int i;
 
-	for (i = 0; i < kho_scratch_cnt; i++) {
+	for (i = 0; i < kho_bootmem_cnt; i++) {
 		struct resource res = {
-			.start = kho_scratch[i].addr,
-			.end = kho_scratch[i].addr + kho_scratch[i].size - 1,
+			.start = kho_bootmem[i].addr,
+			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
 		};
 
-		/* Try to fit the kimage into our KHO scratch region */
+		/* Try to fit the kimage into our KHO bootmem region */
 		ret = func(&res, kbuf);
 		if (ret)
 			break;
@@ -2091,7 +2093,7 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
 	if (!kho_enable || kbuf->image->type == KEXEC_TYPE_CRASH)
 		return 1;
 
-	ret = kho_walk_scratch(kbuf, func);
+	ret = kho_walk_bootmem(kbuf, func);
 
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 257ee8a52be6..7d74477da0b7 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -77,23 +77,23 @@ void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob)
 	}
 }
 
-static int scratch_phys_show(struct seq_file *m, void *v)
+static int bootmem_phys_show(struct seq_file *m, void *v)
 {
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
+	for (int i = 0; i < kho_bootmem_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_bootmem[i].addr);
 
 	return 0;
 }
-DEFINE_SHOW_ATTRIBUTE(scratch_phys);
+DEFINE_SHOW_ATTRIBUTE(bootmem_phys);
 
-static int scratch_len_show(struct seq_file *m, void *v)
+static int bootmem_len_show(struct seq_file *m, void *v)
 {
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
+	for (int i = 0; i < kho_bootmem_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_bootmem[i].size);
 
 	return 0;
 }
-DEFINE_SHOW_ATTRIBUTE(scratch_len);
+DEFINE_SHOW_ATTRIBUTE(bootmem_len);
 
 __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
@@ -186,13 +186,13 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 	if (IS_ERR(sub_fdt_dir))
 		goto err_rmdir;
 
-	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
-				&scratch_phys_fops);
+	f = debugfs_create_file("bootmem_phys", 0400, dir, NULL,
+				&bootmem_phys_fops);
 	if (IS_ERR(f))
 		goto err_rmdir;
 
-	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
-				&scratch_len_fops);
+	f = debugfs_create_file("bootmem_len", 0400, dir, NULL,
+				&bootmem_len_fops);
 	if (IS_ERR(f))
 		goto err_rmdir;
 
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 805d2a76c388..e9685e1ef6d7 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -19,8 +19,8 @@ struct kho_debugfs {
 struct kho_debugfs {};
 #endif
 
-extern struct kho_scratch *kho_scratch;
-extern unsigned int kho_scratch_cnt;
+extern struct kho_bootmem *kho_bootmem;
+extern unsigned int kho_bootmem_cnt;
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index f7e42e813de1..0351913ce79b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1793,7 +1793,7 @@ void * __init memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid)
 	if (numa_valid_node(nid) && !exact_nid) {
 		nid = NUMA_NO_NODE;
 		/*
-		 * If a previous candidate overlapped with KHO scratch, it would
+		 * If a previous candidate overlapped with KHO bootmem, it would
 		 * update start or end. Now that the search is opening to all
 		 * nodes, reset them.
 		 */
@@ -1809,12 +1809,12 @@ void * __init memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid)
 found:
 	/*
 	 * HugeTLB pages can be preserved with KHO and no preserved memory can
-	 * be in scratch. So retry if found address overlaps with scratch.
+	 * be in bootmem. So retry if found address overlaps with bootmem.
 	 *
-	 * Scratch areas are normally not very large, so this shouldn't take too
+	 * Bootmem areas are normally not very large, so this shouldn't take too
 	 * many retries.
 	 */
-	if (kho_scratch_overlap(addr, size)) {
+	if (kho_bootmem_overlap(addr, size)) {
 		if (memblock_bottom_up())
 			start = addr + size;
 		else
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 78d63789a969..d03156be0e10 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -681,7 +681,7 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
-		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
+		enum migratetype mt = kho_bootmem_migratetype(pfn, migratetype);
 
 		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
 		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
@@ -764,7 +764,7 @@ static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 
 	if (pageblock_aligned(pfn)) {
 		enum migratetype mt =
-			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+			kho_bootmem_migratetype(pfn, MIGRATE_MOVABLE);
 		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
 	}
 }
@@ -924,7 +924,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * over the place during system boot.
 		 */
 		if (pageblock_aligned(pfn)) {
-			enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
+			enum migratetype mt = kho_bootmem_migratetype(pfn, migratetype);
 
 			init_pageblock_migratetype(page, mt, isolate_pageblock);
 			cond_resched();
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index e86bb9000b22..46c5a156fce4 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -66,7 +66,7 @@ static inline void init_deferred_page(unsigned long pfn, int nid)
 
 #define __SetPageReserved(p)	((void)(p))
 
-static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 {
 	return false;
 }
-- 
2.55.0.679.g6767b8d81c-goog

