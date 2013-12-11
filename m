From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Tue, 10 Dec 2013 20:00:01 -0800
Message-ID: <52A7E341.6050509@zytor.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>	 <52994324.4000404@zytor.com> <52A79B9A.7080004@zytor.com>	 <1386716246.26245.2.camel@x230> <52A7A1B0.7050903@zytor.com>	 <1386717862.26245.5.camel@x230>  <52A7A915.1070701@zytor.com> <1386721257.3539.1717.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386721257.3539.1717.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/10/2013 04:20 PM, joeyli wrote:
> 
> Actually, I am working on the timezone support of ACPI TIME and EFI
> TIME. My current implementation is using EFI time services to deal with
> clock in RTC.
> 
> The ACPI TAD is a generic device that need parse DSDT for access it. The
> DSDT parser is in subsystem initial stage. But in start_kernel, the
> timekeeping_init() call wallclock functions to deal system clock with
> RTC, it's too early for access ACPI TAD, so it still access CMOS
> interface unless switch it to EFI services.
> 
> If we adapt to ACPI TAD, then how does system clock deal with RTC
> through it when system boot?
> 

I don't really have a good answer for that.  We could call the EFI
services from the boot stub, of course, and pass in an approximate time
(and perhaps the TSC value to go with it), but I'm not sure if that will
be adequate.

The other alternative would be to either parse ACPI earlier or
initialize wall time later.

	-hpa
