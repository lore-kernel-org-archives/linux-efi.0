From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Sat, 2 Mar 2013 00:39:24 +0100
Message-ID: <20130301233924.GM30938@pd.tnic>
References: <20130301213903.GI30938@pd.tnic>
 <51312C8F.8000503@zytor.com>
 <20130301225303.GK30938@pd.tnic>
 <513132B0.3050308@zytor.com>
 <20130301230733.GL30938@pd.tnic>
 <1362180625.29011.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1362180625.29011.4.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Just commenting on this one for now, the rest tomorrow cuz I'm half
asleep.

On Fri, Mar 01, 2013 at 11:30:25PM +0000, David Woodhouse wrote:
> The other option, for the long term, is to fix the damn firmware to
> allow SetVirtualAddressMap to be called more than once. It was stupid
> for it to be a one-time call anyway.

Now this would be the cleanest solution. If we can do that, we can then
simply call efi_enter_virtual_mode() in the kexec'd kernel without
the need to pass any options to it. Actually, the kexec'd kernel can
probably run the same efi code as the papa kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
