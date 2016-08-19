From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] EFI: make for_each_efi_memory_desc_in_map() cope with
 running on Xen
Date: Fri, 19 Aug 2016 11:47:15 +0100
Message-ID: <20160819104715.GR30909@codeblueprint.co.uk>
References: <57B1F6690200007800106095@prv-mh.provo.novell.com>
 <20160816114917.GM30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160816114917.GM30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 16 Aug, at 12:49:17PM, Matt Fleming wrote:
> On Mon, 15 Aug, at 09:05:45AM, Jan Beulich wrote:
> > While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
> > for empty memmaps") made an attempt to deal with empty memory maps, it
> > didn't address the case where the desc_size field never gets set, as is
> > apparently the case when running under Xen.
> > 
> > Reported-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
> > Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> > Tested-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
> > ---
> > v2: Add comment.
> > ---
> >  include/linux/efi.h |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > --- 4.8-rc2/include/linux/efi.h
> > +++ 4.8-rc2-EFI-memdesc-iterator-Xen/include/linux/efi.h
> > @@ -946,7 +946,11 @@ extern int efi_memattr_apply_permissions
> >  /* Iterate through an efi_memory_map */
> >  #define for_each_efi_memory_desc_in_map(m, md)				   \
> >  	for ((md) = (m)->map;						   \
> > -	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
> > +	     /*								   \
> > +	      * Leverage wrapping of the calculation to avoid an infinite  \
> > +	      * loop when all three values are zero.			   \
> > +	      */							   \
> > +	     ((void *)(md) + (m)->desc_size - 1) < (m)->map_end;	   \
> >  	     (md) = (void *)(md) + (m)->desc_size)
> >  
> 
> Thanks Jan, applied to the 'urgent' EFI queue and tagged for stable.
> I'll send it out this week.

Jiri caught me on IRC and repeated his concern that this patch relies
on undefined behaviour per the C language standard.

I really don't want to get into a discussion of compiler
implementations, so instead can we check whether the 'md' is NULL and
skip the loop if so? e.g. would something like this work?

---

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7f5a58225385..23cd3ced8c1a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -946,7 +946,7 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
+	     (md) && ((void *)(md) + (m)->desc_size) <= (m)->map_end;	   \
 	     (md) = (void *)(md) + (m)->desc_size)
 
 /**
