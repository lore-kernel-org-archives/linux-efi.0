From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/6] arm64: memblock: don't permit memblock resizing until
 linear mapping is up
Date: Wed,  7 Nov 2018 15:16:06 +0100
Message-ID: <20181107141611.12076-2-ard.biesheuvel@linaro.org>
References: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc: marc.zyngier@arm.com, bhsharma@redhat.com, linux-efi@vger.kernel.org, will.deacon@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Bhupesh reports that having numerous memblock reservations at early
boot may result in the following crash:

  Unable to handle kernel paging request at virtual address ffff80003ffe0000
  ...
  Call trace:
   __memcpy+0x110/0x180
   memblock_add_range+0x134/0x2e8
   memblock_reserve+0x70/0xb8
   memblock_alloc_base_nid+0x6c/0x88
   __memblock_alloc_base+0x3c/0x4c
   memblock_alloc_base+0x28/0x4c
   memblock_alloc+0x2c/0x38
   early_pgtable_alloc+0x20/0xb0
   paging_init+0x28/0x7f8

This is caused by the fact that we permit memblock resizing before the
linear mapping is up, and so the memblock_reserved() array is moved
into memory that is not mapped yet.

So let's ensure that this crash can no longer occur, by deferring to
call to memblock_allow_resize() to after the linear mapping has been
created.

Reported-by: Bhupesh Sharma <bhsharma@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/init.c | 2 --
 arch/arm64/mm/mmu.c  | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 9d9582cac6c4..9b432d9fcada 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -483,8 +483,6 @@ void __init arm64_memblock_init(void)
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 
 	dma_contiguous_reserve(arm64_dma_phys_limit);
-
-	memblock_allow_resize();
 }
 
 void __init bootmem_init(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d6d05c8c5c52..e1b2d58a311a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -671,6 +671,8 @@ void __init paging_init(void)
 
 	memblock_free(__pa_symbol(init_pg_dir),
 		      __pa_symbol(init_pg_end) - __pa_symbol(init_pg_dir));
+
+	memblock_allow_resize();
 }
 
 /*
-- 
2.19.1
