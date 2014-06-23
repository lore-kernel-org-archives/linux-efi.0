From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] efi/reboot: Allow powering off machines using EFI
Date: Mon, 23 Jun 2014 17:20:24 -0400
Message-ID: <1403558424.755.58.camel@deneb.redhat.com>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
	 <1403185225-9031-3-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403185225-9031-3-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Aubrey Li <aubrey.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-06-19 at 14:40 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Not only can EfiResetSystem() be used to reboot, it can also be used to
> power down machines.
> 
> By and large, this functionality doesn't work very well across the range
> of EFI machines in the wild, so it should definitely only be used as a
> last resort. In an ideal world, this wouldn't be needed at all.
> 
> Unfortunately, we're starting to see machines where EFI is the *only*
> reliable way to power down, and nothing else, not PCI, not ACPI, works.
> 
> efi_poweroff_required() should be implemented on a per-architecture
> basis, since exactly when we should be using EFI runtime services is a
> platform-specific decision. There's no analogue for reboot because each
> architecture handles reboot very differently - the x86 code in
> particular is pretty complex.
> 
> Patches to enable this for specific classes of hardware will be
> submitted separately.
> 
> Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
