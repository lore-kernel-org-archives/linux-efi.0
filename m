From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: remove local copy of linux_banner
Date: Wed, 25 Jun 2014 22:04:47 +0100
Message-ID: <20140625210447.GG15494@console-pimps.org>
References: <1402657911-7779-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1402657911-7779-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Jun, at 01:11:51PM, Ard Biesheuvel wrote:
> The shared efistub code for ARM and arm64 contains a local copy of linux_banner,
> allowing it to be referenced from separate executables such as the ARM
> decompressor. However, this introduces a dependency on generated header files,
> causing unnecessary rebuilds of the stub itself and, in case of arm64, vmlinux
> which contains it.
> 
> On arm64, the copy is not actually needed since we can reference the original
> symbol directly, and as it turns out, there may be better ways to deal with this
> for ARM as well, so let's remove it from the shared code. If it still needs to
> be reintroduced for ARM later, it should live under arch/arm anyway and not in
> shared code.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi-stub.c |  2 --
>  drivers/firmware/efi/fdt.c   | 10 ----------
>  2 files changed, 12 deletions(-)

Applied, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
