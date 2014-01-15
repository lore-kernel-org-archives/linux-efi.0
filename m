From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: x86: make "efi facility" use slightly more generic
Date: Wed, 15 Jan 2014 14:22:08 +0000
Message-ID: <20140115142208.GA18749@console-pimps.org>
References: <1389721285-32390-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389721285-32390-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 14 Jan, at 05:41:25PM, Leif Lindholm wrote:
> Currently, efi_enabled() is defined to be a dummy macro always returning
> 1 unless CONFIG_X86. Change this logic to use a
> CONFIG_ARCH_USES_EFI_FACILITY to enable use by other architectures.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/Kconfig             |    1 +
>  drivers/firmware/efi/Kconfig |    3 +++
>  include/linux/efi.h          |    2 +-
>  3 files changed, 5 insertions(+), 1 deletion(-)

I'm not sure this is the way to go. I'd much prefer to treat introducing
CONFIG_* symbols like this a last resort only.

Let me post some patches to show you what I had in mind.

-- 
Matt Fleming, Intel Open Source Technology Center
