From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime
 services [ver #2]
Date: Wed, 23 Nov 2016 10:27:48 +0000
Message-ID: <20161123102747.GD24624@leverpostej>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: lukas@wunner.de, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

Any reason to not Cc LAKML?

On Wed, Nov 23, 2016 at 12:22:43AM +0000, David Howells wrote:
> Provide the ability to perform mixed-mode runtime service calls for arm in
> the same way that commit 0a637ee61247bd4bed9b2a07568ef7a1cfc76187
> ("x86/efi: Allow invocation of arbitrary boot services") provides the
> ability to invoke arbitrary boot services.

I'm not sure I understand. On arm/arm64, "mixed-mode" simply isn't possible.

I see we already call runtime services directly in efi_get_secureboot()
in drivers/firmware/efi/libstub/arm-stub.c.

If this is just to provide a consistent API for the stub, please note
that.

> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/arm/include/asm/efi.h   |    1 +
>  arch/arm64/include/asm/efi.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
> index 0b06f5341b45..e4e6a9d6a825 100644
> --- a/arch/arm/include/asm/efi.h
> +++ b/arch/arm/include/asm/efi.h
> @@ -55,6 +55,7 @@ void efi_virtmap_unload(void);
>  
>  #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
>  #define __efi_call_early(f, ...)	f(__VA_ARGS__)
> +#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
>  #define efi_is_64bit()			(false)
>  
>  #define efi_call_proto(protocol, f, instance, ...)			\
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index 771b3f0bc757..d74ae223d89f 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -49,6 +49,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
>  
>  #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
>  #define __efi_call_early(f, ...)	f(__VA_ARGS__)
> +#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)

Given this can only work in the stub, the name is somewhat unfortunate,
as it sounds like it's expected to be used at runtime (i.e. in the
kernel). But I guess that's not a big problem.

Other than the casting issue you noted, I think this should work,
though.

Thanks,
Mark.
