From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
Date: Thu, 23 Jan 2014 17:51:09 +0100
Message-ID: <20140123165109.GA11190@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <20140123090654.GA17297@console-pimps.org>
 <1390494619.1792.482.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1390494619.1792.482.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 23, 2014 at 09:30:19AM -0700, Toshi Kani wrote:
> Since this issue is quite serious on our systems (3.14 kernels won't
> boot up), I'd really appreciate if the fixes can be made into some
> 3.14-rc.  It can hit on any EFI systems with large memory.

That's why we have "efi=old_map" - so that you can use the old mapping
method which is a chicken bit for the new scheme.

And I told you privately already that you're better off merging Matt's
'next' branch than us exposing this to the world too early. So stop
pushing this when there are clearly other solutions for your case and be
patient!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
