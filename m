From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Fri, 6 Mar 2015 11:53:22 -0800
Message-ID: <CAE9FiQXbQ37A7+a+dk4LdPs7DCr68EfWwypR9X4dyPfixH8PZA@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<CAE9FiQWKNDgzJtDVV34e7vWTu7LtqdDKB4KiN1RZwcZrX70zSA@mail.gmail.com>
	<20150304200000.GB6276@gmail.com>
	<CAE9FiQXJ-ujbhpw8phk5iQM8QFw=9QxDrXK6AdyXqDxmch_bbw@mail.gmail.com>
	<20150306133312.GC4259@pd.tnic>
	<CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQVt8Bi==r7pPhSOcSTmmpkjZ4c7O6iphbzFkgbugzKbqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 6, 2015 at 11:50 AM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Mar 6, 2015 at 5:33 AM, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org> wrote:
>
>>
>> "However, the setup_data linked list and thus the element which contains
>> kaslr_enabled is chained together using physical addresses. At the
>> time when we access it in the kernel proper, we're already running
>> with paging enabled and therefore must access it through its virtual
>> address."
>>
>> That's it, now how hard was to explain it that way?
>
> No, I don't think your change log is right.
>
> Actually the old code is using address as value.
>
> if the old code would be like:
>
> kaslr_enabled = (bool)(*(unsigned char *)(pa_data + sizeof(struct setup_data)));
>
> then your change log would be good, but the old code is
>
> kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));

Please check if you are ok with this:

Subject: [PATCH v4] x86, kaslr: Access the correct kaslr_enabled variable

commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
started passing KASLR status to kernel proper, but it uses address as
the vaule.

That will get wrong value back for kaslr_enabled in kernel stage.
1. When kaslr is not enabled at boot/choose_kernel_location, if kaslr_enabled
get set wrongly in setup.c, late in module.c::get_module_load_offset
will return not wanted random module load offset.
That change behavior when HIBERNATION is defined or nokaslr is passed.

2. When kaslr is enabled at boot/choose_kernel_location, if kaslr_enabled
get cleared wrongly in setup.c, late in module.c::get_module_load_offset
will not return wanted random module load offset.

The setup_data linked list and thus the element which contains
kaslr_enabled is chained together using physical addresses. At the
time when we access it in the kernel proper, we're already running
with paging enabled and therefore must access it through its virtual
address.

This patch changes the code to use early_memmap and access the value,
and will keep boot and kernel consistent with kaslr.

-v3: add checking return from early_memmap according to Boris.
