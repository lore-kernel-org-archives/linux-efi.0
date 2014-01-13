From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Date: Mon, 13 Jan 2014 20:23:21 +0800
Message-ID: <20140113122320.GA1900@darkstar.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
 <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
 <20140113101822.GA5388@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140113101822.GA5388-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> 
> > How about do not limit to only if (pgd) case, instead do something
> > like below: set dump_to_dmesg as a module parameter
> 
> X86_PTDUMP is not a module.

Hmm, I just see the module macros in the code, since it's a bool Kconfig
I think the dump_pagetables.c need a cleanup,
remove the #include <linux/module.h> and below lines:
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>");
MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");

> 
> And even though the idea to make the efi pagetable dumpable with a
> kernel cmdline parameter doesn't sound all that bad, I'd like to hold
> off on adding yet another efi= cmdline option and only do so until it is
> really needed.

I think not necessary limit to efi=? Probably something like ptdump_dmesg=1|0 

Thanks
Dave
