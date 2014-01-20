From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Date: Mon, 20 Jan 2014 14:48:16 +0000
Message-ID: <20140120144816.GC684@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-6-git-send-email-bp@alien8.de>
 <20140120134407.GB684@console-pimps.org>
 <20140120134625.GD3003@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140120134625.GD3003-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 20 Jan, at 02:46:25PM, Borislav Petkov wrote:
> On Mon, Jan 20, 2014 at 01:44:07PM +0000, Matt Fleming wrote:
> > > +void __init kexec_enter_virtual_mode(void)
> > > +{
> > 
> > Could this be static for now?
> 
> Didn't you wanna do arch/x86/platform/efi/kexec.c anyway?

Yes, but the patches are easier to review if we make
kexec_enter_virtual_mode() global when moving it into a new file.

Plus it makes this patch that little bit smaller because the
modification to efi.h is unnecessary.

-- 
Matt Fleming, Intel Open Source Technology Center
