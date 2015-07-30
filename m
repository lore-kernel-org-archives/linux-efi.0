From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Thu, 30 Jul 2015 18:33:41 +0200
Message-ID: <55BA51E5.3070601@linutronix.de>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de> <20150728205157.GD2773@codeblueprint.co.uk> <20150729001034.GD8671@cloud> <55B88F3B.2000902@linutronix.de> <20150729164118.GC10114@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150729164118.GC10114@x>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/29/2015 06:41 PM, Josh Triplett wrote:

>> This is correct. However I miss the point of saving the image in the
>> first place. From what I see is that I have now 272 KiB in memory which
>> are never used again. Is there a usecase why we have it? From the code
>> it looks like we save it during boot and make it available later via
>> sysfs.
> 
> That's the point, yes.  A splash screen or an about box can then read it
> from there later and display it to the user.
> 
>>>>>  arch/x86/platform/efi/efi-bgrt.c | 4 ++++
>>>>>  1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
>>>>> index d7f997f7c26d..59710f0875bb 100644
>>>>> --- a/arch/x86/platform/efi/efi-bgrt.c
>>>>> +++ b/arch/x86/platform/efi/efi-bgrt.c
>>>>> @@ -79,6 +79,10 @@ void __init efi_bgrt_init(void)
>>>>>  	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
>>>>>  	if (ioremapped)
>>>>>  		early_iounmap(image, sizeof(bmp_header));
>>>>> +	if (bmp_header.id != 0x4d42) {
>>>>> +		pr_err("BGRT: Not a valid BMP file.\n");
>>>>> +		return;
>>>>> +	}
>>>
>>> That's a good idea as an additional cross-check, but not a complete fix
>>> for the problem.
>>
>> But it is one additional check to make sure we look at proper data. The
>> (ACPI-table) header has an image type which is to BMP (the only
>> currently support image type) so this is the double check.
> 
> I agree completely with adding the check; I'm just saying it isn't a
> complete fix.

okay, so how do we continue here? You ack that one  and send the other
patch on top or do you want first that kexec patch and then the BMP
check?

>> And the
>> kernel should be able to read from any address as long as it is within
>> its DRAM.
> 
> Then what caused the oops on early_ioremap?

from the WARN_ON() in ioremap:

         /*
          * Mappings have to fit in the FIX_BTMAP area.
          */
         nrpages = size >> PAGE_SHIFT;
         if (WARN_ON(nrpages > NR_FIX_BTMAPS))
                 return NULL;

This means the size of the ioremap is limited to 256KiB. So lets say we
get 300KiB as the image size: we managed to allocate say 300KiB via
kmalloc() and later we get the warn_on() here because we can't remap
more than 256KiB.

So we can ignore this until a BIOS includes a real image with a size >
256KiB. Another way around it would be get memblock to ignore this
region and give it back later.

> That sounds like a sensible fix; don't try to parse the BGRT if
> efi_setup.

okay.

> - Josh Triplett

Sebastian
