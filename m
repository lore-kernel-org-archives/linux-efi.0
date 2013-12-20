From: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 11:53:10 +0100
Message-ID: <1775986.qxTh3ADDRn@skinner>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B3C5F0.1060303-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thursday, December 19, 2013 08:22:08 PM H. Peter Anvin wrote:
> On 12/19/2013 08:05 PM, joeyli wrote:
> > Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
> > Present" flag. ACPI spec doesn't have clear definition on this.
> 
> According to the Microsoft requirements documents, such a platform is
> broken and shouldn't exist.

Is this a public document?
Probably not but if, a pointer in this thread would help.
Does Microsoft mention ACPI Time and Alarm Device interface in
such a document already?

I expect that future platforms will make more and more use of the
ACPI/EFI specified time functions.

It's probably up to Microsoft requiring this at some point of time,
then this stuff will work reliable, possibly others will not anymore.

Given the fact that there are machines which implement this interface
already and it is likely that more and more will, IMHO a first
implementation of this stuff in the kernel, even there are broken BIOSes
around, makes *a lot of* sense.

I suggest a whitelist, however it looks like:
  -> platforms which do not have a PNP0B0x device?
  -> dmi whitelist working platforms
  -> Extend it later with conditions where we know things work as expected

best also introduce an acpi=enable/disable_tad (or simlar) boot param which 
overrides white/blacklisting.
This will allow users to make use of this which may otherwise run into
problems and it will also allow easier testing and feedback
how reliable latest BIOS implementations are.


    Thomas
