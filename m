From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Sat, 2 Mar 2013 00:07:33 +0100
Message-ID: <20130301230733.GL30938@pd.tnic>
References: <20130301213903.GI30938@pd.tnic>
 <51312C8F.8000503@zytor.com>
 <20130301225303.GK30938@pd.tnic>
 <513132B0.3050308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <513132B0.3050308-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 01, 2013 at 02:58:56PM -0800, H. Peter Anvin wrote:
> >> We seem to have a few options:
> >>
> >> 1. We could always map 1:1, with the EFI mappings being in the "user"
> >> part of the virtual address space.  This MAY be what Windows does
> >> already.  Some Apple platforms are known to fail in this configuration,
> >> but perhaps we can blacklist those platforms or do something special.
> >>
> >> 2. We could always map them into a fixed address that can be relied upon
> >> to be consistent.  The most logical such area is the second quadrant of
> >> the address space (again, in the "user" portion.)  It would be
> >> beneficial if we could define it so that whenever Linux needs to go to
> >> more than 48 virtual address bits at some point in the future this can
> >> be compatible between 48-bit and N-bit kernels, but if that is the only
> >> thing that breaks, then oh well.
> >>
> >> 3. We could just always map at the kernel virtual address.  The 64-bit
> >> address space is large enough that we could make every ioremap() land at
> >> its identity-mapped address instead of in a unique part of the virtual
> >> address space.
> >>
> >> 4. We could export a table of mappings to the kexec'd kernel.  In that
> >> case, we have to re-establish those mappings very early in the kernel
> >> boot so that nothing else steps on them.
> >>
> >> What is quite interesting in your case is that you have a mishmash of
> >> the identity-mapped and the non-identity-mapped mappings.
> > 
> > Yeah, the mishmash comes from regions of type EFI_MEMORY_MAPPED_IO which
> > are really ioremapped instead of returning the kernel virtual address.
> > 
> > Btw, I always tend to like the simplest approaches so option 3.
> > is kinda winking at me right now. I don't know whether for those
> > EFI_MEMORY_MAPPED_IO type regions though, we can simply return the
> > identity-mapped address.
> > 
> > If we can, the advantage would be great because then the kexec kernel
> > would simply parse the efi memmap and use __va() on the physical
> > addresses there and no need for special option passing to it.
> > 
> 
> We can, and in fact we could do this for *all* ioremap()s in the 64-bit
> kernel.  This doesn't help the 32-bit kernel in any way, however.

Right, ok.

> One thing I *really* don't like about it is that it exposes the kernel
> virtual address map as an ABI.

Hmm, yeah, that's nasty. This also means option #2 can go too because
of the fixed addresses. Option #1 is also kinda polluting user address
space so maybe the most elegant one would be #4, AFAICT.

We just need a nice mechanism to tell those mappings to the kexec-d
kernel and when it starts, to establish them right away.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
