From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/12] x86/efi: Clean up a minor mistake in code comment
Date: Tue,  4 Apr 2017 17:02:43 +0100
Message-ID: <20170404160245.27812-10-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

EFI allocate runtime services regions from EFI_VA_START, -4G, down
to -68G, EFI_VA_END, 64G altogether. The mechanism was introduced in
commit d2f7cbe7b26a7 ("x86/efi: Runtime services virtual mapping").

Clean it up to avoid confusion.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index d56dd864fb1c..4e043a8c8556 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,7 +47,7 @@
 #include <asm/pgalloc.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * We allocate runtime services regions top-down, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
 static u64 efi_va = EFI_VA_START;
-- 
2.9.3
