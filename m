From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 20 Dec 2013 08:48:04 -0800
Message-ID: <bdf7e604-0aad-4064-ba4c-89f8bb7d82cf@email.android.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com> <1387439515-8926-7-git-send-email-jlee@suse.com> <20131219140918.GF3145@console-pimps.org> <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com> <20131220103755.GA14784@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131220103755.GA14784-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The only real use case for the RTC TZ is compatibility with other operating systems that don't keep the time in UTC, at least as far as I can tell.  However, that is a fairly big one, especially in VM deployments.

Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
>> On 12/19/2013 08:24 PM, joeyli wrote:
>> > I agreed, but userspace application should not be too often to
>access
>> > RTC. Maybe only when system boot and set timezone.
>>
>> This is, quite frankly, an idiotic argument.
>
>TBH, I've been struggling with the question too - and it might even be
>a
>stupid question - but what is that absolute need to be able to get the
>TZ in userspace? Why should I care?
>
>Can we get some use cases for stupid people like me please?
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
