From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Wed, 29 Jul 2015 10:30:51 +0200
Message-ID: <55B88F3B.2000902@linutronix.de>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de> <20150728205157.GD2773@codeblueprint.co.uk> <20150729001034.GD8671@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729001034.GD8671@cloud>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/29/2015 02:10 AM, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
>> On Wed, 22 Jul, at 05:32:44PM, Sebastian Andrzej Siewior wrote:
>>> now and then. The data behind that pointer changes on each boot because
>>> nobody preserves the content across kexec.
> 
> Right.  The kernel copies this image precisely because it may go away at
> ExitBootServices or similar, or when ACPI reclaim space is freed.  This
> ties into the various work about trying to make kexec handle EFI and
> ACPI.  Is there some way we can indicate to the kexec kernel that this
> won't work?  (Or fix it so it will?)

>From what I know kexec entry is transparent. Could you remove the table
from ACPI? There is no point on having this bitmap information now,
right? The last way out would be to patch kexec and let it read the
table from /sys and put it at the spot mentioned in the ACPI table.

>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>> ---
>>>
>>> I don't know much about the requirement of having the .bmp in memory all the
>>> time. Would it be a bad thing to compress the bmp and uncompress on cat from
>>> userland? In my case the bmp has 272 KiB and LZO gets it down to 12KiB,
>>> XZ 7.4KiB.
>>
>> The usual use for BGRT is to display it during kernel boot, so
>> interacting with userland doesn't help you there.
> 
> If we're going to be storing a large image, applying simple in-kernel
> compression doesn't seem unreasonable, if we then decompress it when
> read from the BGRT sysfs file.  That's entirely separate from this issue
> though.

This is correct. However I miss the point of saving the image in the
first place. From what I see is that I have now 272 KiB in memory which
are never used again. Is there a usecase why we have it? From the code
it looks like we save it during boot and make it available later via
sysfs.

>>>  arch/x86/platform/efi/efi-bgrt.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
>>> index d7f997f7c26d..59710f0875bb 100644
>>> --- a/arch/x86/platform/efi/efi-bgrt.c
>>> +++ b/arch/x86/platform/efi/efi-bgrt.c
>>> @@ -79,6 +79,10 @@ void __init efi_bgrt_init(void)
>>>  	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
>>>  	if (ioremapped)
>>>  		early_iounmap(image, sizeof(bmp_header));
>>> +	if (bmp_header.id != 0x4d42) {
>>> +		pr_err("BGRT: Not a valid BMP file.\n");
>>> +		return;
>>> +	}
> 
> That's a good idea as an additional cross-check, but not a complete fix
> for the problem.

But it is one additional check to make sure we look at proper data. The
(ACPI-table) header has an image type which is to BMP (the only
currently support image type) so this is the double check. And the
kernel should be able to read from any address as long as it is within
its DRAM.

>  As you pointed out above, a wild pointer could cause a
> WARN from early_ioremap.  We need to never follow the pointer in the
> first place after a kexec, unless we have some way to know that it's
> actually valid.

So you assume that the information from ACPI is always correct then?
The pointer is correct, the information it points to is no longer.

If we run always under EFI then it looks like the variable efi_setup
which is checked in efi_enter_virtual_mode() is 0 during normal boot
and != 0 on kexec entry. This hint is set via setup_data / SETUP_EFI
since commit 1fec053369 ("x86/efi: Pass necessary EFI data for kexec
via setup_data"). So maybe we could use this to check if we run under
kexec or not.

> - Josh Triplett

Sebastian
