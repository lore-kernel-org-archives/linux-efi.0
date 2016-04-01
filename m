From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map mapping
Date: Fri,  1 Apr 2016 20:10:27 +0100
Message-ID: <1459537827-5005-1-git-send-email-matt@codeblueprint.co.uk>
References: <1459537395-4523-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459537395-4523-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Commit 4dffbfc48d65 ("arm64/efi: mark UEFI reserved regions as
MEMBLOCK_NOMAP") updated the mapping logic of both the RuntimeServices
regions as well as the kernel's copy of the UEFI memory map to set the
MEMBLOCK_NOMAP flag, which causes these regions to be omitted from the
kernel direct mapping, and from being covered by a struct page.
For the RuntimeServices regions, this is an obvious win, since the contents
of these regions have significance to the firmware executable code itself,
and are mapped in the EFI page tables using attributes that are described in
the UEFI memory map, and which may differ from the attributes we use for
mapping system RAM. It also prevents the contents from being modified
inadvertently, since the EFI page tables are only live during runtime
service invocations.

None of these concerns apply to the allocation that covers the UEFI memory
map, since it is entirely owned by the kernel. Setting the MEMBLOCK_NOMAP on
the region did allow us to use ioremap_cache() to map it both on arm64 and
on ARM, since the latter does not allow ioremap_cache() to be used on
regions that are covered by a struct page.

The ioremap_cache() on ARM restriction will be lifted in the v4.7 timeframe,
but in the mean time, it has been reported that commit 4dffbfc48d65 causes
a regression on 64k granule kernels. This is due to the fact that, given
the 64 KB page size, the region that we end up removing from the kernel
direct mapping is rounded up to 64 KB, and this 64 KB page frame may be
shared with the initrd when booting via GRUB (which does not align its
EFI_LOADER_DATA allocations to 64 KB like the stub does). This will crash
the kernel as soon as it tries to access the initrd.

Since the issue is specific to arm64, revert back to memblock_reserve()'ing
the UEFI memory map when running on arm64. This is a temporary fix for v4.5
and v4.6, and will be superseded in the v4.7 timeframe when we will be able
to move back to memblock_reserve() unconditionally.

Fixes: 4dffbfc48d65 ("arm64/efi: mark UEFI reserved regions as MEMBLOCK_NOMAP")
Reported-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.5
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/arm-init.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index aa1f743152a2..8714f8c271ba 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -203,7 +203,19 @@ void __init efi_init(void)
 
 	reserve_regions();
 	early_memunmap(memmap.map, params.mmap_size);
-	memblock_mark_nomap(params.mmap & PAGE_MASK,
-			    PAGE_ALIGN(params.mmap_size +
-				       (params.mmap & ~PAGE_MASK)));
+
+	if (IS_ENABLED(CONFIG_ARM)) {
+		/*
+		 * ARM currently does not allow ioremap_cache() to be called on
+		 * memory regions that are covered by struct page. So remove the
+		 * UEFI memory map from the linear mapping.
+		 */
+		memblock_mark_nomap(params.mmap & PAGE_MASK,
+				    PAGE_ALIGN(params.mmap_size +
+					       (params.mmap & ~PAGE_MASK)));
+	} else {
+		memblock_reserve(params.mmap & PAGE_MASK,
+				 PAGE_ALIGN(params.mmap_size +
+					    (params.mmap & ~PAGE_MASK)));
+	}
 }
-- 
2.7.3
