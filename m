From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Fri, 4 Oct 2013 16:50:01 +0200
Message-ID: <20131004145001.GA4627@pd.tnic>
References: <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20131002100426.GB20568@pd.tnic>
 <524C3F38.6050507@zytor.com>
 <20131002170522.GA20647@pd.tnic>
 <524C58A3.4090704@zytor.com>
 <20131002184229.GE20568@pd.tnic>
 <524C6A14.40905@zytor.com>
 <20131004094247.GA6796@nazgul.tnic>
 <89e0284e-89b5-42ad-8120-128ef1bf0152@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <89e0284e-89b5-42ad-8120-128ef1bf0152-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 04, 2013 at 07:43:37AM -0700, H. Peter Anvin wrote:
> We can do that... but it is different from what Windows does to my
> understanding and it also has the potential of severe pathologies...
> e.g. a window at the top of the address space being mapped.

Right, so after Matt and I talked about it a bit on IRC, we actually
don't really care how we do the mappings if we spell them out later to
kexec over proc or somewhere else, as you wanted.

So we can do the VA address space saving scheme first and change it
later, if there are issues. We'll see.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
