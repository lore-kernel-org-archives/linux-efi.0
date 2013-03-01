From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Fri, 1 Mar 2013 23:53:03 +0100
Message-ID: <20130301225303.GK30938@pd.tnic>
References: <20130301213903.GI30938@pd.tnic>
 <51312C8F.8000503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51312C8F.8000503-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 01, 2013 at 02:32:47PM -0800, H. Peter Anvin wrote:
> On 03/01/2013 01:39 PM, Borislav Petkov wrote:
> > Hi guys,
> > 
> > so I was talking with mfleming on IRC and he said I should talk to you
> > about it. I actually pestered hpa about it already, sorry :).
> > 
> > So I've been looking into making EFI runtime services available
> > in the kexec'ed kernel. What I've found out so far is that
> > efi_enter_virtual_mode() in the first kernel iterates over the EFI
> > memmap and ioremaps all those EFI runtime services mappings. On my DELL
> > workstation it looks like the dump below.
> > 
> > Now, once this is done and SetVirtualAddressMap() is called, for the
> > duration of this boot, those virtual addresses cannot change as the UEFI
> > spec states: "A virtual address map may only be applied one time. Once
> > the runtime system is in virtual mode, calls to this function return
> > EFI_UNSUPPORTED."
> > 
> > Now, looking at those mappings, they're spread all over the VA space and
> > their size is ~159.887Mb (which is 159MB too many for a goddam BIOS crap
> > but whatever, everyone is jumping on this train so I'm gonna have to
> > follow, unwillingly.</EndOfRant>)
> > 
> > AFAICT, in a kexec kernel I'd have to recreate the exact-same mappings,
> > i.e. phys_addr -> va for all those regions. And since I'm not an mm guy,
> > I'd rather ask the experts before I dive into a catch-22 thing.
> > 
> > So even if I manage to do the mappings in the kexec kernel correctly for
> > all those regions which efi_ioremap() serves only with direct mappings
> > through init_memory_mapping(), I probably won't be that lucky with
> > regions of type EFI_MEMORY_MAPPED_IO (type 0xb below) for which we
> > really do ioremap and those virtual addresses I can't control, AFAICT.
> > 
> > So what do you guys think, would it be possible
> > 
> > * to make all EFI runtime services use predefined mappings which are
> > globally valid and I can read them out in kexec or
> > 
> > * make those mappings virtually contiguous so that kexec kernel only
> > gets a va_start and a size and after that it knows what to do or
> > 
> > * an even better idea.
> > 
> > In general, any suggestion is appreciated.
> > 
> 
> Adding a few more people.
> 
> This has been a big topic, and yes, we have a problem.
> 
> We seem to have a few options:
> 
> 1. We could always map 1:1, with the EFI mappings being in the "user"
> part of the virtual address space.  This MAY be what Windows does
> already.  Some Apple platforms are known to fail in this configuration,
> but perhaps we can blacklist those platforms or do something special.
> 
> 2. We could always map them into a fixed address that can be relied upon
> to be consistent.  The most logical such area is the second quadrant of
> the address space (again, in the "user" portion.)  It would be
> beneficial if we could define it so that whenever Linux needs to go to
> more than 48 virtual address bits at some point in the future this can
> be compatible between 48-bit and N-bit kernels, but if that is the only
> thing that breaks, then oh well.
> 
> 3. We could just always map at the kernel virtual address.  The 64-bit
> address space is large enough that we could make every ioremap() land at
> its identity-mapped address instead of in a unique part of the virtual
> address space.
> 
> 4. We could export a table of mappings to the kexec'd kernel.  In that
> case, we have to re-establish those mappings very early in the kernel
> boot so that nothing else steps on them.
> 
> What is quite interesting in your case is that you have a mishmash of
> the identity-mapped and the non-identity-mapped mappings.

Yeah, the mishmash comes from regions of type EFI_MEMORY_MAPPED_IO which
are really ioremapped instead of returning the kernel virtual address.

Btw, I always tend to like the simplest approaches so option 3.
is kinda winking at me right now. I don't know whether for those
EFI_MEMORY_MAPPED_IO type regions though, we can simply return the
identity-mapped address.

If we can, the advantage would be great because then the kexec kernel
would simply parse the efi memmap and use __va() on the physical
addresses there and no need for special option passing to it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
