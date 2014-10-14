From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] dmi: add support for SMBIOS 3.0 64-bit entry point
Date: Tue, 14 Oct 2014 14:20:32 +0200
Message-ID: <CAKv+Gu-6EtVSXRgQJiqGyGTo1MSLi6HdnMd+BCuz-gwEGODF2Q@mail.gmail.com>
References: <1413208113-16374-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141014105951.GE22224@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141014105951.GE22224-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Suravee Suthikulpanit <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 October 2014 12:59, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Oct 13, 2014 at 03:48:33PM +0200, Ard Biesheuvel wrote:
>> Version 3.0 of the DTMF SMBIOS reference spec defines a new entry point
>> type that supports a 64-bit address for the SMBIOS structure table. This
>> is needed by platforms whose system RAM resides above the 4 GB physical
>> address boundary, such as upcoming 64-bit ARM platforms.
>>
>> This is a preliminary RFC implementation, as there is no definition available
>> yet for SMBIOS3_TABLE_GUID, which the (currently still in draft) SMBIOS v3.0
>> spec refers to.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>                               goto out;
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index 8590099ac148..9035c1b74d58 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -30,6 +30,7 @@ struct efi __read_mostly efi = {
>>       .acpi       = EFI_INVALID_TABLE_ADDR,
>>       .acpi20     = EFI_INVALID_TABLE_ADDR,
>>       .smbios     = EFI_INVALID_TABLE_ADDR,
>> +     .smbios3    = EFI_INVALID_TABLE_ADDR,
>
> Is there any particular need to add a separate pointer for v3?
> In both cases, the pointer is a physical address stored as an unsigned
> long.
>

Yes, but they point to different header types, and the firmware could
legally provide either type or both (in which case, they may point to
the same SMBIOS structure table, or to distinct ones), and it is up to
DMI to interpret that, not EFI.

At the DMI level, we should be strict IMO and only interpret the new
_SM3_ entry point header if it was supplied using the
SMBIOS3_TABLE_GUID, so even if we use the same table pointer, we would
need to store additional data regarding which GUID was used.

-- 
Ard.
