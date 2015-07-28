From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] [v2] x86_64/efi: Use all 64 bit of efi_memmap in
 setup_e820()
Date: Tue, 28 Jul 2015 21:42:31 +0100
Message-ID: <20150728204231.GC2773@codeblueprint.co.uk>
References: <1437579068-14982-1-git-send-email-sdmitry@parallels.com>
 <20150728112413.GA645@codeblueprint.co.uk>
 <BY1PR0301MB1255463A9A89D6247A81D242A18D0@BY1PR0301MB1255.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BY1PR0301MB1255463A9A89D6247A81D242A18D0-M1kb196zaopYAF46dOS0O5wN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Denis Lunev <den-wo1vFcy6AUs@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Jul, at 01:18:37PM, Dmitry Skorodumov wrote:
> Matt Fleming <matt@...> writes:
> 
> > On Wed, 22 Jul, at 07:31:08PM, Dmitry Skorodumov wrote:
> > > The efi_info structure stores low 32 bits of memory map
> > > in efi_memmap and high 32 bits in efi_memmap_hi.
> > > 
> > > While constructing pointer in the setup_e820(), need
> > > to take into account all 64 bits of the pointer.
> 
> > > tested in Parallels virtual machine with more then 3GB of memory
> 
> > When you say "tested", you mean that it doesn't boot correctly without
> > your patch but does boot correctly with it applied? What I'm really
> > asking is: are we sure that your setup triggered this new code?
> 
> Yes, while debugging I added a lot of logging to trace the problem.
> Parallels VM doesn't boot correctly without the patch.
 
OK cool, I would definitely include this in the patch commit message.

> I believe that any  EDK2-based efi-bios will not work also,
> though I heard that OVMF uses own linux boot loader..
> It is because the memory for memmap was allocated from EFI_LOADER_DATA pool -
> efi_call_early(allocate_pool, EFI_LOADER_DATA, map_size... );
> 
> It is possible to kludge the problem by patching EFI-bios of the machine
> to allocate  EFI_LOADER_DATA-memory below the 4GB space,
> but I think that fixing setup_e820() is the right thing.
 
Yes your fix looks correct to me, I just wanted to know whether you hit
the bug with a real workload or via code inspection.

> > > +	m = efi->efi_memmap;
> > > +#ifdef CONFIG_X86_64
> > > +	m |= (u64)efi->efi_memmap_hi << 32;
> > > +#endif
> ..
> > >  	for (i = 0; i < nr_desc; i++) {
> > > -		unsigned long m = efi->efi_memmap;
> > >  		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
> 
> > Is there a reason that adding efi->efi_memmap_hi can't be done inside
> > this for loop? Gcc should be smart enough to hoist this calculation out
> > of the loop.
> 
> Smart from its side.. I'll correct this and resend the patch.

Great, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
