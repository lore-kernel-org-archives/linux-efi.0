From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/10] arm64 EFI patches for 3.19
Date: Wed, 5 Nov 2014 08:53:39 +0100
Message-ID: <CAKv+Gu-05Tf+BFxSGfibgs00WAA+wZTSrgzpTK46QZD8SV62jw@mail.gmail.com>
References: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414513123-20400-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Li <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 October 2014 17:18, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Version v2 of arm64/efi patches for 3.19.
> Changes since previous version:
> - dropped patch #6 'arm64/efi: use UEFI memory map unconditionally if available'
>   (will be revisited later, but due to other changes in the pipeline regarding
>   the virtual mapping of UEFI Runtime Services, it makes sense to defer this
>   to 3.20)
> - added patch #10 'efi: efi-stub: notify on DTB absence'
>
> Note that Matt Fleming has given his approval for taking all of these through
> the arm64 tree.
>
> @Matt: may we have your ack on patches #6, #7 and #10 please? Patch #7 covers
> DMI not EFI but get_maintainer.pl is not very helpful here. (The patch is cc'ed
> to akpm and Tony Luck [ia64 maintainer])
>
> Patches #1 - #3 are fixes for compliance with the UEFI and PE/COFF specs.
> No issues are known that require these patches, so there is no reason to
> pull them into a stable release.
>
> Patch #4 fixes is_reserve_region() to correctly identify UEFI memory regions
> that need to be reserved by the OS. This patch supersedes the patch sent as
> part of the v1 series: 'arm64/efi: reserve regions of type ACPI_MEMORY_NVS'
>
> Patch #5 removes a redundant set_bit(EFI_CONFIG_TABLES) call.
>
> Patches #6 - #9 implement DMI/SMBIOS for arm64, both the existing 32-bit
> version and the upcoming 3.0 version that allows the SMBIOS structure table
> to reside at a physical offset that cannot be encoded in 32-bits. It also
> installs a 'Hardware name: xxx' string that is printed along with oopses
> and kernel call stack dumps on systems that implement DMI/SMBIOS.
>
> Patch #10 is a patch from Mark Rutland I picked up that improves the
> diagnostic output of the EFI stub regarding the origin of the device
> tree blob.
>
> Please refer to the patches themselves for version history. Acks and/or
> comments appreciated.
>

OK, it appears we're good to go with this series.

@Will: would you like me to repost one final time? Or would you prefer
a pull request instead? The only changes are added acks and a single
code change where an open-coded constant 127 is replaced with its
symbolic name DMI_ENTRY_END_OF_TABLE.

Regards,
Ard.
