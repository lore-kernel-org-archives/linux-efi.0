From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
Date: Wed, 16 Oct 2013 10:36:00 +0200
Message-ID: <525E4FF0.5050101@canonical.com>
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com> <20131016071122.GB18241@dhcp-16-126.nay.redhat.com> <20131016080711.GC10834@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131016080711.GC10834@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

op 16-10-13 10:07, Matt Fleming schreef:
> Also better include Maarten on Cc as the author of the code.
>
> On Wed, 16 Oct, at 03:11:22PM, Dave Young wrote:
>> typo, fix hpa's mail address..
>>
>> On 10/16/13 at 03:03pm, Dave Young wrote:
>>> Current code check boot service region with kernel text region by: 
>>> start+size >= __pa_symbol(_text)
>>> The end of the above region should be start + size - 1 instead.

Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

>>> I see this problem in ovmf + Fedora 19 grub boot:
>>> text start: 1000000 md start: 800000 md size: 800000
>>>
>>> Signed-off-by: Dave Young <dyoung@redhat.com>
>>> ---
>>>  arch/x86/platform/efi/efi.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
>>> +++ linux-2.6/arch/x86/platform/efi/efi.c
>>> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
>>>  		 * - Not within any part of the kernel
>>>  		 * - Not the bios reserved area
>>>  		*/
>>> -		if ((start+size >= __pa_symbol(_text)
>>> +		if ((start + size - 1 >= __pa_symbol(_text)
>>>  				&& start <= __pa_symbol(_end)) ||
>>>  			!e820_all_mapped(start, start+size, E820_RAM) ||
>>>  			memblock_is_region_reserved(start, size)) {
