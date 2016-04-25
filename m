From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 30/40] efi/arm-init: Reserve rather than unmap the memory map for ARM as well
Date: Mon, 25 Apr 2016 21:07:02 +0100
Message-ID: <1461614832-17633-31-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Now that ARM has a fully functional memremap() implementation, there is
no longer a need to remove the UEFI memory map from the linear mapping
in order to be able to create a permanent mapping for it using generic
code.

So remove the 'IS_ENABLED(CONFIG_ARM)' conditional we added in commit
7cc8cbcf82d1 ("efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map
mapping"), and revert to using memblock_reserve() for both ARM and arm64

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/arm-init.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 7a3318dd4319..ef90f0c4b70a 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -244,20 +244,9 @@ void __init efi_init(void)
 	efi_memattr_init();
 	early_memunmap(efi.memmap.map, params.mmap_size);
 
-	if (IS_ENABLED(CONFIG_ARM)) {
-		/*
-		 * ARM currently does not allow ioremap_cache() to be called on
-		 * memory regions that are covered by struct page. So remove the
-		 * UEFI memory map from the linear mapping.
-		 */
-		memblock_mark_nomap(params.mmap & PAGE_MASK,
-				    PAGE_ALIGN(params.mmap_size +
-					       (params.mmap & ~PAGE_MASK)));
-	} else {
-		memblock_reserve(params.mmap & PAGE_MASK,
-				 PAGE_ALIGN(params.mmap_size +
-					    (params.mmap & ~PAGE_MASK)));
-	}
+	memblock_reserve(params.mmap & PAGE_MASK,
+			 PAGE_ALIGN(params.mmap_size +
+				    (params.mmap & ~PAGE_MASK)));
 
 	init_screen_info();
 }
-- 
2.7.3
