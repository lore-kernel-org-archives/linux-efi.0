From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2 v2] efilinux: set ext_ramdisk_* for huge initrd
Date: Fri, 27 Jun 2014 07:24:06 +0100
Message-ID: <20140627062406.GA7539@console-pimps.org>
References: <1403731467-1527-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403731467-1527-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 25 Jun, at 02:24:27PM, Yinghai Lu wrote:
> We could load it high if it is more than 2G when kernel support
> LOAD_ABOVE_4G.
> 
> -v2: Use macro instead of (1<<1) directly for LOAD_ABOVE_4G.
> 
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> ---
>  loaders/bzimage/bzimage.c |    9 ++++++++-
>  loaders/bzimage/bzimage.h |   15 +++++++++++++--
>  2 files changed, 21 insertions(+), 3 deletions(-)

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
