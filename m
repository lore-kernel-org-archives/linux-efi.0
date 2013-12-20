From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Fri, 20 Dec 2013 08:57:03 -0800
Message-ID: <83120989-e634-47c0-9bae-0c7899df64ab@email.android.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site> <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387552565.17961.3.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "bp-l3A5Bk7waGM@public.gmane.org" <bp-l3A5Bk7waGM@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

But we prefer the TAD for that.  The case where the EFI runtime is the only source of that info is problematic as they are known to not work at runtime.  We could collect it at boot and then never change it, although you end up in definitional issues between EFI and the hw RTC.

Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
>On Thu, 2013-12-19 at 20:22 -0800, H. Peter Anvin wrote:
>> On 12/19/2013 08:05 PM, joeyli wrote:
>> > Can we use EFI time services on x86_64 after Borislav's patches
>accepted
>> > to mainline?
>> > 
>> 
>> No.
>
>We will want to use them to (at minimum) obtain the clock timezone.
>Using them for general RTC access is less attractive.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
