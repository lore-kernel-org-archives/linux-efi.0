From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Date: Thu, 21 Nov 2013 18:35:28 +0900
Message-ID: <528DD3E0.3050606@jp.fujitsu.com>
References: <528C740A.6010407@jp.fujitsu.com> <1384963376.20536.3.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384963376.20536.3.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/11/21 1:02), Matthew Garrett wrote:
> On Wed, 2013-11-20 at 17:34 +0900, Yasuaki Ishimatsu wrote:
>
>> When booting my system, remaining space of efi variable storage is about
>> 5KB. So there is no room that sets a new variable to the storage. On my
>> system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
>> environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
>> threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
>> on pre OS environment with UEFI.
>
> By "remaining space is about 5KB", do you mean that the rest of the
> space is filled with variables or do you mean that there is more free
> space but it hasn't been garbage collected?
>

Remaining space is free space that can be used by efi variable. But by 5KB
threshold, we cannot use the space while running OS.

Thanks,
Yasuaki Ishimatsu
