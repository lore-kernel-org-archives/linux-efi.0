From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Date: Wed, 15 Jan 2014 09:16:09 +0800
Message-ID: <20140115011609.GD23767@dhcp-16-126.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
 <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
 <20140113101822.GA5388@pd.tnic>
 <20140113122320.GA1900@darkstar.nay.redhat.com>
 <52D3FCAA.7070004@linux.intel.com>
 <20140114014003.GB4327@dhcp-16-126.nay.redhat.com>
 <52D57F75.7060308@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52D57F75.7060308-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/14/14 at 10:18am, H. Peter Anvin wrote:
> On 01/13/2014 05:40 PM, Dave Young wrote:
> > On 01/13/14 at 06:48am, Arjan van de Ven wrote:
> >> On 1/13/2014 4:23 AM, Dave Young wrote:
> >>>>
> >>>>> How about do not limit to only if (pgd) case, instead do something
> >>>>> like below: set dump_to_dmesg as a module parameter
> >>>>
> >>>> X86_PTDUMP is not a module.
> >>>
> >>> Hmm, I just see the module macros in the code, since it's a bool Kconfig
> >>> I think the dump_pagetables.c need a cleanup,
> >>> remove the #include <linux/module.h> and below lines:
> >>> MODULE_LICENSE("GPL");
> >>> MODULE_AUTHOR("Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>");
> >>> MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");
> >>
> >> personally I consider it good form to always have this kind of information in .c files,
> >> regardless of the KConfig side of thing...
> > 
> > I agree it's good to add these infomation, but they can be added in comment.
> > IMHO it will be better in that way.
> > 
> 
> Why the [Finnish] do you feel that information needs to be in a
> different form because it is (currently!) not available as a module?

I think moving them to comment can avoid including extra linux/module.h

If a module specific parameter is needed maybe it's not bad to add dummy
module_init/module_exit

Thanks
Dave
