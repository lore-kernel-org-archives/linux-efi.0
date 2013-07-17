From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
Date: Wed, 17 Jul 2013 07:35:46 +0100
Message-ID: <CAL01qpuLA8rX6ZfgYJf3NC9q3cuLvmw0sr4SX521mQjtzz=F4g@mail.gmail.com>
References: <51DD46AD.2010800@canonical.com>
	<CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
	<51E5E604.9050003@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E5E604.9050003-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 July 2013 01:32, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 07/10/2013 04:39 AM, Fleming, Matt wrote:
>> On 10 July 2013 12:34, Maarten Lankhorst
>> <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>>> Hey,
>>>
>>> It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
>>> efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
>>> letting my macbook pro boot succesfully.
>>
>> Thanks for the report. I'm going to queue up a revert of this patch,
>> Dave Young also reported a problem on his thinkpad.
>>
>
> Can I grab this somewhere yet?

http://article.gmane.org/gmane.linux.kernel.efi/1514
