From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] x86/xen/efi: Initialize UEFI secure boot state during
 dom0 boot
Date: Tue, 23 Jan 2018 19:23:02 +0000
Message-ID: <CAKv+Gu8P6aRhGruBfXTauTDNgCF00SV2PmCDC+=ZNmoYoeVciA@mail.gmail.com>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
 <CAKv+Gu-_SHXCkfX5d3R08nW6rc4giR1d4VhDjF8J5miaTfSDow@mail.gmail.com> <20180112112450.GD21705@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112112450.GD21705-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 January 2018 at 11:24, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Ard,
>
> On Thu, Jan 11, 2018 at 12:51:07PM +0000, Ard Biesheuvel wrote:
>> On 9 January 2018 at 14:22, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> > Hi,
>> >
>> > Initialize UEFI secure boot state during dom0 boot. Otherwise the kernel
>> > may not even know that it runs on secure boot enabled platform.
>>
>> Hi Daniel,
>>
>> I must say, I am not too thrilled with the approach you have chosen
>> here. #including .c files in other .c files, and using #defines to
>> override C functions or other stub functionality is rather fragile. In
>
> TBH I do not like it too. Sadly I have not find a better solution for
> that. I wish to avoid code duplication as much as possible because
> otherwise it will fall out of sync sooner or later (usually sooner).
> Similar thing happened in different part of Xen EFI code a few months ago.
>
>> particular, it means we have to start caring about not breaking
>> Xen/x86 code when making modifications to the EFI stub, and that code
>> is already difficult enough to maintain, given that it is shared
>> between ARM, arm64 and x86, and runs either from the decompressor or
>> the kernel proper (arm64) but in the context of the UEFI firmware.
>
> I understand that.
>
>> None of the stub code currently runs in ordinary kernel context.
>
> Yep.
>
>> So please, could you try to find another way to do this?
>
> I am happy to improve the situation, however, I am afraid that it is
> difficult here. Stub and kernel proper are separate entities and simple
> linking does not work. So, It seems to me that only play with includes
> will allow us to not duplicate the code. However, if you have a better
> idea I am happy to implement it.
>

Actually, there is another reason why it does not make sense to reuse that code.

This code

/*
* See if a user has put the shim into insecure mode. If so, and if the
* variable doesn't have the runtime attribute set, we might as well
* honor that.
*/
size = sizeof(moksbstate);
status = get_efi_var(L"MokSBState", &shim_guid,
     &attr, &size, &moksbstate);

/* If it fails, we don't care why. Default to secure */
if (status != EFI_SUCCESS)
    goto secure_boot_enabled;
if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
    return efi_secureboot_mode_disabled;

will always fail after exiting boot services, so it makes no sense to
call it from xen_efi_init().

So I suggest you just clone the function and only keep the pieces that
make sense for Xen.

-- 
Ard.
