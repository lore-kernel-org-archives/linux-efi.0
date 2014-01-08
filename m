From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
Date: Wed, 08 Jan 2014 09:56:09 -0800
Message-ID: <52CD9139.2070302@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389193142.3539.6123.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/08/2014 06:59 AM, joeyli wrote:
> 
> ACPICA denied AML access RTC ports.
> 
> I tried to access 0x70, 0x71 ports in ASL on a real machine, ACPICA
> denied AML access to those ports. I got the following dmesg:
> 
> hwvalid-0188 hw_validate_io_request: Denied AML access to port
> 0x0000000000000071/1
> 
> The code in acpica denied it:
> 
> linux/drivers/acpi/acpica/hwvalid.c
> 
>  * This provides ACPICA with the desired port protections and
>  * Microsoft compatibility.
>  *
>  * Description of port entries:
> [...]
>  *  RTC:   Real-time clock
>  *  CMOS:  Extended CMOS
> [...]
>  */
> static const struct acpi_port_info acpi_protected_ports[] = {
> [...]
>         {"RTC", 0x0070, 0x0071, ACPI_OSI_WIN_XP},
>         {"CMOS", 0x0074, 0x0076, ACPI_OSI_WIN_XP},
> 
> 
> Document of Windows XP:
> http://www.freelists.org/post/windows_errors/what-error-messages-really-mean-WinXP-IO-Ports-Blocked-from-Bios-AML-on-Windows-XP
> 
> If just for ACPI TAD testing, we can remove the port protection check of
> RTC ports in hwvalid.c. I have read 0x70/0x71 port success after removed
> the checking in acpica/hwvalid.c.
> 
> I will try to write RTC port in AML after remove acpica check, maybe
> have other unpredictable situation.
> 

Now *THERE* is a good use of the "no RTC bit".  In the case that bit is
set we should presumably remove these ports from the block list.

Otherwise we should use the CMOS address space, not the I/O port address
space.

	-hpa
