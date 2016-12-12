From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] efi: efi_memmap_insert(): don't split regions with invalid sizes.
Date: Mon, 12 Dec 2016 18:42:31 -0500
Message-ID: <20161212234231.27256-4-pjones@redhat.com>
References: <20161212234030.3mu4bv5bjm5ysz2d@redhat.com>
 <20161212234231.27256-1-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161212234231.27256-1-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
(2.28), include memory map entries with phys_addr=0x0 and num_pages=0.

If we're inserting a new memmap and we find a map that is either 0
pages or all of possible memory (or more!), skip it.  When a map exists
at 0 that's 0 pages, the "end" math here winds up making *every* address
within the range, and so it'll try to split that entry, and things go
poorly after that.  The same would be true if num_pages were U64_MAX or
(U64_MAX >> EFI_PAGE_SHIFT) (i.e. all bits set as a size in bytes, but
then shifted to page size to fill the table in).

Don't even try to split those entries, they're nonsense.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/memmap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index d3ba722..4503971 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -244,6 +244,15 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 		/* copy original EFI memory descriptor */
 		memcpy(new, old, old_memmap->desc_size);
 		md = new;
+		if (md->num_pages == 0 ||
+		    md->num_pages > EFI_PAGES_MAX ||
+		    EFI_PAGES_MAX - md->num_pages <
+		    (md->phys_addr >> EFI_PAGE_SHIFT)) {
+			pr_warn("%s: Skipping absurd memory map entry for 0x%llx pages at 0x%016llx.\n",
+				__func__, md->num_pages, md->phys_addr);
+			continue;
+		}
+
 		start = md->phys_addr;
 		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
 
-- 
2.9.3
