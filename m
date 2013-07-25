From: Roy Franz <roy.franz@linaro.org>
Subject: [PATCH] correct call to free_pages to specify memory size in pages, not bytes.
Date: Wed, 24 Jul 2013 17:48:44 -0700
Message-ID: <1374713324-23670-2-git-send-email-roy.franz@linaro.org>
References: <1374713324-23670-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374713324-23670-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt.fleming@intel.com, hpa@zytor.com
Cc: roy.franz@linaro.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index d606463..b7388a4 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -225,7 +225,7 @@ static void low_free(unsigned long size, unsigned long addr)
 	unsigned long nr_pages;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table->boottime->free_pages, addr, size);
+	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
 }
 
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
-- 
1.7.10.4
