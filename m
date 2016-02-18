From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v5sub3 4/4] arm64: efi: invoke EFI_RNG_PROTOCOL to supply
 KASLR randomness
Date: Thu, 18 Feb 2016 10:15:01 +0000
Message-ID: <20160218101501.GA2651@codeblueprint.co.uk>
References: <1455126905-22688-1-git-send-email-ard.biesheuvel@linaro.org>
 <1455126905-22688-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455126905-22688-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 10 Feb, at 06:55:05PM, Ard Biesheuvel wrote:
> Since arm64 does not use a decompressor that supplies an execution
> environment where it is feasible to some extent to provide a source of
> randomness, the arm64 KASLR kernel depends on the bootloader to supply
> some random bits in the /chosen/kaslr-seed DT property upon kernel entry.
> 
> On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
> some random bits. At the same time, use it to randomize the offset of the
> kernel Image in physical memory.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/Kconfig                        |  5 ++
>  drivers/firmware/efi/libstub/arm-stub.c   | 40 ++++++----
>  drivers/firmware/efi/libstub/arm64-stub.c | 78 ++++++++++++++------
>  drivers/firmware/efi/libstub/fdt.c        | 14 ++++
>  4 files changed, 102 insertions(+), 35 deletions(-)

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
