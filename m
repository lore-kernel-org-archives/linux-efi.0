From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: Make efi virtual runtime map passing more robust
Date: Mon, 13 Jan 2014 21:17:37 +0800
Message-ID: <20140113131737.GB1900@darkstar.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-5-git-send-email-bp@alien8.de>
 <20140113054038.GB11237@dhcp-16-126.nay.redhat.com>
 <20140113102734.GB5388@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140113102734.GB5388-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 13, 2014 at 11:27:34AM +0100, Borislav Petkov wrote:
> On Mon, Jan 13, 2014 at 01:40:39PM +0800, Dave Young wrote:
> > Adding a safeguard check for desc_size is better though currently it's
> > impossible for the desc_size > PAGE_SIZE?
> 
> Huh, what?
> 
> sizeof(efi_memory_desc_t) is only 40 bytes AFAICT.

I know this is nearly impossible, but is there possible for some corrupted
desc_size value or firmware bug? who knows...

Thanks
Dave
