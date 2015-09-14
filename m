From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] x86, efi: Add "efi_fake_mem_mirror" boot option
Date: Mon, 14 Sep 2015 09:20:27 +0200
Message-ID: <CAKv+Gu8RhUbKS2sKR_e-c1mhQdgO2rBCOpzgNTPO+HRxenuJmw@mail.gmail.com>
References: <1440609031-14695-1-git-send-email-izumi.taku@jp.fujitsu.com>
	<1440609097-14836-1-git-send-email-izumi.taku@jp.fujitsu.com>
	<CAKv+Gu88nxLQk5R2SGo0pnDA0VyTBvZT6oxLV-Uwc3=3wqjSaA@mail.gmail.com>
	<20150912104157.GB2796@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150912104157.GB2796-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 September 2015 at 12:41, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 09 Sep, at 04:16:09PM, Ard Biesheuvel wrote:
>>
>> Hello Taku,
>>
>> To be honest, I think that the naming of this feature is poorly
>> chosen. The UEFI spec gets it right by using 'MORE_RELIABLE'. Since
>> one way to implement more reliable memory ranges is mirroring, the
>> implementation detail of that has leaked into the generic naming,
>> which is confusing. Not your fault though, just something I wanted to
>> highlight.
>
> Care to suggest an alternative option? efi_fake_mem_more_reliable ?
>

No, that does not make sense either. I don't like the name that was
chosen when the feature was added to memblock, and now I suppose we
just have to live with it.

> Maybe we should go further than this current design and generalise
> things to allow an EFI_MEMORY_ATTRIBUTE value to be specified for
> these memory ranges that supplements the ones actually provided by the
> firmware?
>
> Something like,
>
>   efi_fake_mem=2G@4G:0x10000,2G@0x10a0000000:0x10000
>
> Where 0x10000 is the EFI_MEMORY_MORE_RELIABLE attribute bit.
>

Yes, I like that. Should we use a mask/xor pair for flexibility?

> That would seem incredibly useful for testing the kernel side of the
> EFI_PROPERTIES_TABLE changes, i.e. you wouldn't need support in the
> firmware and could just "mock-up" an EFI memory map with EFI_MEMORY_XP
> for the data regions (code regions and EFI_MEMORY_RO are a little
> trickier as I understand it, because they may also contain data).
>

... hence the need for the memprotect feature in the first place.
PE/COFF images are normally covered in their entirety (.text + .data)
by a single BScode/RTcode region.

But indeed, the ability to manipulate the memory map like that could
be useful, although it would need to be ported to the stub to be
useful on ARM, I think.

>> So first of all, could you please update the example so that it only
>> shows a single more reliable region (or two but of different sizes)?
>> It took me a while to figure out that those 2 GB regions are not
>> mirrors of each other in any way, they are simply two separate regions
>> that are marked as more reliable than the remaining memory.
>>
>> I do wonder if this functionality belongs in the kernel, though. I see
>> how it could be useful, and you can keep it as a local hack, but
>> generally, the firmware (OVMF?) is a better way to play around with
>> code like this, I think?
>
> I (partially) disagree. Using real life memory maps has its
> advantages, since different layouts exercise the code in different
> ways, and I'd really like to see this used on beefy machines with
> multiple GB/TB or RAM. It also allows performance measurements to be
> taken with bare metal accuracy. Plus there's precedent in the kernel
> for creating fake memory/topology objects, e.g. see numa=fake.
>

OK, perhaps I just don't understand the use case too well.

> Not everyone who touches the EFI memory mirror code is going to want
> (or be able) to run firmware with EFI_MEMORY_MORE_RELIABLE support.
>
> Having said that, I'd love to also see EFI_MEMORY_MORE_RELIABLE
> support in OVMF! I think both options make sense for different
> reasons.
>

Good point.
