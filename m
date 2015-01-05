From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC] fs: make efivarfs a pseudo filesystem, built by default
 with EFI
Date: Mon, 5 Jan 2015 14:15:21 +0000
Message-ID: <20150105141521.GC3163@console-pimps.org>
References: <1418925049-3659-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418925049-3659-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 18 Dec, at 05:50:49PM, Leif Lindholm wrote:
> efivars is currently enabled under MISC_FILESYSTEMS, which is decribed
> as "such as filesystems that came from other operating systems".
> In reality, it is a pseudo filesystem, providing access to the kernel
> UEFI variable interface.
> 
> Since this is the preferred interface for accessing UEFI variables, over
> the legacy efivars interface, also build it by default as a module if
> CONFIG_EFI.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  fs/Kconfig          | 2 +-
>  fs/efivarfs/Kconfig | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)

Looks good to me Leif.

Unless I hear otherwise, I'll apply this to the 'next' branch of the EFI
tree this week.

-- 
Matt Fleming, Intel Open Source Technology Center
