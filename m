From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Wed, 18 Jun 2014 15:28:19 +0100
Message-ID: <20140618142819.GN24049@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 14 Jun, at 12:23:41PM, Yinghai Lu wrote:
> For boot efi kernel directly without bootloader.
> If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
> not limit initrd under hdr->initrd_add_max.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
