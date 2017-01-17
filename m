From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 4/4] efi/x86: make efi_memmap_reserve only insert into boot mem areas
Date: Tue, 17 Jan 2017 20:48:36 +0100
Message-ID: <871sw131t7.fsf@gmail.com>
References: <20170116024554.461236678@redhat.com>
        <20170116025026.586405871@redhat.com>
        <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Ard Biesheuvel's message of "Tue, 17 Jan 2017 17:13:00 +0000")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86@kernel.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa@zytor.com" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 17 2017, Ard Biesheuvel wrote:

> On 16 January 2017 at 02:45, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> efi_mem_reserve cares only about boot services regions, for making sure
>> later efi_free_boot_services does not free areas which are still useful,
>> such as bgrt image buffer.
>>
>> So add a new argument to efi_memmap_insert for this purpose.
>>
>
> So what happens is we try to efi_mem_reserve() a regions that is not
> bootservices code or data?
> We shouldn't simply ignore it, because it is a serious condition.

The efi_mem_desc_lookup() call in efi_arch_mem_reserve() wouldn't return
anything and the latter would

  pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);

then.

This is so because efi_mem_desc_lookup() searches only for regions that
either
- are of type EFI_BOOT_SERVICES_DATA or EFI_RUNTIME_SERVICES_DATA
- or which have EFI_MEMORY_RUNTIME set already:

	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
	    md->type != EFI_BOOT_SERVICES_DATA &&
	    md->type != EFI_RUNTIME_SERVICES_DATA) {
		continue;
	}

For EFI_RUNTIME_SERVICES_DATA and EFI_MEMORY_RUNTIME,
efi_arch_mem_reserve() would be a nop.

So we're fine here? Do you want to have a more descriptive error message
than "Failed to lookup EFI memory descriptor"?


For the other checks you suggested in that other thread, i.e. for the
post-slab_is_available() condition and so: let me wait until Dave's
series has stabilized (or even picked) and I'll submit patches for
what remains to be sanity checked then.

Also, since Dave eliminated the need for late efi_mem_reserve()'s,
my 20b1e22d01a4 ("x86/efi: Don't allocate memmap through memblock after
mm_init()") should certainly get reverted at some point.


Thanks,

Nicolai
