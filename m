From: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Mon, 08 Sep 2014 15:01:31 +0200
Message-ID: <540DA8AB.3060008@canonical.com>
References: <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>	<54073409.6030004@canonical.com>	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>	<20140903175948.GH3001@console-pimps.org>	<CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>	<54084376.8090002@canonical.com>	<540860F1.6060801@fensystems.co.uk>	<CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>	<CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>	<20140904213753.GM3001@console-pimps.org>	<20140905202744.GO3001@console-pimps.org> <CAKv+Gu8GOHMa=zVWBG7OdSG2i2Ag_XyEBE5NzU6ffLNP8zA3Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8GOHMa=zVWBG7OdSG2i2Ag_XyEBE5NzU6ffLNP8zA3Ug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey,

Op 08-09-14 om 14:55 schreef Ard Biesheuvel:
> On 5 September 2014 22:27, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>> On Thu, 04 Sep, at 10:37:53PM, Matt Fleming wrote:
>>> Thanks Ard, I'll take a look in the morning.
>> Maarten, could you try out this patch?
>>
> Any developments regarding this patch?
> I tried to test it myself, but my Macbook happily boots straight from
> EFI into the kernel without it.
Sorry, forgot about it.

My system boots fine with this patch, thanks!

~Maarten
