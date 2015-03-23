From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 03/19] x86, boot: Simplify run_size calculation
Date: Mon, 23 Mar 2015 11:25:22 +0800
Message-ID: <20150323032522.GC2068@dhcp-16-105.nay.redhat.com>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
 <1426663706-23979-4-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426663706-23979-4-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/18/15 at 12:28am, Yinghai Lu wrote:
> While looking at the boot code to add mem mapping for kasl
> with 64bit above 4G support, I found that e6023367d779 ("x86, kaslr: Prevent
> .bss from overlaping initrd") and later introduced way to get kernel run_size
> and pass it around.  First via perl and then change to shell scripts.
> 
> That is not necessary. As that run_size is simple constant, we don't
> need to pass it around and we already have voffset.h for that.
> 
> We can share voffset.h between misc.c and header.S instead
> of adding other way to get run_size.
> 
> This patch:
> Move voffset.h creation code to boot/compressed/Makefile.
> 
> Dependence was:
> boot/header.S ==> boot/voffset.h ==> vmlinux
> boot/header.S ==> compressed/vmlinux ==> compressed/misc.c
> Now become:
> boot/header.S ==> compressed/vmlinux ==> compressed/misc.c ==> boot/voffset.h ==> vmlinux
> 
> Use macro in misc.c to replace passed run_size.
> 
> Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> Cc: Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/Makefile            | 11 +----------
>  arch/x86/boot/compressed/Makefile | 12 ++++++++++++
>  arch/x86/boot/compressed/misc.c   |  3 +++
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index 863ef25..e7ee9cd 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -77,15 +77,6 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
>  
>  SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
>  
> -sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
> -
> -quiet_cmd_voffset = VOFFSET $@
> -      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
> -
> -targets += voffset.h
> -$(obj)/voffset.h: vmlinux FORCE
> -	$(call if_changed,voffset)
> -
>  sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
>  
>  quiet_cmd_zoffset = ZOFFSET $@
> @@ -97,7 +88,7 @@ $(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
>  
>  
>  AFLAGS_header.o += -I$(obj)
> -$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
> +$(obj)/header.o: $(obj)/zoffset.h
>  
>  LDFLAGS_setup.elf	:= -T
>  $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 0a291cd..d9fee82 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -40,6 +40,18 @@ LDFLAGS_vmlinux := -T
>  hostprogs-y	:= mkpiggy
>  HOST_EXTRACFLAGS += -I$(srctree)/tools/include
>  
> +sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 _AC(0x\1,UL)/p'
> +
> +quiet_cmd_voffset = VOFFSET $@
> +      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
> +
> +targets += ../voffset.h
> +
> +$(obj)/../voffset.h: vmlinux FORCE
> +	$(call if_changed,voffset)
> +
> +$(obj)/misc.o: $(obj)/../voffset.h
> +
>  vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>  	$(obj)/string.o $(obj)/cmdline.o \
>  	$(obj)/piggy.o $(obj)/cpuflags.o
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index a950864..4785c23 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -11,6 +11,7 @@
>  
>  #include "misc.h"
>  #include "../string.h"
> +#include "../voffset.h"
>  
>  /* WARNING!!
>   * This code is compiled with -fPIC and it is relocated dynamically
> @@ -390,6 +391,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  	lines = real_mode->screen_info.orig_video_lines;
>  	cols = real_mode->screen_info.orig_video_cols;
>  
> +	run_size = VO__end - VO__text;

Hi Yinghai,

This may not be correct. In commit e602336
runsize = offset(.bss) + size(.bss) + size(.brk), why this formula comes
out can be checked from discussion between Kees and Junjie:
https://lkml.org/lkml/2014/10/30/612

And in my one kernel build the related values are:
-) objdump -h vmlinux
vmlinux:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off
Algn
 27 .bss          00167000  ffffffff81e92000  0000000001e92000  01292000
2**12
                  ALLOC
 28 .brk          00027000  ffffffff81ff9000  0000000001ff9000  01292000
2**0
                  ALLOC

run_size on old calculation is
0x01292000+0x00167000+0x00027000=0x1420000

-) nm vmlinux 
ffffffff81000000 T _text
ffffffff82020000 B _end

run_size on your method is 0x82020000 - 0x81000000 = 0x1020000

So if output_len which is the length of vmlinux.bin + vmlinux.relocs is
between the old run_size and your new run_size, the problem Junjie tried
to fix will happen again.


Thanks
Baoquan
