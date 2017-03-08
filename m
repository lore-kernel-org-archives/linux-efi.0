From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] x86/mm/KASLR: Correct the upper boundary of KALSR mm regions if adjacent to EFI
Date: Wed,  8 Mar 2017 15:47:38 +0800
Message-ID: <1488959258-4731-2-git-send-email-bhe@redhat.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488959258-4731-1-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

EFI allocates runtime services regions top-down, starting from EFI_VA_START
to EFI_VA_END. So EFI_VA_START is bigger than EFI_VA_END and is the end of
EFI region. The upper boundary of memory regions randomized by KASLR should
be EFI_VA_END if it's adjacent to EFI region, but not EFI_VA_START.

Correct it in this patch.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
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
