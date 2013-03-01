From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Fri, 1 Mar 2013 23:36:35 +0000
Message-ID: <20130301233635.GA8464@srcf.ucam.org>
References: <20130301213903.GI30938@pd.tnic>
 <51312C8F.8000503@zytor.com>
 <20130301225303.GK30938@pd.tnic>
 <513132B0.3050308@zytor.com>
 <20130301230733.GL30938@pd.tnic>
 <1362180625.29011.4.camel@shinybook.infradead.org>
 <1362180853.29011.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1362180853.29011.6.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 01, 2013 at 11:34:13PM +0000, David Woodhouse wrote:

> Oh, I meant to mention: Matthew once told me about a bizarre issue on
> MacBook firmware, iirc. Some stuff doesn't work if the virtual address
> is above 2GiB. Or below 2GiB. I don't really remember what Matthew told
> me at all, to be honest. Only that Here Be Dragons and we don't quite
> have free rein about where we place stuff. But I suspect we ought to be
> able to find *somewhere* in the user address space that works, even for
> 32-bit kernels.

Apple's enough of a special case that I've no objection to 
special-casing them.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
