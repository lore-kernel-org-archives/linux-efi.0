From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through memblock after mm_init()
Date: Thu,  5 Jan 2017 13:51:30 +0100
Message-ID: <20170105125130.2815-2-nicstange@gmail.com>
References: <20170105125130.2815-1-nicstange@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105125130.2815-1-nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Before invoking the arch specific handler, efi_mem_reserve() reserves
the given memory region through memblock.

efi_mem_reserve() can get called after mm_init() though -- through
efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
not be used anymore.

Let efi_mem_reserve() check whether memblock is dead and not do the
reservation if so. Emit a warning from the generic efi_arch mem_reserve()
in this case: if the architecture doesn't provide any other means of
registering the region as reserved, the operation would be a nop.

Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Applicable to next-20170105.
No changes to v2.
Boot-tested on x86_64.

 drivers/firmware/efi/efi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 92914801e388..158a8df2f4af 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
 	return end;
 }
 
-void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
+void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
+{
+	WARN(slab_is_available(), "efi_mem_reserve() has no effect");
+}
 
 /**
  * efi_mem_reserve - Reserve an EFI memory region
@@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
  */
 void __init efi_mem_reserve(phys_addr_t addr, u64 size)
 {
-	if (!memblock_is_region_reserved(addr, size))
+	if (!slab_is_available() && !memblock_is_region_reserved(addr, size))
 		memblock_reserve(addr, size);
 
 	/*
-- 
2.11.0
