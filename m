From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] arm64: efi: apply strict permissons for UEFI
 Runtime Services regions
Date: Wed, 18 May 2016 15:08:32 +0200
Message-ID: <CAKv+Gu9G60h66jaAOe754w7tKEdgF9NUDbkXgqNEEqKkG=LDzQ@mail.gmail.com>
References: <1459355933-13529-1-git-send-email-ard.biesheuvel@linaro.org>
	<1459355933-13529-3-git-send-email-ard.biesheuvel@linaro.org>
	<573BB9FE.7050008@codeaurora.org>
	<CAKv+Gu-Tam+QiXc_f0e+x8hNc4rxP_-59NdaCHkF9h=4Rd+XeA@mail.gmail.com>
	<573C68DA.8080009@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <573C68DA.8080009-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 May 2016 at 15:06, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> Hi Ard,
>
> We are not using the permission attribute table and all the Runtime
> Data/Code regions are marked with 'XP' bit. Do you think something
> wrong in our UEFI implementation or Linux has to map RuntimeCode
> regions with executable permission always irrespective of an attribute
> flag EFI_MEMORY_XP?
>
> [    0.000000] efi: Processing EFI memory map:
> [    0.000000] efi:   0x000000100000-0x00000010ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x00003b830000-0x00003b83ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x00003c000000-0x00003fffffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x000000100000-0x00000010ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x00003b830000-0x00003b83ffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x00003c000000-0x00003fffffff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x004000820000-0x00400085ffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x004003080000-0x00400308ffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047f9960000-0x0047f997ffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fa9c0000-0x0047fa9cffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047faa30000-0x0047faa3ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fab90000-0x0047fab9ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047faba0000-0x0047fabaffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fab90000-0x0047fab9ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047faba0000-0x0047fabaffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fabb0000-0x0047fabbffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fabc0000-0x0047fad9ffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fada0000-0x0047fae2ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047faf50000-0x0047faf7ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fafa0000-0x0047fafbffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047faf50000-0x0047faf7ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fafa0000-0x0047fafbffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fff90000-0x0047fff9ffff [Runtime Code       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0047fffb0000-0x0047fffdffff [Runtime Data       |RUN|  |  |XP|  |  |  |   |WB|WT|WC|UC]*
>

This memory map looks utterly broken. Assuming you are using
Tianocore, does it work when setting
gEfiMdeModulePkgTokenSpaceGuid.PcdPropertiesTableEnable to FALSE in
your platform?
