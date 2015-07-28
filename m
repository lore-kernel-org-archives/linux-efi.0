From: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] [v2] =?utf-8?b?eDg2XzY0L2VmaTo=?= Use all 64 bit of =?utf-8?b?ZWZpX21lbW1hcA==?= in =?utf-8?b?c2V0dXBfZTgyMCgp?=
Date: Tue, 28 Jul 2015 14:16:09 +0000 (UTC)
Message-ID: <loom.20150728T145739-236@post.gmane.org>
References: <1437579068-14982-1-git-send-email-sdmitry@parallels.com> <20150728112413.GA645@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> On Wed, 22 Jul, at 07:31:08PM, Dmitry Skorodumov wrote:
> > The efi_info structure stores low 32 bits of memory map
> > in efi_memmap and high 32 bits in efi_memmap_hi.
> > 
> > While constructing pointer in the setup_e820(), need
> > to take into account all 64 bits of the pointer.

> > tested in Parallels virtual machine with more then 3GB of memory

> When you say "tested", you mean that it doesn't boot correctly without
> your patch but does boot correctly with it applied? What I'm really
> asking is: are we sure that your setup triggered this new code?

Yes, while debugging I added a lot of logging to trace the problem.
Parallels VM doesn't boot correctly without the patch.

I believe that any  EDK2-based efi-bios will not work also,
though I heard that OVMF uses own linux boot loader..
It is because the memory for memmap was allocated from EFI_LOADER_DATA pool -
efi_call_early(allocate_pool, EFI_LOADER_DATA, map_size... );

It is possible to kludge the problem by patching EFI-bios of the machine
to allocate  EFI_LOADER_DATA-memory below the 4GB space,
but I think that fixing setup_e820() is the right thing.

> > +   m = efi->efi_memmap;
> > +#ifdef CONFIG_X86_64
> > +   m |= (u64)efi->efi_memmap_hi << 32;
> > +#endif
..
> >      for (i = 0; i < nr_desc; i++) {
> > -           unsigned long m = efi->efi_memmap;
> >              d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));

> Is there a reason that adding efi->efi_memmap_hi can't be done inside
> this for loop? Gcc should be smart enough to hoist this calculation out
> of the loop.

Smart from its side.. I'll correct this and resend the patch.

PS: Looks my mailer have not sent the message to the list.
Resending via gmane-web, sorry for potential duplicate
