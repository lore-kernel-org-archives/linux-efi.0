From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] efi/reboot: Add generic wrapper around
 EfiResetSystem()
Date: Mon, 23 Jun 2014 17:18:45 -0400
Message-ID: <1403558325.755.56.camel@deneb.redhat.com>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
	 <1403185225-9031-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403185225-9031-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Aubrey Li <aubrey.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-06-19 at 14:40 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Implement efi_reboot(), which is really just a wrapper around the
> EfiResetSystem() EFI runtime service, but it does at least allow us to
> funnel all callers through a single location.
> 
> It also simplifies the callsites since users no longer need to check to
> see whether EFI_RUNTIME_SERVICES are enabled.
> 
> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> 
> Mark, I reworked my efi_reboot() to more closely match your versino.
> Since we essentially wrote the same code I'd be happy to include your
> chosen Copyright notice, I just didn't want to be presumptuous and do it
> on your behalf without asking.
> 

Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks.
