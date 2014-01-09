From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
Date: Wed, 08 Jan 2014 20:00:54 -0800
Message-ID: <52CE1EF6.40300@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>	 <52CD9139.2070302@zytor.com> <1389239259.24105.2.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389239259.24105.2.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/08/2014 07:47 PM, joeyli wrote:
> 
> Unfortunately current acpica leaks the SystemCMOS handler:
> 
> ACPI Error: Region SystemCMOS (ID=5) has no handler (20131115/exfldio-299)
> 

I'm sorry, I can't parse either your statement or the error message...
sounds like there is a bug here, too.

	-hpa
