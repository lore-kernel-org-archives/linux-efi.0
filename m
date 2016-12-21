From: Petr Oros <poros-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] x86/efi Fix regression in efi_arch_mem_reserve
Date: Wed, 21 Dec 2016 14:11:38 +0100
Message-ID: <20161221131138.10512-1-poros@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

  Booting on EFI with ESRT table has been stop since commit:
    8e80632 efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()

  This is caused by this commit:
    816e761 efi: Allow drivers to reserve boot services forever

  Problem is, that efi_memmap_insert need memory aligned
  on EFI_PAGE_SIZE. If memory not aligned, efi_memmap_insert
  just return and let efi.memmap in inconsistent state.
  This breaking boot.

  Tested in my machine, which stop booting
  after upgrade to 4.9

Signed-off-by: Petr Oros <poros-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 10aca63..7678857 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -214,7 +214,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 
 	new_size = efi.memmap.desc_size * num_entries;
 
-	new_phys = memblock_alloc(new_size, 0);
+	new_phys = memblock_alloc(new_size, EFI_PAGE_SIZE);
 	if (!new_phys) {
 		pr_err("Could not allocate boot services memmap\n");
 		return;
-- 
2.10.2
