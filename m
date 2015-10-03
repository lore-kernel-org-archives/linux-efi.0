From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: linux-next: Tree for Sep 18 (build failures, up to 10/02)
Date: Sat, 3 Oct 2015 23:26:07 +0100
Message-ID: <20151003222607.GA2682@codeblueprint.co.uk>
References: <20150918140810.6345bce9@canb.auug.org.au>
 <20150918142204.GA17018@roeck-us.net>
 <20151002161637.GA17786@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151002161637.GA17786-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Oct, at 09:16:37AM, Guenter Roeck wrote:
> On Fri, Sep 18, 2015 at 07:22:04AM -0700, Guenter Roeck wrote:
> > On Fri, Sep 18, 2015 at 02:08:10PM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20150917:
> > > 
> > > I used the h8300 tree from next-20150828 since the current tree has been
> > > rebased onto something very old :-(
> > > 
> > > The bluetooth tree still had its build failure.
> > > 
> > > The tip tree gained a conflict against Linus' tree.
> > > 
> > > The akpm-current tree lost its build failure.
> > > 
> > > Non-merge commits (relative to Linus' tree): 1938
> > >  1581 files changed, 83940 insertions(+), 23948 deletions(-)
> > > 
> > 
> > Build failures:
> > 
> > ia64:defconfig
> > ia64:allnoconfig
> > 
> > drivers/built-in.o: In function `efi_mem_attributes':
> > (.text+0xde962): undefined reference to `memmap'
> > drivers/built-in.o: In function `efi_mem_attributes':
> > (.text+0xde971): undefined reference to `memmap'
> > 
> > Bisect points to 'efi, x86: Rearrange efi_mem_attributes()'.
> > On a side note, 'memmap' is really a bad name for a global variable,
> > As the patch description suggests, the variable does not exist for ia64,
> > so the build failure is not entirely unexpected.
> > 
> The build for ia64 still fails in next-20151002. Maybe it is time 
> to revert the offending commit ? After all, the commit was supposed
> to _fix_ a problem associated with ia64, not to make it completely
> non-buildable.

Urgh, sorry about this slipping through the cracks Guenter!

What about fixing it up with this patch?

---

>From 85ae872eafef767cf37a0a305266522a62b43fc2 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Sat, 3 Oct 2015 20:44:52 +0100
Subject: [PATCH] efi: Use the generic efi.memmap instead of 'memmap'

Guenter reports that commit 7bf793115dd9 ("efi, x86: Rearrange
efi_mem_attributes()") breaks ia64 compilation with the following
error,

 drivers/built-in.o: In function `efi_mem_attributes':
  (.text+0xde962): undefined reference to `memmap'
 drivers/built-in.o: In function `efi_mem_attributes':
  (.text+0xde971): undefined reference to `memmap'

Instead of using the (rather poorly named) global variable 'memmap'
which doesn't exist on ia64, use efi.memmap which points to the
'memmap' object on x86 and arm64 and which is NULL for ia64.

The fact that efi.memmap is NULL for ia64 is OK because ia64 provides
its own implementation of efi_mem_attributes().

Reported-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Jonathan Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index dd153be03f56..335f4c1a1504 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -647,13 +647,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
  */
 u64 __weak efi_mem_attributes(unsigned long phys_addr)
 {
+	struct efi_memory_map *map;
 	efi_memory_desc_t *md;
 	void *p;
 
 	if (!efi_enabled(EFI_MEMMAP))
 		return 0;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	map = efi.memmap;
+	for (p = map->map; p < map->map_end; p += map->desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
-- 
2.1.0

-- 
Matt Fleming, Intel Open Source Technology Center
