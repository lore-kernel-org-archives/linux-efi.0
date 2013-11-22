From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Date: Fri, 22 Nov 2013 15:23:57 +0900
Message-ID: <528EF87D.4050300@jp.fujitsu.com>
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385078632.12107.3.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/11/22 9:03), Matthew Garrett wrote:
> On Fri, 2013-11-22 at 09:00 +0900, Yasuaki Ishimatsu wrote:
>> (2013/11/22 5:12), Matthew Garrett wrote:
>>> On Thu, 2013-11-21 at 18:35 +0900, Yasuaki Ishimatsu wrote:
>>>
>>>> Remaining space is free space that can be used by efi variable. But by 5KB
>>>> threshold, we cannot use the space while running OS.
>>>
>>> Is the situation something like(assuming a 128KB flash part):
>>>
>>> 1) 64KB of variables, 59KB of deleted variables, 5KB of free space,
>>
>> My situation looks like this. The free space spreads out if gc runs.
>
> Ok. In that case Joey's suggestion that we try forcing a GC run in the
> boot stub if free space < (threshold * 2) might be the best plan.
>
 > 2) 123KB of variables, 5KB of free space

I don't know how to implement your idea. But if GC run by your idea, the free
space may spread out. So 1) case is solved. But it does not solve 2) case.
In my opinion, if system has sane firmware, all nvram strage should be used.
I will send whiltelist version which used DMI infomation. Please review it.

Thanks,
Yasuaki Ishimatsu
