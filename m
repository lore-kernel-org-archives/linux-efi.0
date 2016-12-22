From: Petr Oros <poros-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi Fix regression in efi_arch_mem_reserve
Date: Thu, 22 Dec 2016 11:21:47 +0100
Message-ID: <1482402107.3184.3.camel@redhat.com>
References: <20161221131138.10512-1-poros@redhat.com>
         <20161221223054.GG2225@codeblueprint.co.uk>
Reply-To: poros-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221223054.GG2225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming píše v Wed 21. 12. 2016 v 22:30 +0000:
> On Wed, 21 Dec, at 02:11:38PM, Petr Oros wrote:
> > 
> >   Booting on EFI with ESRT table has been stop since commit:
> >     8e80632 efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
> > 
> >   This is caused by this commit:
> >     816e761 efi: Allow drivers to reserve boot services forever
> > 
> >   Problem is, that efi_memmap_insert need memory aligned
> >   on EFI_PAGE_SIZE. If memory not aligned, efi_memmap_insert
> >   just return and let efi.memmap in inconsistent state.
> >   This breaking boot.
> > 
> >   Tested in my machine, which stop booting
> >   after upgrade to 4.9
> > 
> > Signed-off-by: Petr Oros <poros-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/quirks.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Could you provide some more information? Why does efi_memmap_insert()
> require this alignment? How does booting "break"? If you see an Oops,
> please post it here.

Ooops, sorry, please ignore this patch. I overlooked efi_memmap_insert
argument order. I bisected kernel and this patch breaking kernel boot
but from other reason. Provided patch fixed kernel booting issue by
mistake.

-Petr
