From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
Date: Tue, 3 Dec 2013 12:20:21 +0900
Message-ID: <529D4DF5.80502@jp.fujitsu.com>
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>  <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>  <528EF9CE.2070305@jp.fujitsu.com> <1385142450.2884.1.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385142450.2884.1.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/11/23 2:47), Matthew Garrett wrote:
> On Fri, 2013-11-22 at 15:29 +0900, Yasuaki Ishimatsu wrote:
>
>> +			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "PRIMEQUEST"),
>
> Can we guarantee that no Primequests have this issue? Can we guarantee
> that that no prior firmware versions have this issue? Can we guarantee
> that no future firmware versions will have this issue?
>

Sorry for the late reply. I contacted our firmware team to confirm them.
They said that current implementation, thereshold is 5KB, is strange.

Currently many EFI firmwares are based on EFI Development Kit (EDK).
Accoding to EDK source, gc on boot time runs when free space of nvram
is less than MaximumVariableSize of QueryVariableInfo(). In my system
MaximumVariableSize is 1KB. So when free space reaches less than 5KB
and I reboot the system, gc does not run on boot time in my system.

Threshold of gc depends on a system. So at least, 5KB threshold must be
changed on each system.

Thanks,
Yasuaki Ishimatsu
