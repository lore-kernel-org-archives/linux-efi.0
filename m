From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] PTI: unbreak EFI old_memmap
Date: Fri, 5 Jan 2018 22:35:41 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1801052215460.11852@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dimitri Sivanich <sivanich-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

old_memmap's efi_call_phys_prolog() calls set_pgd() with swapper PGD that 
has PAGE_USER set, which makes PTI set NX on it, and therefore EFI can't 
execute it's code.

Fix that by forcefully clearing _PAGE_NX from the PGD (this can't be done 
by the pgprot API).

_PAGE_NX will be automatically reintroduced in efi_call_phys_epilog(), as 
_set_pgd() will again notice that this is _PAGE_USER, and set _PAGE_NX on 
it.

Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Tested-by: Dimitri Sivanich <sivanich-ZPxbGqLxI0U@public.gmane.org>
Acked-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
--- 
 arch/x86/platform/efi/efi_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index d87ac96e37ed..2dd15e967c3f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -135,7 +135,9 @@ pgd_t * __init efi_call_phys_prolog(void)
 				pud[j] = *pud_offset(p4d_k, vaddr);
 			}
 		}
+		pgd_offset_k(pgd * PGDIR_SIZE)->pgd &= ~_PAGE_NX;
 	}
+
 out:
 	__flush_tlb_all();
 

-- 
Jiri Kosina
SUSE Labs
