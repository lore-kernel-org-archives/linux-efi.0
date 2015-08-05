From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V9 0/5] map GHES memory region according to EFI memory map
Date: Wed, 5 Aug 2015 08:58:52 -0700
Message-ID: <55C232BC.1010107@codeaurora.org>
References: <1438292109-4170-1-git-send-email-zjzhang@codeaurora.org>
 <20150803112658.GE10501@arm.com> <20150803162354.GQ2725@codeblueprint.co.uk>
 <20150804042552.GG31787@nazgul.tnic> <55C0DD30.9070800@codeaurora.org>
 <20150805092125.GB4332@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805092125.GB4332-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


On 8/5/2015 2:21 AM, Matt Fleming wrote:
> On Tue, 04 Aug, at 08:41:36AM, Zhang, Jonathan Zhixiong wrote:
>>
>> On 8/3/2015 9:25 PM, Borislav Petkov wrote:
>>> On Mon, Aug 03, 2015 at 05:23:54PM +0100, Matt Fleming wrote:
>>>> Rafael, Boris?
>>>
>>> The ghes.c change looks fine I guess. The whole patchset makes sense
>>> now, with the arch bits extracted. So
>>>
>>> Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
>> Thank you Boris/Matt/Will for the support.
>
> Jonathan, if you fixup the compiler error in PATCH 2 I'll take this
> series through the EFI tree.
Yes, absolutely. It has been in my mind, sorry I was tied up in the last
few days. I wonder what I may missed, I certainly do x86 build test with
versions of the patch set.

I will try today and report back.

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
