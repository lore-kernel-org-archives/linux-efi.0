From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 13/13] x86/efi: Only map kernel text for EFI mixed mode
Date: Wed, 17 Feb 2016 12:36:06 +0000
Message-ID: <1455712566-16727-14-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The correct symbol to use when figuring out the size of the kernel
text is '_etext', not '_end' which is the symbol for the entire kernel
image includes data and debug sections.

Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 40d2f447a9dd..49e4dd4a1f58 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -275,7 +275,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.phys_stack = virt_to_phys(page_address(page));
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
-	npages = (_end - _text) >> PAGE_SHIFT;
+	npages = (_etext - _text) >> PAGE_SHIFT;
 	text = __pa(_text);
 	pfn = text >> PAGE_SHIFT;
 
-- 
2.6.2
