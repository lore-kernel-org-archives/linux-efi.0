From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI stub
Date: Mon, 12 Jan 2015 16:09:24 +0000
Message-ID: <CAKv+Gu9BQFEEpEpF3-O98W-kBYQC9yKf39ee2gvznuZYPiCo-g@mail.gmail.com>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
	<1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
	<20150112114600.GE26589@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150112114600.GE26589-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 January 2015 at 11:46, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 08 Jan, at 06:48:32PM, Ard Biesheuvel wrote:
>> @@ -46,4 +54,26 @@ extern void efi_idmap_init(void);
>>
>>  #define EFI_ALLOC_ALIGN              SZ_64K
>>
>> +/*
>> + * On ARM systems, virtually remapped UEFI runtime services are set up in three
>> + * distinct stages:
>> + * - The stub retrieves the final version of the memory map from UEFI, populates
>> + *   the virt_addr fields and calls the SetVirtualAddressMap() [SVAM] runtime
>> + *   service to communicate the new mapping to the firmware (Note that the new
>> + *   mapping is not live at this time)
>> + * - During early boot, the page tables are allocated and populated based on the
>> + *   virt_addr fields in the memory map, but only if all descriptors with the
>> + *   EFI_MEMORY_RUNTIME attribute have a non-zero value for virt_addr. If this
>> + *   succeeds, the EFI_VIRTMAP flag is set to indicate that the virtual mappings
>> + *   have been installed successfully.
>> + * - During an early initcall(), the UEFI Runtime Services are enabled and the
>> + *   EFI_RUNTIME_SERVICES bit set if some conditions are met, i.e., we need a
>> + *   non-early mapping of the UEFI system table, and we need to have the virtmap
>> + *   installed.
>> + */
>> +#define EFI_VIRTMAP          EFI_ARCH_1
>
> Lucid. Thanks, Ard!
>

Cheers Matt

It appears this series is converging in time for 3.20, but this patch
still lacks acked/reviewed-bys

Are you ok with the remainder of the patch as well? In that case, may
I have your ack so the series can be merged through the arm64 tree?

-- 
Ard.
