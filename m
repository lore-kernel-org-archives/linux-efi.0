From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Date: Tue, 14 Oct 2014 22:46:33 +0100
Message-ID: <20141014214633.GD14343@console-pimps.org>
References: <1412692951-25478-1-git-send-email-matt@console-pimps.org>
 <1412692951-25478-2-git-send-email-matt@console-pimps.org>
 <20141010182846.GA10588@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141010182846.GA10588-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Oct, at 08:28:47PM, Borislav Petkov wrote:
> 
> You have efi_capsule_update() vs efi_update_capsule(). Maybe change the
> names a bit more for differentiation. Or prepend the workhorse doing all
> the work with "__" or so...
 
Yeah, I really didn't come up with a great naming scheme here. I'll fix
that.

> > +
> > +	for (i = 0; i < nr_block_pgs; i++) {
> > +		block_pgs[i] = alloc_page(GFP_KERNEL);
> 
> Maybe alloc_pages() once we verify that it actually gives phys. contig.
> memory and maybe also try to do it outside of the locked region. I don't
> know if it would matter to drop the locks though as capsule updating is
> not something you do pretty often. I'd hope!

Actually, I'm not bothered about getting physically contiguous memory
because we pass a scatter gather list to the firmware anyway. What I was
looking for was to avoid doing high order allocations when we don't
really need them (lots of low order allocs are fine).

Right, allocating under the lock isn't a great idea. I'll take a look at
reworking this to do the allocation up front.

-- 
Matt Fleming, Intel Open Source Technology Center
