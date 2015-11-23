From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/6] x86/efi: PFN_ALIGN() _text and _end when calculating number of pages
Date: Mon, 23 Nov 2015 13:33:09 +0000
Message-ID: <1448285594-17617-2-git-send-email-matt@codeblueprint.co.uk>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, stable@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-efi@vger.kernel.org

While _text is currently aligned to PAGE_SIZE in the vmlinux linker
script because it's based on CONFIG_PHYSICAL_ALIGN, it's always better
to be explicit about these things to be sure no alignment bugs are
lurking. There's no analogous enforcement for _end.

Dave provided an example of why the 'npages' calculation is wrong,

 "Just for fun, imagine that _end=0xfff and _text=0x1001.  npages
  would be 0."

Use PFN_ALIGN() to be sure the calculation is correctly aligned to
PAGE_SIZE.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a0ac0f9c307f..3a90eb72d153 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -183,7 +183,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.phys_stack = virt_to_phys(page_address(page));
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
-	npages = (_end - _text) >> PAGE_SHIFT;
+	npages = (PFN_ALIGN(_end) - PFN_ALIGN(_text)) >> PAGE_SHIFT;
 	text = __pa(_text);
 
 	if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
-- 
2.6.2
