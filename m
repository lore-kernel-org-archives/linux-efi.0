From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] Expose underlying UEFI firmware platform size to userland
Date: Mon, 12 Jan 2015 11:50:27 +0000
Message-ID: <20150112115027.GF26589@codeblueprint.co.uk>
References: <1420817394-12922-1-git-send-email-steve@einval.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420817394-12922-1-git-send-email-steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 09 Jan, at 03:29:53PM, Steve McIntyre wrote:
> In some cases (e.g. Intel Bay Trail machines), the kernel will happily
> run in 64-bit even if the underlying UEFI firmware platform is
> 32-bit. That's great, but it's difficult for userland utilities like
> grub-install to do the right thing in such a situation.
> 
> The kernel already knows about the size of the firmware via
> efi_enabled(EFI_64BIT). Add an extra sysfs interface
> /sys/firmware/efi/fw_platform_size to expose that information to
> userland for low-level utilities to use.
> 
> Signed-off-by: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
 
Looks good to me, Steve! Applied to 'next' for v3.20.

-- 
Matt Fleming, Intel Open Source Technology Center
