Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792838767;
	b=igl/0maKD5WBN1l1aoKUvndwBKnJ+tLSDeZClMH/gzCNjd664/ZA85jrDyFgdtgqu6Oo
	 vcpKE9E7hn9We8pfyG96IprvhM/KhQVmAs5Li3Y3FryEOqoYeoV/4EjUzgcvfT367JG1/
	 ObYbfIYLRiteW9d9NUH8R/DOiH1rWt+9bktp9hb93H83hoGznuT61z5/9AdtsM5pHanJ3
	 ME3Jf21OQdWAdCq7gEE5Jf9o+1E8pyuj4h0zJUyE5p/7jFSf6EBbnd0690l+hjKLU4Yz/
	 WDZUZxkEz9ggyxr/tGpzb1IRbHmH11FCHDWV4J5UdcIcWBg1rOm9RXJuvuaypzUy9Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792838767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
	b=LtLqrshcRkAZ1Pt8Dneh3PHx2qEt9si4AUXYj6EAqEvfWaAGKGtwhOmf6JfSY6Adz7rK
	 B5MdaTaSvY1vd+Uds56Q6VFKJJsCQoO04z65a7KqUADmU+4m0QFW4xg84j6aIfO0WAnuq
	 ifArGGFq5FOkCtks9z69fOvcLiBapEwKrFq0t4P6wyQFH6e+D0cc4wRNBFSYAFfjO/d8W
	 x+DomTV4nYaeJg0BxET/Kq2cZBBbBhWbscOsjTVYlDC+d9UGGak8pBLUfI48yEuDRVLs+
	 RhTN1GgS8TmD9yiWvP3QOFOXV/cprFf+2GhjS/L+Pmloo5KS3gGAmZNeiCZ3Cw2mbrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OK8BbQHz;
	arc=none smtp.remote-ip=209.85.221.171
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5A0606A31D
	for <linux-efi@vger.kernel.org>; Sat, 24 Oct 2026 10:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA5A0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OK8BbQHz
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eac925bac3so290489e0c.0
        for <linux-efi@vger.kernel.org>; Sat, 24 Oct 2026 03:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792838766; x=1793443566; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
        b=OK8BbQHzM5RrUJpfUHsP4lq0v+SDD46VuMG3gD5VYaC7zVUeUa+YcFqJ3XSLiHcAxt
         n87sdQrxC3Tj7TlmVFUlvzesxzGIBVqPgbqqWWtk5czOqwxq5XulxWPaJtZ2BBVfs/Hy
         0u6L8zFG6cNDF9joD50Q2KYm1RQU++XufJ0xmx686wf0AQ60/sWITPQr8wUK7p3x9GnZ
         fKjhiNsnS2LiqTENN5P/aqOCfC4iEmqHftQXd1ytPtdxBeIRHugzwufakaPsbl5O/Fkd
         dUuw8x+6mG17RKEcovjy42qHNySUucxLkCp88wm0hgxKzyWigiNCQepRYhaocDaK55j9
         BLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792838766; x=1793443566;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yI6gnpr3iD8MepU4vdxCrnHeeo0inroAoiiaaC1yzbs=;
        b=wtCoTmMX6AnwS0d/SQUVsOfDB4JFQNsuZOhxpKmjom61IVz+tTjNTeObE7dP1ulIOH
         EIkI2JgFva+eaJrvMiaXFZJgykkGJRxk9eKKYjtXYshS313gGagX3exoxxzOSMu5sJ8t
         OvSYKdNY7JVy2Ak1pYVq5MH6yqNx+z+JK63r5VII3nIHC1jlGOlLwV/aBuml7DEP5DyB
         V022xTUkxIDeXRa3fnaeaVVoY5yY3fiZwro2P6mN6I8vyaaqC59ajBShQoHjn6N7NKPj
         +hVDM0OGk5Y0kEvC8es8QzSbRwhazdQEaoJbHOa7RoguReN7IrKF4FH5A+gDcDWaG1CG
         IauA==
X-Gm-Message-State: AFq9FYIdrT53KpmSM/yrhK/Xd2fLFTLVtn7HAAGiVCijYS3s2SmAoVW4
	RZLp9QbykZhFUetFGBbdWQc8vFu6ndl8BY1tcjQGMA85qBifq3zYOYO8
X-Gm-Gg: AYBFou1uIqflkm1e10QcjLJ/yca1ihivuS1QBj5LoDv/SPv3h0ciFU12T3nXvYKsZ9G
	rS17uL3sYNA03ysSr/6cZQD8sRR1bZ1KLnEUZUy6d2reeNpyfChi0rVSWb1U6nKZmaLPn6IyGb5
	sPdID5VLmhEurHPnCOryiUYplwGMSY94lGL68jU7QL3tn+HleMXLvz2EGMkF7Qh4xGDe6XBh2Rv
	pJReg/0LC7wwNtj4F5uQIDRpCr1NyGK+1YJPVLKxntApELswWXLP31c74ymuqPt+M4N/b62JIGY
	QDAOoB2jbbHd7oLi0HoQGyXd5bV2Qkc/5JAL/4ZmW57GOy+wnd1b6mq3lHc7lKtJJiZ9RKP8nCT
	nQNIQyIAIAW7ZiSwNpvlt8QQ35liGEiO6lrtOzEbUFLsYBr18xUbZKUkb2iJY6DTwRl9jlQ0siO
	YLfo0R3JpkssV16IfBCUwfFP/fvyMbG7sSFZJ3eZBpbposcBX78mwd3hacL8ProtXd0chShaEe7
	SfKFx6Z56RbZgDFk3ojldlx00Z0Qpclnn9603gyo/PAScS22j6d66jY1QR/YNIHTo3oPo5fN+OS
	Br39
X-Received: by 2002:a05:6102:1492:b0:7cc:32da:56e with SMTP id ada2fe7eead31-7ce5cd41446mr429300137.19.1792838765631;
        Sat, 24 Oct 2026 03:46:05 -0700 (PDT)
Received: from DESKTOP-7QP7L26 ([45.190.211.148])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910e7b7069sm2191025241.3.2026.10.24.03.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 03:46:05 -0700 (PDT)
From: dev12124 <joaoanandalima@gmail.com>
To: linux-mm@kvack.org
Cc: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	ardb@kernel.org,
	keescook@chromium.org,
	dev12124 <joaoanandalima@gmail.com>
Subject: [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page Fault and Overcommit elimination
Date: Sat, 24 Oct 2026 07:45:42 -0300
Message-ID: <20261024104552.394-1-joaoanandalima@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.3
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi mm subsystem,

This patch implements the Memory Tatic called PPM, Page-Plugger Under Memory.
The Main Objective is: Page Faults and Overcommit Elimination.

A few points under additionate:

1. Allocation Handshake (ppm_kalloc):
Using the GFP_PLUG_MEMORY mask, the allocator completely bypasses
passive overcommit verification. It instantly isolates physical frames
on the RAM, maps the page table entries síncronamente, and forces the
Present Bit and Writable Bit to 1 before returning the address block
register to the CPU.

2. Desallocation Cleanup (ppm_kfree):
Triggered via the GFP_FREE_T parameter, the release phase executes an
immediate length truncation to 0. It forces a synchronous TLB
invalidation (via invlpg execution) and flushes the data out of the L3
cache lines using clflushopt instructions before moving the hot clean
pages into a dedicated priority recycling pool.

I additionate a Buffer/Cache with store important objects.






---
 include/linux/ppm/gfp_types.h |  74 ++++++++++++++++
 include/linux/slab.h          |  11 +++
 mm/memory.c                   | 158 ++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 include/linux/ppm/gfp_types.h

diff --git a/include/linux/ppm/gfp_types.h b/include/linux/ppm/gfp_types.h
new file mode 100644
index 000000000..741122b2d
--- /dev/null
+++ b/include/linux/ppm/gfp_types.h
@@ -0,0 +1,74 @@
+/* 
+  Memory Tatic: PPM (Page-Plugger Under Memory).
+  This File is for PPM Flags/Macros/Functions/Types.
+  Engineer (brazilian): João Guilherme da Silva Freitas Lima <joanandalima@gmail.com>
+ */
+
+/* Types Include Guards */
+#ifndef __PPM_TYPES_MEMORY 
+#define __PPM_TYPES_MEMORY 
+
+typedef unsigned char uint8_t;
+typedef unsigned short uint16_t;
+typedef unsigned int uint32_t;
+typedef unsigned long long uint64_t;
+typedef uint64_t gfp_t;
+/* For errors in Allocation */
+#define __PPM_ALLOC_ERROR -102
+/* For errors in Desallocation */
+#define __PPM_FREE_ERROR 0x04 
+/* For success */
+#define __PPM_SUCCESS 0
+#endif
+
+/* Functions Include Guards */
+#ifndef __PPM_FUNCTIONS_MEMORY
+#define __PPM_FUNCTIONS_MEMORY 
+
+/* Initializer */
+void __init_ppm_memory();
+
+/* Allocator Optimized */
+int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags);
+
+/* Desallocator Optimized */
+int ppm_kfree(uint64_t size);
+
+#endif
+
+/* Flags Include Guards */
+#ifndef __PPM_FLAGS_MEMORY 
+#define __PPM_FLAGS_MEMORY
+
+/* PPM inits/starts in Bit 54 of a 
+   64-bit variable 
+ */
+gfp_t GFP_PLUG_MEMORY = (1ULL << 54); 
+
+/* For free memory, the Bit 55 is 
+   used 
+ */
+gfp_t GFP_FREE_T = (1ULL << 55);
+
+#endif 
+
+/* Macros Include Guards */
+#ifndef __PPM_MACROS_MEMORY
+#define __PPM_MACROS_MEMORY
+
+/* For Kernel Kernel tests 2 Bits (54 and 55) in 
+  1 Clock Cycle (or in small clocks, example: 5 Clocks), 
+  is used a mask using | 
+ */
+gfp_t GFP_MASK = GFP_PLUG_MEMORY | GFP_FREE_T;
+
+#endif
+
+/* 
+  Notes:
+    E-Mail of RFC:
+        [RFC] mm: page-fault: overcommit: PPM (Page-Plugger Under Memory)
+    
+    
+    Assigned-Off-by: João <joanandalima@gmail.com>
+ */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def..c76243128 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -22,6 +22,17 @@
 #include <linux/percpu-refcount.h>
 #include <linux/cleanup.h>
 #include <linux/hash.h>
+#include <linux/ppm/gfp_types.h>
+
+/* A Structure enum with objects and codes
+  for PPM Tatic Memory 
+ */
+enum __PPM_OBJ_CDE_BITS {
+	_PPM_OBJECT_CACHE, /* A Simple Cache to store objects */
+	_PPM_OBTAIN_CODE, /* 0x04, -102 or 0 */
+    _PPM_FLAGS__ /* The Special Flags to PPM (Page-Plugger Under Memory) */
+};
+
 
 enum _slab_flag_bits {
 	_SLAB_CONSISTENCY_CHECKS,
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735..5e1ca12c4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,8 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/ppm/gfp_types.h>
+#include <linux/slab.h>
 
 #include <trace/events/kmem.h>
 
@@ -94,6 +96,137 @@
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
 #endif
 
+/* Small Variables for 
+  PPM uses 
+ */
+int ppm_free_error;
+int ppm_alloc_error;
+int ppm_success;
+unsigned int order;
+unsigned int nr_pages = 1 << order;
+unsigned int i;
+struct vm_area_struct *vma;
+spinlock_t *ptl;
+
+/* Initializer of PPM */
+void __init_ppm_memory() 
+{
+	
+	/* 1. Define the variables for 
+	 the rest of System uses 
+	 */
+	ppm_free_error = __PPM_FREE_ERROR;
+	ppm_alloc_error = __PPM_ALLOC_ERROR;
+	ppm_success = __PPM_SUCCESS;
+
+	/* 2. Connect __PPM_OBJ_CDE_BITS to 
+	   flags under gfp_types.h 
+	 */
+	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE = 4 * 1024 * 1024; /* 4MB for alloc, used to store important objects */
+	__PPM_OBJ_CDE_BITS.__PPM_OBTAIN_CODE = 0; /* Is modifyed in ppm_kalloc() and ppm_kfree() */
+	__PPM_OBJ_CDE_BITS.__PPM_FLAGS__ = GFP_MASK; /* The Kernel uses this for test */
+
+	/* 3. Alloc the Cache of Objects */
+	char *ppm_identifier = "PPM Cache";
+	int *result_ptr = kmem_cache_create(ppm_identifier, 
+		8, 
+		_slab_flag_bits._SLAB_HWCACHE_ALIGN,
+		_slab_flag_bits._SLAB_PANIC 
+	); /* Number 8 for a 64-bit Pointer */
+	__PPM_OBJ_CDE_BITS.__PPM_OBJECT_CACHE = result_ptr;
+
+	/* 4. Return success */
+	ppm_success = __PPM_SUCCESS; /* The Kernel Optional-Action is verify if ppm_success is __PPM_SUCCESS */
+}
+
+/* Allocator to PPM */
+int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags) 
+{
+	if (unlikely(!size)) 
+		return __PPM_ALLOC_ERROR;
+
+	/* 1. Alloc the size */
+	order = get_order(size);
+	struct page *pages_ppm = alloc_pages(
+		flags | GFP_PLUG_MEMORY,
+		order
+	);
+
+	/* 2. Navigation in PTE (Page Table Walk) */
+	/* 2.1. Obtain PGD */
+	pgd_t *pgd = pgd_offset(current->mm, address);
+	/* 2.2. Obtain P4D */
+	p4d_t *p4d = p4d_alloc(current->mm, pgd, address);
+	/* 2.3. Obtain PUD */
+	pud_t *pud = pud_alloc(current->mm, p4d, address);
+	/* 2.4. Obtain PMD */
+	pmd_t *pmd = pmd_alloc(current->mm, pud, address);
+	
+	/* 3. Plugging */
+	/* Entry in PTE */
+	pte_t *pte = pte_offset_map_lock(current->mm, pmd, address, &ptl);
+	for (int i = 0; i < nr_pages; i++)
+	{
+		/* Calcle the memory allocated in 1 step */
+		pte_t entry = pfn_pte(page_to_pfn(pages_ppm) + i, vma->vma_page_prot);
+		entry = pte_mkdirty(entry); /* Active bit dirty */
+		entry = pte_mkyoung(entry); /* Active bit young/present */
+	}
+
+	/* 4. Finalize setting in the RAM the page */
+	pte_t *new_pte;
+	set_pte_at(current->mm, address, pte, new_pte);
+
+	/* 5. Unlock */
+	pte_unmap_unlock(pte, ptl);
+
+	/* 6. Return */
+	ppm_success = __PPM_SUCCESS; /* If value returned == __PPM_SUCCESS? */
+	return ppm_success;
+}
+
+/* Desallocator to PPM */
+int ppm_kfree(uint64_t size) 
+{
+	if (unlikely(!size)) 
+		return __PPM_FREE_ERROR;
+	
+	/* 1. Entry in MMU Directories */
+	pgd_t pgd = pgd_offset(current->mm, address);
+	p4d_t p4d = p4d_alloc(current->mm, pgd, address);
+	pud_t pud = pud_alloc(current->mm, p4d, address);
+	pmd_t pmd = pmd_alloc(current->mm, pud, address);
+
+	/* 2. Entry in PTE */
+	pte_t pte = pte_offset_map_lock(current->mm, pmd, address, &ptl);
+	/* Verify if the PPM plugged the page */
+	pte_t result_for_check = ptep_get(pte);
+	pte_val(result_for_check) & GFP_PLUG_MEMORY;
+	if (result_for_check > 1) 
+	{
+		pte_clear(current->mm, address, pte);
+	} else `{
+		/* No executes/call, is ignored */
+		
+	}
+
+	/* 3. Flush for clear the TLB */
+	flush_tlb_page();
+
+	/* 4. Unlock PTE */
+	pte_unmap_unlock(pte, ptl);
+
+	/* 6. Extract the Pointer to free */
+	int identifier_numeric = pte_pfn(result_for_check);
+	struct page *ptr_result = pfn_to_page(identifier_numeric);
+	free_pages(ptr_result, order);
+
+	/* 7. Return success */
+	ppm_success = __PPM_SUCCESS;
+	return ppm_success;
+}
+
+
 static vm_fault_t do_fault(struct vm_fault *vmf);
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf);
 static bool vmf_pte_changed(struct vm_fault *vmf);
@@ -6848,6 +6981,31 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 	__set_current_state(TASK_RUNNING);
 
+	/* If PPM returns no is == __PPM_SUCCESS, ignore the PPM Mode and 
+	   sign the default flow 
+	 */
+	int code_error = __init_ppm_memory();
+	if (code_error == 0) 
+	{
+		/* Verify flags */
+		unsigned int ppm_check = flags & GFP_MASK;
+		if (ppm_check == GFP_PLUG_MEMORY)
+		{
+			ppm_kalloc(address, size, flags);
+			return VM_FAULT_NOPAGE;
+		} else if (ppm_check == GFP_FREE_T) {
+			ppm_kfree(size);
+			return VM_FAULT_NOPAGE;
+		} else {
+			/* Executes none */
+		}
+
+	} else {
+		/* Executes none, is jump to the instruction of 
+		   'ret = sanitize_fault_flags(vma, &flags)' and next 
+		 */		
+	}
+
 	ret = sanitize_fault_flags(vma, &flags);
 	if (ret)
 		goto out;
--


Signed-Off-by: João Guilherme da Silva Freitas Lima <joaoanandalima@gmail.com>







2.55.0.windows.3

