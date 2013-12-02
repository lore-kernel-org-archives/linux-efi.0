From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Mon, 2 Dec 2013 15:09:26 -0800
Message-ID: <CAFECyb8nE8e_aqZe5VYJ6+2FzJVQEdCsuqR-fNyRSDapt3NVdg@mail.gmail.com>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
	<1385595115-21488-3-git-send-email-roy.franz@linaro.org>
	<20131129113008.GB11775@console-pimps.org>
	<1385996185.1861.28.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385996185.1861.28.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 2, 2013 at 6:56 AM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2013-11-29 at 11:30 +0000, Matt Fleming wrote:
>> >       /*
>> >        * Add an additional efi_memory_desc_t because we're doing an
>> >        * allocation which may be in a new descriptor region.
>> > +      * We allocate as EFI_RUNTIME_SERVICES_DATA since this is what
>> > +      * we want for when we pass the memory map to the kernel.  This
>> > +      * function is also used to get the memory map for other uses,
>> > +      * but is always freed by the stub so the allocation type
>> > +      * doesn't matter.
>> >        */
>> >       *map_size += sizeof(*m);
>> >       status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>> > -                             EFI_LOADER_DATA, *map_size, (void **)&m);
>> > +                             EFI_RUNTIME_SERVICES_DATA, *map_size,
>> > +                             (void **)&m);
>> >       if (status != EFI_SUCCESS)
>> >               goto fail;
>>
>>
>> OK, this needs a stronger justification. Presumably the reason for this
>> change is that you want the allocation to hang around once the kernel is
>> running? We have this problem on x86 and it's solved by reserving the
>> memory early in the kernel, e.g. memblock_reserve().
>> EFI_RUNTIME_SERVICES_DATA is for firmware use, not for kernel data.
>>
>
> Yeah, arm64 reserves it and is okay with it being EFI_LOADER_DATA.
>
> --Mark

I have discussed this with Leif and will change this back to
EFI_LOADER_DATA, and Leif will update
his runtime services patch to reserve this as done in your arm64 implementation.

Thanks,
Roy
