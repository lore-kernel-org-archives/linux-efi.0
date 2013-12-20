From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 14:15:28 -0800
Message-ID: <52B4C180.40904@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com> <1775986.qxTh3ADDRn@skinner>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1775986.qxTh3ADDRn@skinner>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/20/2013 02:53 AM, Thomas Renninger wrote:
> On Thursday, December 19, 2013 08:22:08 PM H. Peter Anvin wrote:
>> On 12/19/2013 08:05 PM, joeyli wrote:
>>> Then that means the priority of PNP0B0x is higher then "CMOS RTC Not
>>> Present" flag. ACPI spec doesn't have clear definition on this.
>>
>> According to the Microsoft requirements documents, such a platform is
>> broken and shouldn't exist.
> 
> Is this a public document?
> Probably not but if, a pointer in this thread would help.
> Does Microsoft mention ACPI Time and Alarm Device interface in
> such a document already?
> 

This is the document... I can't remember who sent me the link to it:

http://goo.gl/R7S9Mk

	-hpa
