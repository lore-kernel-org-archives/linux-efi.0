From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
Date: Thu, 19 Dec 2013 07:22:43 -0800
Message-ID: <52B30F43.1060306@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <1387439515-8926-5-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387439515-8926-5-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/18/2013 11:51 PM, Lee, Chun-Yi wrote:
> This patch add the driver of Time and Alarm Device in ACPI 5.0.
> Currently it only implemented get/set time functions and grab
> the capabilities of device when driver initial.
> 
> This driver also register rtc-acpitad platform device for RTC ACPITAD
> stub driver using.
> 
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

What platform do you have that has TAD support?  I am wondering how this
was tested.

	-hpa
