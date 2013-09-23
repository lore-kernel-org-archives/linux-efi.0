From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Mon, 23 Sep 2013 08:29:47 +0200
Message-ID: <20130923062947.GA2527@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130923054741.GC7007@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130923054741.GC7007-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 23, 2013 at 01:47:41PM +0800, Dave Young wrote:
> > +	unsigned long size = md->num_pages << PAGE_SHIFT;
> > +
> > +	efi_va -= size;
> > +	if (efi_va < EFI_VA_END) {
> > +		pr_warning(FW_WARN "VA address range overflow!\n");
> > +		return;
> > +	}
> > +
> > +	/* Do the 1:1 map */
> > +	__map_region(md, md->phys_addr);
> > +
> > +	/* Do the VA map */
> > +	__map_region(md, efi_va);
> 
> 
> Could you add comment for above code? It's hard to understand the
> twice mapping if one did not follow the old thread.

Does that suffice:

/*
 * Make sure the 1:1 mappings are present as a catch-all for b0rked firmware
 * which doesn't update all internal pointers after switching to virtual mode
 * and would otherwise crap on us.
 */

?

Btw, when you reply to a mail, please remove that quoted portion of it
which you're not replying to - I had to scroll a bunch of screens down
and I almost missed your reply. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
