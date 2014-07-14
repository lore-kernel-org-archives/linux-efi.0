From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Request desired alignment via the PE/COFF headers
Date: Mon, 14 Jul 2014 13:56:09 -0700
Message-ID: <53C443E9.2030305@zytor.com>
References: <1404945890-10754-1-git-send-email-mbrown@fensystems.co.uk> <53C081DC.5080605@zytor.com> <53C13962.1000309@fensystems.co.uk> <20140714120832.GG5952@console-pimps.org> <20140714121248.GH5952@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140714121248.GH5952-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/14/2014 05:12 AM, Matt Fleming wrote:
> On Mon, 14 Jul, at 01:08:32PM, Matt Fleming wrote:
>> On Sat, 12 Jul, at 02:34:26PM, Michael Brown wrote:
>>> On 12/07/14 01:31, H. Peter Anvin wrote:
>>>>> --- a/arch/x86/boot/header.S
>>>>> +++ b/arch/x86/boot/header.S
>>>>> @@ -154,7 +154,7 @@ extra_header_fields:
>>>>>  #else
>>>>>  	.quad	0				# ImageBase
>>>>>  #endif
>>>>> -	.long	0x20				# SectionAlignment
>>>>> +	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
>>>>>  	.long	0x20				# FileAlignment
>>>>>  	.word	0				# MajorOperatingSystemVersion
>>>>>  	.word	0				# MinorOperatingSystemVersion
>>>>
>>>> Are large alignments (16 MiB!) actually allowed in PE/COFF?
>>>
>>> I tested it: the EDK2 code seems perfectly happy to load images with
>>> that alignment.
>>
>> Right, I also quickly scanned the PE/COFF spec and didn't see anything
>> to suggest that such a large alignment would be allowed for
>> SectionAlignment (FileAlignment is another matter).
> 
> Urgh...
> 
> I didn't see anything in the spec saying a 16MB alignment would *not* be
> allowed.
> 

That's good.  So will you apply it, or should I?

	-hpa
