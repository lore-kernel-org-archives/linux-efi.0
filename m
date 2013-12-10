From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Tue, 10 Dec 2013 15:51:49 -0800
Message-ID: <52A7A915.1070701@zytor.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>	 <52994324.4000404@zytor.com> <52A79B9A.7080004@zytor.com>	 <1386716246.26245.2.camel@x230> <52A7A1B0.7050903@zytor.com> <1386717862.26245.5.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386717862.26245.5.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/10/2013 03:24 PM, Matthew Garrett wrote:
>>
>> TAD would also give us the timezone.  I'm not sure how you can
>> realistically only use the time function during boot, however, unless
>> you inherently assume it is coherent with the hardware RTC, since you
>> wouldn't be able to set it.
> 
> If we can verify that Windows actually uses TAD then I'd agree it's
> preferable to EFI, but if we can't then I wouldn't be so sure. I'll redo
> my Windows instrumentation and figure out under which circumstances it's
> calling the time functions.
> 

Well, *which version* of Windows is a big question here.  Keep in mind
that the TAD was only introduced with ACPI 5 so it is quite a new
feature.  I would really like to see it implemented in SeaBIOS and/or
OVMF so we can test it out in Qemu.

	-hpa
