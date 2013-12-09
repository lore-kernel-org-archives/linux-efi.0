From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 01/14] x86/mm: sparse warning fix for early_memremap
Date: Mon,  9 Dec 2013 17:42:14 +0800
Message-ID: <1386582147-9802-2-git-send-email-dyoung@redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386582147-9802-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

There's a lot of sparse warnings for code like below:
void *a = early_memremap(phys_addr, size);

early_memremap intend to map kernel memory with ioremap facility, the return
pointer should be a kernel ram pointer instead of iomem one.

For making the function clearer and supressing sparse warnings this patch
do below two things:
1. cast to (__force void *) for the return value of early_memremap
2. add early_memunmap function and pass (__force void __iomem *) to iounmap

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/include/asm/io.h |  3 ++-
 arch/x86/mm/ioremap.c     | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..1db414f 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -325,9 +325,10 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
+extern void *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..bbb4504 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -562,10 +562,9 @@ early_ioremap(resource_size_t phys_addr, unsigned long size)
 }
 
 /* Remap memory */
-void __init __iomem *
-early_memremap(resource_size_t phys_addr, unsigned long size)
+void __init *early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void *)__early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
@@ -620,3 +619,8 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}
-- 
1.8.3.1
