From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Thu, 5 Feb 2015 11:25:04 +0800
Message-ID: <20150205032504.GB1903@darkstar.redhat.com>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

Thanks, it will be useful for possible efi rebooting to kdump reserved memory.

On 02/03/15 at 06:03pm, Yinghai Lu wrote:
> Now could use kexec to place kernel/boot_params/cmd_line/initrd
> above 4G, but that is with legacy interface with startup_64 directly.
> 
> This patch will allow 64bit EFI kernel to be loaded above 4G
> and use EFI HANDOVER PROTOCOL to start the kernel.
> 
> Current code32_start is used for passing around loading address,
> so it will overflow when kernel is loaded abover 4G.
> 
> The patch mainly add ext_code32_start to take address high 32bit.
> 
> After this patch, could use patched grub2-x86_64.efi to place
> kernel/boot_params/cmd_line/initrd all above 4G and execute the kernel
> above 4G.

Can you share the grub2 patch for testing?

> 
> bootlog like:
> 
> params: [1618fc000,1618fffff]
> cmdline: [1618fb000,1618fb7fe]
> kernel: [15e000000,161385fff]
> kernel: done                           [ linux  9.25MiB  100%  6.66MiB/s ]
> initrd: [15bcbe000,15dffffbb]
> initrd: 1 file done             [ initrd.img  35.26MiB  100%  11.93MiB/s ]
> early console in decompress_kernel
> decompress_kernel:
>   input: [0x15fd0b3b4-0x16063c803], output: 0x15e000000, heap: [0x160645b00-0x16064daff]
> 
> Decompressing Linux... xz... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] bootconsole [uart0] enabled
> [    0.000000]    real_mode_data :      phys 00000001618fc000
> [    0.000000]    real_mode_data :      virt ffff8801618fc000
> [    0.000000] Kernel Layout:
> [    0.000000]   .text: [0x15e000000-0x15f08f72c]
> [    0.000000] .rodata: [0x15f200000-0x15fa44fff]
> [    0.000000]   .data: [0x15fc00000-0x15fe545ff]
> [    0.000000]   .init: [0x15fe56000-0x16021afff]
> [    0.000000]    .bss: [0x160229000-0x16135ffff]
> [    0.000000]    .brk: [0x161360000-0x161385fff]
> [    0.000000] memblock_reserve: [0x0000000009f000-0x000000000fffff] flags 0x0 * BIOS reserved
> ...
> [    0.000000] memblock_reserve: [0x0000015e000000-0x0000016135ffff] flags 0x0 TEXT DATA BSS
> [    0.000000] memblock_reserve: [0x0000015bcbe000-0x0000015dffffff] flags 0x0 RAMDISK
> 
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  Documentation/x86/boot.txt            |   18 ++++++++++++++++++
>  arch/x86/boot/compressed/eboot.c      |   15 ++++++++++-----
>  arch/x86/boot/compressed/head_64.S    |    7 ++++++-
>  arch/x86/boot/header.S                |    3 ++-
>  arch/x86/include/uapi/asm/bootparam.h |    1 +
>  arch/x86/kernel/asm-offsets.c         |    1 +
>  6 files changed, 38 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/uapi/asm/bootparam.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/uapi/asm/bootparam.h
> +++ linux-2.6/arch/x86/include/uapi/asm/bootparam.h
> @@ -83,6 +83,7 @@ struct setup_header {
>  	__u64	pref_address;
>  	__u32	init_size;
>  	__u32	handover_offset;
> +	__u32	ext_code32_start;
>  } __attribute__((packed));
>  
>  struct sys_desc_table {
> Index: linux-2.6/arch/x86/kernel/asm-offsets.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/asm-offsets.c
> +++ linux-2.6/arch/x86/kernel/asm-offsets.c
> @@ -68,6 +68,7 @@ void common(void) {
>  	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
>  	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
>  	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
> +	OFFSET(BP_ext_code32_start, boot_params, hdr.ext_code32_start);
>  
>  	BLANK();
>  	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
> Index: linux-2.6/arch/x86/boot/compressed/head_64.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/head_64.S
> +++ linux-2.6/arch/x86/boot/compressed/head_64.S
> @@ -263,6 +263,8 @@ ENTRY(efi_pe_entry)
>  	mov	%rax, %rsi
>  	leaq	startup_32(%rip), %rax
>  	movl	%eax, BP_code32_start(%rsi)
> +	shr	$32, %rax
> +	movl	%eax, BP_ext_code32_start(%rsi)
>  	jmp	2f		/* Skip the relocation */
>  
>  handover_entry:
> @@ -286,7 +288,10 @@ fail:
>  	hlt
>  	jmp	fail
>  2:
> -	movl	BP_code32_start(%esi), %eax
> +	movl	BP_code32_start(%rsi), %eax
> +	movl	BP_ext_code32_start(%rsi), %ebx
> +	shl	$32, %rbx
> +	orq	%rbx, %rax
>  	leaq	preferred_addr(%rax), %rax
>  	jmp	*%rax
>  
> Index: linux-2.6/arch/x86/boot/compressed/eboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
> +++ linux-2.6/arch/x86/boot/compressed/eboot.c
> @@ -1389,6 +1389,7 @@ struct boot_params *efi_main(struct efi_
>  	void *handle;
>  	efi_system_table_t *_table;
>  	bool is64;
> +	unsigned long loaded_addr;
>  
>  	efi_early = c;
>  
> @@ -1430,9 +1431,12 @@ struct boot_params *efi_main(struct efi_
>  	 * If the kernel isn't already loaded at the preferred load
>  	 * address, relocate it.
>  	 */
> -	if (hdr->pref_address != hdr->code32_start) {
> -		unsigned long bzimage_addr = hdr->code32_start;
> -		status = efi_relocate_kernel(sys_table, &bzimage_addr,
> +	loaded_addr = hdr->code32_start;
> +	loaded_addr |= (unsigned long)hdr->ext_code32_start << 32;
> +	if (hdr->pref_address != loaded_addr) {
> +		unsigned long loaded_addr_orig = loaded_addr;
> +
> +		status = efi_relocate_kernel(sys_table, &loaded_addr,
>  					     hdr->init_size, hdr->init_size,
>  					     hdr->pref_address,
>  					     hdr->kernel_alignment);
> @@ -1441,8 +1445,9 @@ struct boot_params *efi_main(struct efi_
>  			goto fail;
>  		}
>  
> -		hdr->pref_address = hdr->code32_start;
> -		hdr->code32_start = bzimage_addr;
> +		hdr->pref_address = loaded_addr_orig;
> +		hdr->code32_start = loaded_addr & 0xffffffff;
> +		hdr->ext_code32_start = loaded_addr >> 32;
>  	}
>  
>  	status = exit_boot(boot_params, handle, is64);
> Index: linux-2.6/arch/x86/boot/header.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/header.S
> +++ linux-2.6/arch/x86/boot/header.S
> @@ -301,7 +301,7 @@ _start:
>  	# Part 2 of the header, from the old setup.S
>  
>  		.ascii	"HdrS"		# header signature
> -		.word	0x020d		# header version number (>= 0x0105)
> +		.word	0x020e		# header version number (>= 0x0105)
>  					# or else old loadlin-1.5 will fail)
>  		.globl realmode_swtch
>  realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
> @@ -449,6 +449,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
>  #endif
>  init_size:		.long INIT_SIZE		# kernel initialization size
>  handover_offset:	.long 0			# Filled in by build.c
> +ext_code32_start:	.long 0			# werid one!
>  
>  # End of setup header #####################################################
>  
> Index: linux-2.6/Documentation/x86/boot.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/x86/boot.txt
> +++ linux-2.6/Documentation/x86/boot.txt
> @@ -61,6 +61,9 @@ Protocol 2.12:	(Kernel 3.8) Added the xl
>  	 	to struct boot_params for loading bzImage and ramdisk
>  		above 4G in 64bit.
>  
> +Protocol 2.14:	(Kernel 3.20) Added the ext_code32_start to support EFI64
> +		to be loaded above 4G.
> +
>  **** MEMORY LAYOUT
>  
>  The traditional memory map for the kernel loader, used for Image or
> @@ -197,6 +200,7 @@ Offset	Proto	Name		Meaning
>  0258/8	2.10+	pref_address	Preferred loading address
>  0260/4	2.10+	init_size	Linear memory required during initialization
>  0264/4	2.11+	handover_offset	Offset of handover entry point
> +0268/4	2.14+	ext_code32_start	Extended part for code32_start
>  
>  (1) For backwards compatibility, if the setup_sects field contains 0, the
>      real value is 4.
> @@ -738,6 +742,13 @@ Offset/size:	0x264/4
>  
>    See EFI HANDOVER PROTOCOL below for more details.
>  
> +Field name:	ext_code32_start
> +Type:		modify (optional, reloc)
> +Offset/size:	0x268/4
> +Protocol:	2.14+
> +
> +  The address is used with code32_start to compare pref_address
> +  to support EFI 64bit kernel get loaded above 4G.
>  
>  **** THE IMAGE CHECKSUM
>  
> @@ -1122,4 +1133,11 @@ The boot loader *must* fill out the foll
>      o hdr.ramdisk_image (if applicable)
>      o hdr.ramdisk_size  (if applicable)
>  
> +for 64bit, when loading above 4G, *must* fill out the following fields,
> +
> +    o hdr.ext_code32_start
> +    o ext_cmd_line_ptr
> +    o ext_ramdisk_image (if applicable)
> +    o ext_ramdisk_size  (if applicable)
> +
>  All other fields should be zero.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
