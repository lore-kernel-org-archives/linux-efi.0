From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH] efi: Request desired alignment via the PE/COFF headers
Date: Sat, 12 Jul 2014 14:34:26 +0100
Message-ID: <53C13962.1000309@fensystems.co.uk>
References: <1404945890-10754-1-git-send-email-mbrown@fensystems.co.uk> <53C081DC.5080605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53C081DC.5080605-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/07/14 01:31, H. Peter Anvin wrote:
>> --- a/arch/x86/boot/header.S
>> +++ b/arch/x86/boot/header.S
>> @@ -154,7 +154,7 @@ extra_header_fields:
>>   #else
>>   	.quad	0				# ImageBase
>>   #endif
>> -	.long	0x20				# SectionAlignment
>> +	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
>>   	.long	0x20				# FileAlignment
>>   	.word	0				# MajorOperatingSystemVersion
>>   	.word	0				# MinorOperatingSystemVersion
>
> Are large alignments (16 MiB!) actually allowed in PE/COFF?

I tested it: the EDK2 code seems perfectly happy to load images with 
that alignment.

Michael
