From: Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] x86/efi: fix potential NULL pointer dereference
Date: Fri, 24 Apr 2015 14:07:19 +0800
Message-ID: <1429855639-14706-1-git-send-email-firogm@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In this patch, I add error-handing code for kmalloc() in
arch/x86/platform/efi/efi_64.c::efi_call_phys_prolog().

If kmalloc() failed to alloc memroy, save_pgd will be a NULL
pointer dereferenced by subsequent codes.

Signed-off-by: Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a0ac0f9..62326c4 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -90,6 +90,8 @@ pgd_t * __init efi_call_phys_prolog(void)
 
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
 	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+	if (unlikely(!save_pgd))
+		return NULL;
 
 	for (pgd = 0; pgd < n_pgds; pgd++) {
 		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
-- 
2.1.0
