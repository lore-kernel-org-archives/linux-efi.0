From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 2/7] x86, boot: Move ZO to end of buffer
Date: Mon, 9 Mar 2015 17:54:01 -0700
Message-ID: <CAGXu5jJFms+vYOtEpVAQ6iZXM45uYF70a=vgyb72T0uRkf8c0g@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-3-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425766041-6551-3-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 7, 2015 at 2:07 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Boris found data from boot stage can not be used kernel stage.

"... be used during kernel stage."

Also, can you give a specific example of this problem? (Which data, used how?)

> Bootloader allocate buffer according to init_size in hdr, and load the
> ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
> During running of ZO, ZO move itself to the middle of buffer at
> z_extract_offset to make sure that decompressor would not have output
> overwrite input data before input data get consumed.
> After decompressor is called, VO (vmlinux) use whole buffer from start,
> and ZO code and data section is overlapped with VO bss section.
> And later VO/clear_bss() clear them before code in arch/x86/kernel/setup.c
> access them.
>
> To make the data survive that later, we should avoid the overlapping.
> At first move ZO close the end of buffer instead of middle of the buffer,
> that will move out ZO data out of VO bss area.
>
> Also after that we can find out where is data section of copied ZO
> instead of guessing. That will aslr mem_avoid array filling for

"That will make aslr mem_avoid array ..."

> new buffer seaching much simple.
>
> And rename z_extract_offset to z_min_extract_offset, as it is
> actually the minimum offset for extracting now.
>
> To keep the final real extract_offset to be page aligned like
> min_extract_offset, we need make VO _end and ZO _end both
> page aligned to make sure init_size always page aligned.
>
> Next patch will add ZO data size to init_size, so it will make sure
> ZO data is even out of VO brk area.

This seems like a reasonable idea, but I think the changes should be
noted/updated in misc.c since a lot of effort was made to make the
in-memory foot print as small as possible. These changes do expand the
size of the loaded kernel, IIUC. If not in this patch, maybe in 5/7?

-Kees

>
> Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
> index cbed140..a9b56f1 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -147,7 +147,9 @@ preferred_addr:
>  1:
>
>         /* Target address to relocate to for decompression */
> -       addl    $z_extract_offset, %ebx
> +       movl    BP_init_size(%esi), %eax
> +       subl    $_end, %eax
> +       addl    %eax, %ebx
>
>         /* Set up the stack */
>         leal    boot_stack_end(%ebx), %esp
> @@ -208,8 +210,13 @@ relocated:
>   */
>                                 /* push arguments for decompress_kernel: */
>         pushl   $z_output_len   /* decompressed length */
> -       leal    z_extract_offset_negative(%ebx), %ebp
> +
> +       movl    BP_init_size(%esi), %eax
> +       subl    $_end, %eax
> +       movl    %ebx, %ebp
> +       subl    %eax, %ebp
>         pushl   %ebp            /* output address */
> +
>         pushl   $z_input_len    /* input_len */
>         leal    input_data(%ebx), %eax
>         pushl   %eax            /* input_data */
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 2884e0c..69015b5 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -101,7 +101,9 @@ ENTRY(startup_32)
>  1:
>
>         /* Target address to relocate to for decompression */
> -       addl    $z_extract_offset, %ebx
> +       movl    BP_init_size(%esi), %eax
> +       subl    $_end, %eax
> +       addl    %eax, %ebx
>
>  /*
>   * Prepare for entering 64 bit mode
> @@ -329,7 +331,9 @@ preferred_addr:
>  1:
>
>         /* Target address to relocate to for decompression */
> -       leaq    z_extract_offset(%rbp), %rbx
> +       movl    BP_init_size(%rsi), %ebx
> +       subl    $_end, %ebx
> +       addq    %rbp, %rbx
>
>         /* Set up the stack */
>         leaq    boot_stack_end(%rbx), %rsp
> diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
> index b669ab6..c03b009 100644
> --- a/arch/x86/boot/compressed/mkpiggy.c
> +++ b/arch/x86/boot/compressed/mkpiggy.c
> @@ -80,11 +80,8 @@ int main(int argc, char *argv[])
>         printf("z_input_len = %lu\n", ilen);
>         printf(".globl z_output_len\n");
>         printf("z_output_len = %lu\n", (unsigned long)olen);
> -       printf(".globl z_extract_offset\n");
> -       printf("z_extract_offset = 0x%lx\n", offs);
> -       /* z_extract_offset_negative allows simplification of head_32.S */
> -       printf(".globl z_extract_offset_negative\n");
> -       printf("z_extract_offset_negative = -0x%lx\n", offs);
> +       printf(".globl z_min_extract_offset\n");
> +       printf("z_min_extract_offset = 0x%lx\n", offs);
>
>         printf(".globl input_data, input_data_end\n");
>         printf("input_data:\n");
> diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
> index 34d047c..e24e0a0 100644
> --- a/arch/x86/boot/compressed/vmlinux.lds.S
> +++ b/arch/x86/boot/compressed/vmlinux.lds.S
> @@ -70,5 +70,6 @@ SECTIONS
>                 _epgtable = . ;
>         }
>  #endif
> +       . = ALIGN(PAGE_SIZE);   /* keep ZO size page aligned */
>         _end = .;
>  }
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 16ef025..9bfab22 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -440,7 +440,7 @@ setup_data:         .quad 0                 # 64-bit physical pointer to
>
>  pref_address:          .quad LOAD_PHYSICAL_ADDR        # preferred load addr
>
> -#define ZO_INIT_SIZE   (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
> +#define ZO_INIT_SIZE   (ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
>  #define VO_INIT_SIZE   (VO__end - VO__text)
>  #if ZO_INIT_SIZE > VO_INIT_SIZE
>  #define INIT_SIZE ZO_INIT_SIZE
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index 9f6b934..0e8e4f7 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -66,6 +66,7 @@ void common(void) {
>         OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
>         OFFSET(BP_version, boot_params, hdr.version);
>         OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
> +       OFFSET(BP_init_size, boot_params, hdr.init_size);
>         OFFSET(BP_pref_address, boot_params, hdr.pref_address);
>         OFFSET(BP_code32_start, boot_params, hdr.code32_start);
>
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 00bf300..ac25c7f 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -325,6 +325,7 @@ SECTIONS
>                 __brk_limit = .;
>         }
>
> +       . = ALIGN(PAGE_SIZE);           /* keep VO init size page aligned */
>         _end = .;
>
>          STABS_DEBUG
> --
> 1.8.4.5
>



-- 
Kees Cook
Chrome OS Security
