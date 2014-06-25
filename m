From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efilinux: Allocate boot_params before parsing initrd
Date: Wed, 25 Jun 2014 21:45:54 +0100
Message-ID: <20140625204554.GE15494@console-pimps.org>
References: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403073669-6602-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Jun, at 11:41:08PM, Yinghai Lu wrote:
> We need to allocate boot_params early and clear it before copy
> setup_header to it.
> 
> So kernel will not call sanitize_boot_params() to overwrite new
> added parameter like ext_ramdisk_image, ext_ramdisk_size...
> 
> We should modify boot_params later instead of touch temp buf too early.
> 
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> ---
>  loaders/bzimage/bzimage.c |   65 ++++++++++++++++++++++++----------------------
>  1 file changed, 34 insertions(+), 31 deletions(-)
 
Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
