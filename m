From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 2/7] x86, boot: Move ZO to end of buffer
Date: Tue, 10 Mar 2015 10:34:31 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1503101032560.26925@pobox.suse.cz>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org> <1425766041-6551-3-git-send-email-yinghai@kernel.org> <20150310080024.GB3535@pd.tnic>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310080024.GB3535-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 10 Mar 2015, Borislav Petkov wrote:

> Final patch:
> 
> ---
> From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Sat, 7 Mar 2015 14:07:16 -0800
> Subject: [PATCH] x86/setup: Move compressed kernel to the end of the buffer
[ ... ]
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")

Thanks a lot for fixing my oversight.

Acked-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

> Link: http://lkml.kernel.org/r/1425766041-6551-3-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> [ Commit message massively rewritten ]
> Signed-off-by: 
> ---
>  arch/x86/boot/compressed/head_32.S     | 11 +++++++++--
>  arch/x86/boot/compressed/head_64.S     |  8 ++++++--
>  arch/x86/boot/compressed/mkpiggy.c     |  7 ++-----
>  arch/x86/boot/compressed/vmlinux.lds.S |  1 +
>  arch/x86/boot/header.S                 |  2 +-
>  arch/x86/kernel/asm-offsets.c          |  1 +
>  arch/x86/kernel/vmlinux.lds.S          |  1 +
>  7 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index cbed1407a5cd..a9b56f1d8e75 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -147,7 +147,9 @@ preferred_addr:
>  1:
>  
>  	/* Target address to relocate to for decompression */
> -	addl	$z_extract_offset, %ebx
> +	movl    BP_init_size(%esi), %eax
> +	subl    $_end, %eax
> +	addl    %eax, %ebx
>  
>  	/* Set up the stack */
>  	leal	boot_stack_end(%ebx), %esp
> @@ -208,8 +210,13 @@ relocated:
>   */
>  				/* push arguments for decompress_kernel: */
>  	pushl	$z_output_len	/* decompressed length */
> -	leal	z_extract_offset_negative(%ebx), %ebp
> +
> +	movl    BP_init_size(%esi), %eax
> +	subl    $_end, %eax
> +	movl    %ebx, %ebp
> +	subl    %eax, %ebp
>  	pushl	%ebp		/* output address */
> +
>  	pushl	$z_input_len	/* input_len */
>  	leal	input_data(%ebx), %eax
>  	pushl	%eax		/* input_data */
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 2884e0c3e8a5..69015b576cf6 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -101,7 +101,9 @@ ENTRY(startup_32)
>  1:
>  
>  	/* Target address to relocate to for decompression */
> -	addl	$z_extract_offset, %ebx
> +	movl	BP_init_size(%esi), %eax
> +	subl	$_end, %eax
> +	addl	%eax, %ebx
>  
>  /*
>   * Prepare for entering 64 bit mode
> @@ -329,7 +331,9 @@ preferred_addr:
>  1:
>  
>  	/* Target address to relocate to for decompression */
> -	leaq	z_extract_offset(%rbp), %rbx
> +	movl	BP_init_size(%rsi), %ebx
> +	subl	$_end, %ebx
> +	addq	%rbp, %rbx
>  
>  	/* Set up the stack */
>  	leaq	boot_stack_end(%rbx), %rsp
> diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
> index b669ab65bf6c..c03b0097ce58 100644
> --- a/arch/x86/boot/compressed/mkpiggy.c
> +++ b/arch/x86/boot/compressed/mkpiggy.c
> @@ -80,11 +80,8 @@ int main(int argc, char *argv[])
>  	printf("z_input_len = %lu\n", ilen);
>  	printf(".globl z_output_len\n");
>  	printf("z_output_len = %lu\n", (unsigned long)olen);
> -	printf(".globl z_extract_offset\n");
> -	printf("z_extract_offset = 0x%lx\n", offs);
> -	/* z_extract_offset_negative allows simplification of head_32.S */
> -	printf(".globl z_extract_offset_negative\n");
> -	printf("z_extract_offset_negative = -0x%lx\n", offs);
> +	printf(".globl z_min_extract_offset\n");
> +	printf("z_min_extract_offset = 0x%lx\n", offs);
>  
>  	printf(".globl input_data, input_data_end\n");
>  	printf("input_data:\n");
> diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
> index 34d047c98284..a80acabb80ec 100644
> --- a/arch/x86/boot/compressed/vmlinux.lds.S
> +++ b/arch/x86/boot/compressed/vmlinux.lds.S
> @@ -70,5 +70,6 @@ SECTIONS
>  		_epgtable = . ;
>  	}
>  #endif
> +	. = ALIGN(PAGE_SIZE);	/* keep size page-aligned */
>  	_end = .;
>  }
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 16ef02596db2..9bfab22efdf7 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -440,7 +440,7 @@ setup_data:		.quad 0			# 64-bit physical pointer to
>  
>  pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
>  
> -#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset)
> +#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
>  #define VO_INIT_SIZE	(VO__end - VO__text)
>  #if ZO_INIT_SIZE > VO_INIT_SIZE
>  #define INIT_SIZE ZO_INIT_SIZE
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index 9f6b9341950f..0e8e4f7a31ce 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -66,6 +66,7 @@ void common(void) {
>  	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
>  	OFFSET(BP_version, boot_params, hdr.version);
>  	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
> +	OFFSET(BP_init_size, boot_params, hdr.init_size);
>  	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
>  	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
>  
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 00bf300fd846..a92d3dc2812a 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -325,6 +325,7 @@ SECTIONS
>  		__brk_limit = .;
>  	}
>  
> +	. = ALIGN(PAGE_SIZE);		/* keep init size page-aligned */
>  	_end = .;
>  
>          STABS_DEBUG
> -- 
> 2.2.0.33.gc18b867
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> ECO tip #101: Trim your mails when you reply.
> --
> 

-- 
Jiri Kosina
SUSE Labs
