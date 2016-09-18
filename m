From: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot load linux after recent efi-related changes
Date: Sun, 18 Sep 2016 04:14:45 +0300
Message-ID: <20160918011443.GA4475@gmail.com>
References: <20160917162357.GA4122@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160917162357.GA4122-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 17, 2016 at 07:23:57PM +0300, Mike Krinkin wrote:
> Hello,
> 
> after commit 3dad6f7f6975 ("x86/efi: Defer efi_esrt_init until after
> memblock_x86_fill") kernel hits BUG_ON __efi_enter_virtual_mode because
> efi.systab is NULL. With older kernel versions i face the problem with
> efi_mem_reserve described in the commit.
> 
> AFAICS, get_systab_virt_addr called from efi_map_regions should set
> efi.systab, but i dumped memory desciptors in efi_map_regions and
> apparently none of them describes region that contains efi_phys.systab,
> so efi.systab remains unset.

I investigated it a bit further, and apparently problem occurs because
efi_esrt_init calls efi_mem_reserve with unaligned range boundaries, and
efi_memmap_insert doesn't handle unaligned ranges properly. The following
fix solves problem for me:

>From 23f7134a6dd3a3c47f875395933a68e1a83d0f0e Mon Sep 17 00:00:00 2001
From: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sun, 18 Sep 2016 03:53:52 +0300
Subject: [PATCH] efi: force page alignment in efi_mem_insert

efi_mem_insert might be called with unaligned range boundaries,
for example, for me it happens because esrt size is not page
aligned, that, in turn, results in wrong memory map and triggers
BUG_ON in __efi_enter_virtual_mode.

Force page alignment on memory range boundaries in efi_mem_insert.

Signed-off-by: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/memmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index cd96086..34322d1 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -221,8 +221,8 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 	void *old, *new;
 
 	/* modifying range */
-	m_start = mem->range.start;
-	m_end = mem->range.end;
+	m_start = mem->range.start & ~(u64)EFI_PAGE_SIZE;
+	m_end = ALIGN(mem->range.end, EFI_PAGE_SIZE) - 1;
 	m_attr = mem->attribute;
 
 	for (old = old_memmap->map, new = buf;
-- 
2.7.4
