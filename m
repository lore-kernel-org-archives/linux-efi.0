From: "Arend van Spriel" <arend-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: access efi variables
Date: Sat, 14 Sep 2013 19:01:19 +0200
Message-ID: <5234965F.3050404@broadcom.com>
References: <52333139.6020203@broadcom.com> <5233939B.3020401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5233939B.3020401-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/14/13 00:37, H. Peter Anvin wrote:
> On 09/13/2013 08:37 AM, Arend van Spriel wrote:
>> I need to obtain a uefi variable so I went looking at the API in
>> include/linux/efi.h. I found the following definition:
>>
>> But according to the specs the variable I need to obtain is 2k bytes.
>> Should I expect trouble :-p
>>
>
> efivarfs doesn't have those limitations.

Thanks, Peter

Looking into efivarfs it seems to use the functions that I looked at in 
efi.h so I guess I am misinterpreting the 1024 bytes limitation in the 
comment (either that or you are mistaken ;-) ). I need to access the 
variable from within a device driver so using efivarfs does not feel 
like the way to go here.

Regards,
Arend
