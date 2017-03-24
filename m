From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into KASLR VA space for randomization
Date: Fri, 24 Mar 2017 12:59:52 +0800
Message-ID: <1490331592-31860-1-git-send-email-bhe@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Baoquan He <bhe@redhat.com>, stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Dave Young <dyoung@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

Currently KASLR is enabled on three regions: the direct mapping of physical
memory, vamlloc and vmemmap. However EFI region is also mistakenly included
for VA space randomization because of misusing EFI_VA_START macro and
assuming EFI_VA_START < EFI_VA_END.

The EFI region is reserved for EFI runtime services virtual mapping which
should not be included in kaslr ranges. In Documentation/x86/x86_64/mm.txt,
we can see:
  ffffffef00000000 - fffffffeffffffff (=64 GB) EFI region mapping space
EFI use the space from -4G to -64G thus EFI_VA_START > EFI_VA_END,
Here EFI_VA_START = -4G, and EFI_VA_END = -64G.

Changing EFI_VA_START to EFI_VA_END in mm/kaslr.c fixes this problem.

Cc: <stable@vger.kernel.org> #4.8+
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
Acked-by: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
---
v1->v2:
  No code change, just update patch log according to reviewer's comment.

 arch/x86/mm/kaslr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 887e571..aed2064 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -48,7 +48,7 @@ static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
 #if defined(CONFIG_X86_ESPFIX64)
 static const unsigned long vaddr_end = ESPFIX_BASE_ADDR;
 #elif defined(CONFIG_EFI)
-static const unsigned long vaddr_end = EFI_VA_START;
+static const unsigned long vaddr_end = EFI_VA_END;
 #else
 static const unsigned long vaddr_end = __START_KERNEL_map;
 #endif
@@ -105,7 +105,7 @@ void __init kernel_randomize_memory(void)
 	 */
 	BUILD_BUG_ON(vaddr_start >= vaddr_end);
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
-		     vaddr_end >= EFI_VA_START);
+		     vaddr_end >= EFI_VA_END);
 	BUILD_BUG_ON((IS_ENABLED(CONFIG_X86_ESPFIX64) ||
 		      IS_ENABLED(CONFIG_EFI)) &&
 		     vaddr_end >= __START_KERNEL_map);
-- 
2.5.5
