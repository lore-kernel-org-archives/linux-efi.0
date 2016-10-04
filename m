From: Jon Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/arm: fix absolute relocation detection for older
 toolchains
Date: Tue, 4 Oct 2016 11:14:29 +0100
Message-ID: <2f5904e7-8f2b-2993-5123-73b90c34e7d7@nvidia.com>
References: <1475276515-21801-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475276515-21801-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org
List-Id: linux-efi@vger.kernel.org


On 01/10/16 00:01, Ard Biesheuvel wrote:
> When building the ARM kernel with CONFIG_EFI=y, the following build
> error may occur when using a less recent version of binutils (2.23 or
> older):
> 
>    STUBCPY drivers/firmware/efi/libstub/lib-sort.stub.o
>  00000000 R_ARM_ABS32       sort
>  00000004 R_ARM_ABS32       __ksymtab_strings
>  drivers/firmware/efi/libstub/lib-sort.stub.o: absolute symbol references
>  not allowed in the EFI stub
> 
> (and when building with debug symbols, the list above is much longer, and
> contains all the internal references between the .debug sections and the
> actual code)
> 
> This issue is caused by the fact that objcopy v2.23 or earlier does not
> support wildcards in its -R and -j options, which means the following
> line from the Makefile:
> 
>   STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab* -R *kcrctab*
> 
> fails to take effect, leaving harmless absolute relocations in the binary
> that are indistinguishable from relocations that may cause crashes at
> runtime due to the fact that these relocations are resolved at link time
> using the virtual address of the kernel, which is always different from
> the address at which the EFI firmware loads and invokes the stub.
> 
> So, as a workaround, disable debug symbols explicitly when building the
> stub for ARM, and strip the ksymtab and kcrctab symbols for the only
> exported symbol we currently reuse in the stub, which is 'sort'.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks fixes the issues I was seeing. So ...

Tested-by: Jon Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Cheers
Jon

-- 
nvpublic
