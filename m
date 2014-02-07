From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RFC][PATCH 04/11] x86/efi: Delete dead code when checking for
 non-native
Date: Fri, 7 Feb 2014 17:40:11 +0100
Message-ID: <20140207164011.GL24395@pd.tnic>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
 <1391012637-4839-5-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391012637-4839-5-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 29, 2014 at 04:23:50PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Both efi_free_boot_services() and efi_enter_virtual_mode() are invoked
> from init/main.c, but only if the EFI runtime services are available.
> This is not the case for non-native boots, e.g. where a 64-bit kernel is
> booted with 32-bit EFI firmware.
> 
> Delete the dead code.
> 
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
