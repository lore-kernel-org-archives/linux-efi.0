From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 RESEND] x86/boot/KASLR: Restrict kernel to be
 randomized in mirror regions
Date: Fri, 4 Aug 2017 19:40:05 +0800
Message-ID: <20170804114005.GC29975@x1>
References: <1500542189-15779-1-git-send-email-bhe@redhat.com>
 <20170721103757.hc74czr3mfunrv6c@gmail.com>
 <20170721131956.GK2344@x1>
 <20170724133410.GC11076@codeblueprint.co.uk>
 <20170728095525.y4tuv6aavzfs4ekb@gmail.com>
 <20170728112603.GS24304@x1>
 <20170804112325.GB8187@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170804112325.GB8187-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org, fanc.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 08/04/17 at 12:23pm, Matt Fleming wrote:
> On Fri, 28 Jul, at 07:26:03PM, Baoquan He wrote:
> > Hi Matt,
> > 
> > On 07/28/17 at 11:55am, Ingo Molnar wrote:
> > > 
> > > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > > 
> > > > On Fri, 21 Jul, at 09:19:56PM, Baoquan He wrote:
> > > > >
> > > > > There are places where the efi map is getting and used like this. E.g
> > > > > in efi_high_alloc() of drivers/firmware/efi/libstub/efi-stub-helper.c.
> > > > > EFI developers worry the size of efi_memory_desc_t could not be the same
> > > > > as e->efi_memdesc_size?
> > > > > 
> > > > > Hi Matt,
> > > > > 
> > > > > Could you help have a look at this?
> > > > 
> > > > You're exactly right. The code guards against the size of the
> > > > efi_memory_desc_t struct changing. The UEFI spec says to traverse the
> > > > memory map this way.
> > > 
> > > This is not obvious and looks pretty ugly as well, and open coded in several 
> > > places.
> > > 
> > > At minimum we should have an efi_memdesc_ptr(efi, i) wrapper inline (or so) that 
> > > gives us the entry pointer, plus a comment that points out that ->memdesc_size 
> > > might not be equal to sizeof(efi_memory_memdesc_t).
> > 
> > I can make a efi_memdesc_ptr(efi, i) wrapper as Ingo suggested and use
> > it here if you agree. Seems it might be not good to add another
> > for_each_efi_memory_desc_xxxx wrapper since there are different memmap
> > data structures in x86 boot and in general efi libstub. Or any other
> > idea?
> 
> I think adding a wrapper is fine, but I'd suggest including the word
> "early" (or something similar) to explain that it should only be used
> during bootup -- we want everyone else to use the
> for_each_efi_memory_*() API.

Thanks, Matt. I can do that. Do you think below helper definition is OK
to you? If yes, I can upstate with it and post v9.

#define efi_early_memdesc_ptr(map, desc_size, n)				\
	(efi_memory_desc_t *)((void *)(map) + ((n) * (desc_size)))
