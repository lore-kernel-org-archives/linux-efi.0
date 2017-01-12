From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Fri, 13 Jan 2017 05:33:54 +0800
Message-ID: <20170112213354.GC2709@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
 <CAKv+Gu-U3JxbhYPpmm9synQXeqe11gFwntGVBTHsmmiPenQNmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-U3JxbhYPpmm9synQXeqe11gFwntGVBTHsmmiPenQNmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/12/17 at 04:20pm, Ard Biesheuvel wrote:
> On 12 January 2017 at 09:41, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Before invoking the arch specific handler, efi_mem_reserve() reserves
> > the given memory region through memblock.
> >
> > efi_bgrt_init will call efi_mem_reserve after mm_init(), at that time
> > memblock is dead and it should not be used any more.
> >
> > efi bgrt code depend on acpi intialization to get the bgrt acpi table,
> > moving bgrt parsing to acpi early boot code can make sure efi_mem_reserve
> > in efi bgrt code still use memblock safely.
> >
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> I know this is probably out of scope for you, but since we're moving
> things around, any chance we could do so in a manner that will enable
> BGRT support for arm64/ACPI? Happy to test/collaborate on this.
> 

I'm happy to do so, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> said he had
some investigation on that already, I would like to ask him to help on that.

Already cced him..

Thanks
Dave
