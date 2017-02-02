From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: libstub: Make file I/O chunking x86-specific
Date: Thu, 2 Feb 2017 21:44:49 +0000
Message-ID: <20170202214449.GR31613@codeblueprint.co.uk>
References: <1485877949-21981-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485877949-21981-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 31 Jan, at 03:52:29PM, Ard Biesheuvel wrote:
> The ARM decompressor is finicky when it comes to uninitialized variables
> with local linkage, the reason being that it may relocate .text and .bss
> independently when executing from ROM. This is only possible if all
> references into .bss from .text are absolute, and this happens to be the
> case for references emitted under -fpic to symbols with external linkage,
> and so all .bss references must involve symbols with external linkage.
> 
> When building the ARM stub using clang, the initialized local variable
> __chunk_size is optimized into a zero-initialized flag that indicates
> whether chunking is in effect or not. This flag is therefore emitted into
> .bss, which triggers the ARM decompressor's diagnostics, resulting in a
> failed build.
> 
> Under UEFI, we never execute the decompressor from ROM, so the diagnostic
> makes little sense here. But we can easily work around the issue by making
> __chunk_size global instead.
> 
> However, given that the file I/O chunking that is controlled by the
> __chunk_size variable is intended to work around known bugs on various
> x86 implementations of UEFI, we can simply make the chunking an x86
> specific feature. This is an improvement by itself, and also removes the
> need to parse the efi= options in the stub entirely.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
