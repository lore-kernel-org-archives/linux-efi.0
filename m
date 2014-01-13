From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: Make efi virtual runtime map passing more robust
Date: Mon, 13 Jan 2014 11:27:34 +0100
Message-ID: <20140113102734.GB5388@pd.tnic>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-5-git-send-email-bp@alien8.de>
 <20140113054038.GB11237@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140113054038.GB11237-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 13, 2014 at 01:40:39PM +0800, Dave Young wrote:
> Adding a safeguard check for desc_size is better though currently it's
> impossible for the desc_size > PAGE_SIZE?

Huh, what?

sizeof(efi_memory_desc_t) is only 40 bytes AFAICT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
