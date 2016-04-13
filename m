From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] efi: implement generic support for the Memory
 Attributes table
Date: Wed, 13 Apr 2016 10:29:23 +0200
Message-ID: <CAKv+Gu-bLN16YKei3togReQBNo+ScQVf7ek2NJEZAEyii2JEcw@mail.gmail.com>
References: <1459355933-13529-1-git-send-email-ard.biesheuvel@linaro.org>
	<1459355933-13529-5-git-send-email-ard.biesheuvel@linaro.org>
	<20160408155608.GQ2701@codeblueprint.co.uk>
	<CAKv+Gu-TMb0MTnzXXjczvxaWvZphu7M1-MMdjCrZ7A2CvCc2WQ@mail.gmail.com>
	<20160412195727.GG2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412195727.GG2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 April 2016 at 21:57, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 11 Apr, at 04:09:11PM, Ard Biesheuvel wrote:
>>
>> The spec does not actually mandate that, and I do know that the
>> Tianocore code deliberately uses a larger value for desc_size in
>> GetMemoryMap() to catch inadvertent uses of sizeof(). I am not sure if
>> the memory attribute table code does the same, and it seems dangerous
>> to assume that to be the case in general.
>
> The spec may not mandate that, but this code will explode horribly if
> efi_memory_desc_t does not accurately describe the entries in either
> the EFI Memory Attributes table or the EFI memory map.
>
> How do we ensure that doing,
>
> static bool entry_is_valid(...)
> {
>         *out = *in;
>         ...
>
> keeps working? Are we using the table version to guarantee that?

I think it is implied by the spec that this table and the one returned
by GetMemoryMap() use mutually compatible definitions of
EFI_MEMORY_DESCRIPTOR. However, since our definition of the struct
type is based on version 1, we should perhaps add a check for that
separately
