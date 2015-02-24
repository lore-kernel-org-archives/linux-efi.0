From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86, boot: Allow 64bit EFI kernel to be loaded above
 4G
Date: Tue, 24 Feb 2015 21:55:01 +0000
Message-ID: <20150224215501.GB9758@codeblueprint.co.uk>
References: <1424663028-13066-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424663028-13066-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 22 Feb, at 07:43:48PM, Yinghai Lu wrote:
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
  
How about a comment like, "# Upper 32-bits of code32_start" ?

> Index: linux-2.6/Documentation/x86/boot.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/x86/boot.txt
> +++ linux-2.6/Documentation/x86/boot.txt
> @@ -61,6 +61,9 @@ Protocol 2.12:	(Kernel 3.8) Added the xl
>  	 	to struct boot_params for loading bzImage and ramdisk
>  		above 4G in 64bit.
>  
> +Protocol 2.14:	(Kernel 3.20) Added the ext_code32_start to support 64bit
> +		EFI kernel to be loaded above 4G.
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
> @@ -738,6 +742,14 @@ Offset/size:	0x264/4
>  
>    See EFI HANDOVER PROTOCOL below for more details.
>  
> +Field name:	ext_code32_start
> +Type:		modify (optional, reloc)
> +Offset/size:	0x268/4
> +Protocol:	2.14+
> +
> +  This field is the upper 32bits of load address when EFI 64bit kernel
> +  is loaded above 4G. And it is used with code32_start to compare to
> +  pref_address to decide if kernel need to be relocated further.

I think we can delete the second sentence.

But these are minimal changes and I'm happy to fix them up when applying
this patch if that's OK?

-- 
Matt Fleming, Intel Open Source Technology Center
