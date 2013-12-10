From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Tue, 10 Dec 2013 15:20:16 -0800
Message-ID: <52A7A1B0.7050903@zytor.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>	 <52994324.4000404@zytor.com> <52A79B9A.7080004@zytor.com> <1386716246.26245.2.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386716246.26245.2.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/10/2013 02:58 PM, Matthew Garrett wrote:
> On Tue, 2013-12-10 at 14:54 -0800, H. Peter Anvin wrote:
> 
>> Ping on this?
> 
> No TAD, yes ACPI declaration for RTC.

OK, that is unfortunate.

>> Unless we find evidence to the contrary, we should probably do:
>>
>> ACPI TAD > PNP0B0x > EFI > hard probing
> 
> EFI is preferable to PNP in that it gives us a timezone, and Windows
> certainly calls the EFI time functions. *However*, it doesn't appear to
> do so once the system is booted. So we probably want to call it in the
> boot stub and find some way to pass the timezone information up to the
> kernel, and then spend some more time instrumenting Windows to figure
> out how it makes time calls.

TAD would also give us the timezone.  I'm not sure how you can
realistically only use the time function during boot, however, unless
you inherently assume it is coherent with the hardware RTC, since you
wouldn't be able to set it.

I suspect that means that Windows doesn't set the timezone information,
which is highly unfortunate since Windows is the main offender in not
using UTC time.

	-hpa
