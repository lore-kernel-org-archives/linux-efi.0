Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026119;
	b=1+7uvAXw5Tz2uKgTgCi0VaFXKHLSfjHwJZ8HJvGf4RWN30wMxxGQ7IuH2IBCPov+djaL
	 sD2mPhtLG9I+ICAFDf8Nej3lddUG62W5biAZeUXX7wqTVN/yU8I8w/CQ3up9mGuSlPRzQ
	 j8juzRpWWRjalf0f2NYDkaC5h+lm5YbOL7w6AZA6oCwCSGXHnGPYO1QBlVC0N9nZkFTxv
	 SH04Sw0D/h90pmXUF/nGAMur7oYmg8uQYX9lhoIF1lMPS4HdXp7MiuQQAV+e96SzXyCGh
	 glwSG9KTHwdU3gKwP2RGTalVyUDhvASU2AZQt+AyMdAQNPRV2vPXwe729DTS7+/TErQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=LM4UWhtNaf+31HpscxLGjqcPcYVKjie0R23WUyOHwoM=;
	b=M+XnpItqzdEyrb+CUATz+sztEN49d8frs2JwQSfWRWOxeSWJ8j4mo3O/o59bst2Mxn1h
	 fY3gdPm2vejmJWaxhP8OlCs/SNQJeOTiTk6wx4vB7EWDxoJdevKbXS3X8ppYcnrii8a3z
	 2cOPuCWMYAtWtzseiCmraK537YX1eA2nMaBTnGEY1+cCpWB03kDQH/x9ViGx/B2PZd6sJ
	 uBklSYcTpUB4G9VYX5BeHS7NkmGofQhX99YUoWvfiSi600984bNHl3KWyE39jcu3NbqAd
	 Hqs45vk9WAIGRBTN+fizyrktzG54hoMoHSlJZBSctsw6XSR7w8KiYf637ixmq2VNoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QA9o3Eby;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EBB606A330
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32EBB606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QA9o3Eby
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4b9fde3044dso9457345e9.0
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026116; x=1795630916; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LM4UWhtNaf+31HpscxLGjqcPcYVKjie0R23WUyOHwoM=;
        b=QA9o3Ebyd6hEXAjR3MdjDD44yBzYBw82Tt+kFK3B0qP81Unw8w900/Q98MpT27PMUY
         nxQnF6v9xfJwkyAOLsWcGXnj510vKBulYsTcEUIUYFoe33zPdveIhzT5ll72o0mAL3ID
         ukY3DJXWooxvOE3wZu0YOQ0Dlb67XKKhlVfuh9DMF0WwHsJWeGEK9knrTtxFni2xa+bn
         bS7B5BWFej5UAsUKe9JtuHaAOthAuN9BvAbk5NCyGzkXw/xhI43ZoxRMucj9F9cWX8Wa
         fCShAPvL+GpSnrTZ2h0g4n0p5Ytq/yAu5sJoh0Wdk7k95d7j6ZOgSuwOmibJW1XA/I1z
         df7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026116; x=1795630916;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LM4UWhtNaf+31HpscxLGjqcPcYVKjie0R23WUyOHwoM=;
        b=sv8MBiDAm8LZ52xZs2zai1qQJuCUPk8eySNbylPszMCpuZXV6Kvfi1xTNBT3S0xpqY
         UlytXj7rTvZAyuVuq8i2D0Y+Ioze3SS0DE0epOr/5FD76rXqR+yz8i0z8EiIzKWgcccG
         dNwZIU6Ue0vGvZ/sOhiIhtNpPlTx2irXhvn8dWdptbSsHHaXebg1XB4xfNY2k+myhPyE
         eucJNDz10zVq6JqOcYWvZcc+ENe1tNndaHnDJe3iSnHUrT0wSvzKvoMIX6b+9id0F7dJ
         foWCKisPs2AXv37fmiPv7976lcvwDJUvsI+7sVyeUqbAAGY+M/zcpf3CT62J2Ev4QOy2
         7A4g==
X-Gm-Message-State: APuU4Z+aVBhdxZAyMeUz+4NFG9DRNC3sLzmKIJ5QFBWWkBxm3sXDaerW
	xJnxLZjD1g2vODT2qBrJ3mQBeqV/xBC+TietxByYKpJVarmTqRWAjaFAPU/+aNtPdWn1A7ONxEL
	Q0ifBC1Gp7OJgI5sbGvkc0C9uajBHKKXstTfqEfHuYibvImroOhleabftS1Y8OEFDuSh1vW/rf6
	4jk5zJL2hDQi4W1W1cRyIH4adtT5nEvA==
X-Received: from wmdd13.prod.google.com ([2002:a05:600c:a20d:b0:4a1:fd4d:ad4e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f82:b0:4a6:44b:2593
 with SMTP id 5b1f17b1804b1-4bb7da4a0b5mr67681055e9.29.1795026116240; Wed, 18
 Nov 2026 10:21:56 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:12 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6981; i=ardb@kernel.org;
 h=from:subject; bh=tY79MuljiH6CJlV+ev4wNhil+QqJwdsIKUw56aBQG+A=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm1lNN8P7zu5v4p15yGKDz8auyrpX/8JO3Jjzc7F76
 017o5MXOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEUgIYGR63qslb1WQ1vd02
 2zHFaJFdsHRqTosaz6KMYu1kmbOTnjEyrGDhOMqipm5t7P47ZencAkmF7oJ5rN21V9xDhLxCvig zAAA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-27-ardb+git@google.com>
Subject: [PATCH v4 06/19] efi/libstub: arm: Size the decompressed kernel
 allocation precisely
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The ARM EFI stub reserves a window for the decompressed kernel, as the
decompressor writes it to memory without regard for other allocations
made while running under the firmware. Currently, this window is
MAX_UNCOMP_KERNEL_SIZE (32 MiB) in size, but it starts 5 pages below the
kernel's start address, to cover the initial page tables. This leaves
32 MiB minus 5 pages for the kernel itself, and nothing checks whether
that is sufficient. Large kernels (e.g., multiplatform builds with debug
options enabled) can exceed this, in which case the decompressed image
and its BSS overrun the reservation into memory that the firmware
regards as free, and which may have been handed out for the FDT, the
initrd or the EFI memory map.

So instead, size the window based on the actual memory footprint of the
kernel: the uncompressed image size, which is stored in the last 4 bytes
of the compressed payload, plus the size of BSS, which is recorded in
the zImage tag table, plus the size of the initial page tables, which is
4 pages, or 5 pages when LPAE is enabled.

While at it, drop the requirement that the window is aligned to a power
of two that is at least TEXT_OFFSET, which means 4 MiB when TEXT_OFFSET
is 0x208000 or 0x308000. The only actual requirement is that the
physical start of the kernel minus TEXT_OFFSET, which becomes
PHYS_OFFSET, is a multiple of 2 MiB, as required by the phys-to-virt
patching code. The reason for the larger alignment was that the existing
logic breaks down when the slack below the kernel exceeds the alignment,
and so this is fixed by making the additional space that is allocated to
accommodate the alignment the larger of 2 MiB and the size of the slack.
This also ensures that PHYS_OFFSET never ends up below the 2 MiB aligned
block containing the start of the allocation, which only requires DRAM
to be 2 MiB aligned rather than 4 MiB aligned.

Finally, free the unused parts at either end of the allocation without
updating alloc_base and alloc_size in place, so that both frees are
derived directly from the original allocation, and return the reserved
window to the caller as is.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/efi.h                | 15 ++--------
 drivers/firmware/efi/libstub/arm32-stub.c | 31 ++++++++++++--------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e408399d5f0e..c28508c6e107 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -56,22 +56,11 @@ void efi_virtmap_unload(void);
 
 /* arch specific definitions used by the stub code */
 
-/*
- * A reasonable upper bound for the uncompressed kernel size is 32 MBytes,
- * so we will reserve that amount of memory. We have no easy way to tell what
- * the actuall size of code + data the uncompressed kernel will use.
- * If this is insufficient, the decompressor will relocate itself out of the
- * way before performing the decompression.
- */
-#define MAX_UNCOMP_KERNEL_SIZE	SZ_32M
-
 /*
  * phys-to-virt patching requires that the physical to virtual offset is a
- * multiple of 2 MiB. However, using an alignment smaller than TEXT_OFFSET
- * here throws off the memory allocation logic, so let's use the lowest power
- * of two greater than 2 MiB and greater than TEXT_OFFSET.
+ * multiple of 2 MiB.
  */
-#define EFI_PHYS_ALIGN		max(UL(SZ_2M), roundup_pow_of_two(TEXT_OFFSET))
+#define EFI_PHYS_ALIGN		SZ_2M
 
 /* on ARM, the initrd should be loaded in a lowmem region */
 static inline unsigned long efi_get_max_initrd_addr(unsigned long image_addr)
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 1073dd947516..1ab15d66e709 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -76,6 +76,12 @@ void efi_handle_post_ebs_state(void)
 		      &efi_entry_state->sctlr_after_ebs);
 }
 
+/* last unaligned u32 in the image carries the uncompressed size */
+extern u32 input_data_end[] __aligned(1);
+
+/* entry #3 in the zimage magic table carries the kernel's BSS size */
+extern u32 zimage_magic_table[] asm("_table_start");
+
 efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
 				 unsigned long *reserve_addr,
@@ -83,18 +89,22 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle)
 {
-	const int slack = TEXT_OFFSET - 5 * PAGE_SIZE;
-	int alloc_size = MAX_UNCOMP_KERNEL_SIZE + EFI_PHYS_ALIGN;
+	unsigned long kernel_memsize = input_data_end[-1] + zimage_magic_table[3];
+	const int pgdir_size = (4 + IS_ENABLED(CONFIG_ARM_LPAE)) * PAGE_SIZE;
+	int alloc_size = pgdir_size + ALIGN(kernel_memsize, EFI_PAGE_SIZE);
+	const int slack = TEXT_OFFSET - pgdir_size;
+	const unsigned long margin = max(EFI_PHYS_ALIGN, slack);
 	unsigned long alloc_base, kernel_base;
 	efi_status_t status;
 
 	/*
 	 * Allocate space for the decompressed kernel as low as possible.
-	 * The region should be 16 MiB aligned, but the first 'slack' bytes
+	 * The region should be 2 MiB aligned, but the first 'slack' bytes
 	 * are not used by Linux, so we allow those to be occupied by the
 	 * firmware.
 	 */
-	status = efi_low_alloc_above(alloc_size, EFI_PAGE_SIZE, &alloc_base, 0x0);
+	status = efi_low_alloc_above(alloc_size + margin, EFI_PAGE_SIZE,
+				     &alloc_base, 0x0);
 	if (status != EFI_SUCCESS) {
 		efi_err("Unable to allocate memory for uncompressed kernel.\n");
 		return status;
@@ -103,7 +113,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if ((alloc_base % EFI_PHYS_ALIGN) > slack) {
 		/*
 		 * More than 'slack' bytes are already occupied at the base of
-		 * the allocation, so we need to advance to the next 16 MiB block.
+		 * the allocation, so we need to advance to the next 2 MiB block.
 		 */
 		kernel_base = round_up(alloc_base, EFI_PHYS_ALIGN);
 		efi_info("Free memory starts at 0x%lx, setting kernel_base to 0x%lx\n",
@@ -113,16 +123,11 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	}
 
 	*reserve_addr = kernel_base + slack;
-	*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+	*reserve_size = alloc_size;
 
 	/* now free the parts that we will not use */
-	if (*reserve_addr > alloc_base) {
-		efi_bs_call(free_pages, alloc_base,
-			    (*reserve_addr - alloc_base) / EFI_PAGE_SIZE);
-		alloc_size -= *reserve_addr - alloc_base;
-	}
-	efi_bs_call(free_pages, *reserve_addr + MAX_UNCOMP_KERNEL_SIZE,
-		    (alloc_size - MAX_UNCOMP_KERNEL_SIZE) / EFI_PAGE_SIZE);
+	efi_free(*reserve_addr - alloc_base, alloc_base);	/* no-op if 0 */
+	efi_free(alloc_base + margin - *reserve_addr, *reserve_addr + alloc_size);
 
 	*image_addr = kernel_base + TEXT_OFFSET;
 	*image_size = 0;
-- 
2.56.1.708.g77570a6a1d-goog

