From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Sat, 10 Oct 2015 23:40:09 +0100
Message-ID: <20151010224009.GJ2723@codeblueprint.co.uk>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444330924-17830-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Oct, at 08:02:04PM, Ard Biesheuvel wrote:
> Since arm64 does not use a builtin decompressor, the EFI stub is built
> into the kernel proper. So far, this has been working fine, but actually,
> since the stub is in fact a PE/COFF relocatable binary that is executed
> at an unknown offset in the 1:1 mapping provided by the UEFI firmware, we
> should not be seamlessly sharing code with the kernel proper, which is a
> position dependent executable linked at a high virtual offset.
> 
> So instead, separate the contents of libstub and its dependencies, by
> putting them into their own namespace by prefixing all of its symbols
> with __efistub. This way, we have tight control over what parts of the
> kernel proper are referenced by the stub.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/Makefile            | 12 ++++-
>  arch/arm64/kernel/efi-entry.S         | 10 ++--
>  arch/arm64/kernel/head.S              | 14 ++---
>  arch/arm64/kernel/image.h             | 27 ++++++++++
>  drivers/firmware/efi/libstub/Makefile | 39 +++++++++++---
>  drivers/firmware/efi/libstub/string.c | 57 ++++++++++++++++++++
>  6 files changed, 139 insertions(+), 20 deletions(-)

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
