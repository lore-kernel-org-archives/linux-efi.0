From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock
 after mm_init()
Date: Thu, 5 Jan 2017 17:15:11 +0800
Message-ID: <20170105091511.GB11021@dhcp-128-65.nay.redhat.com>
References: <20161222102340.2689-1-nicstange@gmail.com>
 <20161223145206.GC16838@codeblueprint.co.uk>
 <878tr6jqoa.fsf@gmail.com>
 <20170105074221.GA1777@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170105074221.GA1777-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/05/17 at 08:42am, Ingo Molnar wrote:
> 
> * Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> writes:
> > 
> > > On Thu, 22 Dec, at 11:23:39AM, Nicolai Stange wrote:
> > >> So, after memblock is gone, allocations should be done through the "normal"
> > >> page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
> > >> it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.
> > >> 
> > >> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
> > >> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > > Could you also modify efi_fake_memmap() to use your new
> > > efi_memmap_alloc() function for consistency
> > 
> > Sure.
> > 
> > I'm planning to submit another set of patches addressing the (bounded)
> > memmap leaking in anything calling efi_memmap_unmap() though. In the
> > course of doing so, the memmap allocation sites will get touched anyway:
> > I'll have to store some information about how the memmap's memory has
> > been obtained.
> 
> Will that patch be intrusive?
> 
> If yes then we'll need to keep this a separate urgent patch to fix the v4.9 
> regression that Dan Williams reported. I can apply the fix to efi/urgent and get 
> it to Linus straight away if you guys agree.

Ditto question to Matt as I asked in reply to patch 2/2, can we move the
efi_mem_reserve to early code so that memblock is still usable and
consider to improve it in other way later?

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
