From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
Date: Thu, 23 Jan 2014 09:56:32 -0700
Message-ID: <1390496192.1792.488.camel@misato.fc.hp.com>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
	 <20140123090654.GA17297@console-pimps.org>
	 <1390494619.1792.482.camel@misato.fc.hp.com>
	 <20140123165109.GA11190@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140123165109.GA11190-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-01-23 at 17:51 +0100, Borislav Petkov wrote:
> On Thu, Jan 23, 2014 at 09:30:19AM -0700, Toshi Kani wrote:
> > Since this issue is quite serious on our systems (3.14 kernels won't
> > boot up), I'd really appreciate if the fixes can be made into some
> > 3.14-rc.  It can hit on any EFI systems with large memory.
> 
> That's why we have "efi=old_map" - so that you can use the old mapping
> method which is a chicken bit for the new scheme.

Good point.  Yes, that will help us a lot.

> And I told you privately already that you're better off merging Matt's
> 'next' branch than us exposing this to the world too early. So stop
> pushing this when there are clearly other solutions for your case and be
> patient!

Right, but I just responded to Matt's query. :-) 

Thanks,
-Toshi
