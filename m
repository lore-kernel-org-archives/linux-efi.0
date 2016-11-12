From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 1/2] x86/efi: Fix EFI memmap pointer size warning
Date: Sat, 12 Nov 2016 21:04:23 +0000
Message-ID: <20161112210424.5157-2-matt@codeblueprint.co.uk>
References: <20161112210424.5157-1-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161112210424.5157-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Fix this when building on 32-bit:

  arch/x86/platform/efi/efi.c: In function ‘__efi_enter_virtual_mode’:
  arch/x86/platform/efi/efi.c:911:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       (efi_memory_desc_t *)pa);
       ^
  arch/x86/platform/efi/efi.c:918:5: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       (efi_memory_desc_t *)pa);
       ^

The @pa local variable is declared as phys_addr_t and that is a u64 when
CONFIG_PHYS_ADDR_T_64BIT=y. (The last is enabled on 32-bit on a PAE
build.)

However, its value comes from __pa() which is basically doing pointer
arithmetic and checking, and returns unsigned long as it is the native
pointer width.

So let's use an unsigned long too. It should be fine to do so because
the later users cast it to a pointer too.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index bf99aa7005eb..936a488d6cf6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -861,7 +861,7 @@ static void __init __efi_enter_virtual_mode(void)
 	int count = 0, pg_shift = 0;
 	void *new_memmap = NULL;
 	efi_status_t status;
-	phys_addr_t pa;
+	unsigned long pa;
 
 	efi.systab = NULL;
 
-- 
2.10.0
