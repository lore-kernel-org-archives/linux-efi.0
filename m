From: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
Date: Thu, 16 Jan 2014 06:52:16 -0800
Message-ID: <52D7F220.5090201@linux.intel.com>
References: <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com> <52D6970D.3050701@zytor.com> <20140116014457.GA3807@dhcp-16-126.nay.redhat.com> <52D746D9.7030206@linux.intel.com> <20140116030343.GF3807@dhcp-16-126.nay.redhat.com> <52D75A55.2080503@zytor.com> <20140116064627.GC6356@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140116064627.GC6356-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>
> If the *module* is really a nonmodule, IMHO it should add the information to
> or add other macros macros instead of reuse the MODULE_*.
>
> BTW, for macros in this file, for a nonmodule "license GPL" is unnecessary at all.

I really fail to see what you have against machine-and-human readable data
