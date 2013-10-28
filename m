From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Date: Mon, 28 Oct 2013 17:00:53 +0100
Message-ID: <20131028160053.GO4314@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131028112246.GK1982@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028112246.GK1982-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 28, 2013 at 11:22:46AM +0000, Matt Fleming wrote:
> Could you use the efi_enabled() function to test for EFI_OLD_MEMMAP
> instead of test_bit()?

Sure.

> This way we won't exhaust the bitspace quite so soon (since ARM/ARM64

Yeah, very foresightful.

> can reuse EFI_ARCH_1 if they need it), plus this memory mapping method
> is a very architecture-specific thing and so makes sense to hide it in
> the bowels of arch/x86. If it turns out that ARM/ARM64 need the exact
> same config option we can delete EFI_ARCH_1 and move EFI_OLD_MEMMAP to
> include/linux/efi.h just like in your original patch. 
> 
> What do you think?

Yep, done and pushed out.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
