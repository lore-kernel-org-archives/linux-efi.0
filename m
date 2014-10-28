From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/10] arm64/efi: reserve regions of type ACPI_MEMORY_NVS
Date: Tue, 28 Oct 2014 11:17:24 +0100
Message-ID: <CAKv+Gu_u5V9vCUNCP71JeZyuvX5aPk6wcLx5u1TZ+icZoczATA@mail.gmail.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	<1413987713-30528-5-git-send-email-ard.biesheuvel@linaro.org>
	<20141022161552.GG4010@leverpostej>
	<CAKv+Gu9pUY766Wf8cVfNtmjS8mXAB9PZswrRdgsKmz8+AOXrww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9pUY766Wf8cVfNtmjS8mXAB9PZswrRdgsKmz8+AOXrww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 October 2014 18:33, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 22 October 2014 18:15, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> On Wed, Oct 22, 2014 at 03:21:47PM +0100, Ard Biesheuvel wrote:
>>> Memory regions of type ACPI_MEMORY_NVS should be preserved
>>> by the OS, so make sure we reserve them at boot.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>  arch/arm64/kernel/efi.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>>> index 95c49ebc660d..71ea4fc0aa8a 100644
>>> --- a/arch/arm64/kernel/efi.c
>>> +++ b/arch/arm64/kernel/efi.c
>>> @@ -132,6 +132,7 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
>>>               return 1;
>>>
>>>       if (md->type == EFI_ACPI_RECLAIM_MEMORY ||
>>> +         md->type == EFI_ACPI_MEMORY_NVS ||
>>>           md->type == EFI_RESERVED_TYPE)
>>>               return 1;
>>
>> Shouldn't we also filter out EFI_UNUSABLE_MEMORY? Or does that happen
>> elsewhere?
>>
>
> Yes, good point.
>
>> Perhaps instead we should invert this logic and assume memory should be
>> reserved if not EfiLoaderCode, EfiLoaderData, EfiBootServicesCode,
>> EfiBootServicesData, or EfiConventionalMemory. That looks to be what x86
>> does.
>>
>
> That would make it more robust against new types in future spec
> changes, I suppose, although that would seem unlikely.
>
> I am happy to change the patch to take that approach instead, if
> others agree that it is preferable?
>

As it turns out, there is another problem with this code:
is_reserve_region() currently identifies a region of type
EFI_RUNTIME_SERVICES_DATA as not reserved if it does not have the
EFI_MEMORY_RUNTIME attribute set. However, it is perfectly legal for
the firmware not to request a virtual mapping for such a region if it
contains things like configuration tables that are not used by any of
the Runtime Services themselves.

I will replace this patch with one that inverts the logic, as MarkR
suggests, but also drops the test against EFI_MEMORY_RUNTIME.

-- 
Ard.
