From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/arm: fix absolute relocation detection for older
 toolchains
Date: Mon, 3 Oct 2016 21:52:33 +0100
Message-ID: <20161003205233.GO16071@codeblueprint.co.uk>
References: <1475276515-21801-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475276515-21801-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 30 Sep, at 04:01:55PM, Ard Biesheuvel wrote:
> 
> This is a workaround for now. We can revisit this when a need arises to copy
> more kernel code into the stub, by which time we could put in a more elaborate
> fix, or decide to no longer care about 'older' versions of objcopy.
> 
> Since this fixes an ARM specific issue and only affects ARM specific Makefile
> variables, I am happy for this to go on top of the arm-soc patch that enables
> CONFIG_EFI for ARM's multi_v7_defconfig (queued for v4.9), given that we have
> no other changes queued in linux-efi that should conflict with this patch.
> 
> Matt, any concerns?

Not with the patch, but could we clarify the user-visible effects of
not applying it? Are the absolute relocations harmless, or will they
lead to crashes? 
