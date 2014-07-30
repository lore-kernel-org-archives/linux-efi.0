From: Luis Henriques <luis.henriques-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efi: Include a .bss section within the PE/COFF headers
Date: Wed, 30 Jul 2014 14:57:51 +0100
Message-ID: <20140730135751.GC7239@hercules>
References: <1406553713-7479-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406553713-7479-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 28, 2014 at 02:21:53PM +0100, Michael Brown wrote:
> commit c7fb93ec51d462ec3540a729ba446663c26a0505 upstream
>

Thanks, I'll use this backport for the 3.11 kernel as well.

Cheers,
--
Lu=EDs

> The PE/COFF headers currently describe only the initialised-data
> portions of the image, and result in no space being allocated for the
> uninitialised-data portions.  Consequently, the EFI boot stub will en=
d
> up overwriting unexpected areas of memory, with unpredictable results=
=2E
>=20
> Fix by including a .bss section in the PE/COFF headers (functionally
> equivalent to the init_size field in the bzImage header).
>=20
> Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/boot/header.S      | 26 ++++++++++++++++++++++----
>  arch/x86/boot/tools/build.c | 37 ++++++++++++++++++++++++++++++-----=
--
>  2 files changed, 52 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index ec3b8ba..04da6c2 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -91,10 +91,9 @@ bs_die:
> =20
>  	.section ".bsdata", "a"
>  bugger_off_msg:
> -	.ascii	"Direct floppy boot is not supported. "
> -	.ascii	"Use a boot loader program instead.\r\n"
> +	.ascii	"Use a boot loader.\r\n"
>  	.ascii	"\n"
> -	.ascii	"Remove disk and press any key to reboot ...\r\n"
> +	.ascii	"Remove disk and press any key to reboot...\r\n"
>  	.byte	0
> =20
>  #ifdef CONFIG_EFI_STUB
> @@ -108,7 +107,7 @@ coff_header:
>  #else
>  	.word	0x8664				# x86-64
>  #endif
> -	.word	3				# nr_sections
> +	.word	4				# nr_sections
>  	.long	0 				# TimeDateStamp
>  	.long	0				# PointerToSymbolTable
>  	.long	1				# NumberOfSymbols
> @@ -250,6 +249,25 @@ section_table:
>  	.word	0				# NumberOfLineNumbers
>  	.long	0x60500020			# Characteristics (section flags)
> =20
> +	#
> +	# The offset & size fields are filled in by build.c.
> +	#
> +	.ascii	".bss"
> +	.byte	0
> +	.byte	0
> +	.byte	0
> +	.byte	0
> +	.long	0
> +	.long	0x0
> +	.long	0				# Size of initialized data
> +						# on disk
> +	.long	0x0
> +	.long	0				# PointerToRelocations
> +	.long	0				# PointerToLineNumbers
> +	.word	0				# NumberOfRelocations
> +	.word	0				# NumberOfLineNumbers
> +	.long	0xc8000080			# Characteristics (section flags)
> +
>  #endif /* CONFIG_EFI_STUB */
> =20
>  	# Kernel attributes; used by setup.  This is part 1 of the
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.=
c
> index 8e15b22..3dafaeb 100644
> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -142,7 +142,7 @@ static void usage(void)
> =20
>  #ifdef CONFIG_EFI_STUB
> =20
> -static void update_pecoff_section_header(char *section_name, u32 off=
set, u32 size)
> +static void update_pecoff_section_header_fields(char *section_name, =
u32 vma, u32 size, u32 datasz, u32 offset)
>  {
>  	unsigned int pe_header;
>  	unsigned short num_sections;
> @@ -163,10 +163,10 @@ static void update_pecoff_section_header(char *=
section_name, u32 offset, u32 siz
>  			put_unaligned_le32(size, section + 0x8);
> =20
>  			/* section header vma field */
> -			put_unaligned_le32(offset, section + 0xc);
> +			put_unaligned_le32(vma, section + 0xc);
> =20
>  			/* section header 'size of initialised data' field */
> -			put_unaligned_le32(size, section + 0x10);
> +			put_unaligned_le32(datasz, section + 0x10);
> =20
>  			/* section header 'file offset' field */
>  			put_unaligned_le32(offset, section + 0x14);
> @@ -178,6 +178,11 @@ static void update_pecoff_section_header(char *s=
ection_name, u32 offset, u32 siz
>  	}
>  }
> =20
> +static void update_pecoff_section_header(char *section_name, u32 off=
set, u32 size)
> +{
> +	update_pecoff_section_header_fields(section_name, offset, size, siz=
e, offset);
> +}
> +
>  static void update_pecoff_setup_and_reloc(unsigned int size)
>  {
>  	u32 setup_offset =3D 0x200;
> @@ -202,9 +207,6 @@ static void update_pecoff_text(unsigned int text_=
start, unsigned int file_sz)
> =20
>  	pe_header =3D get_unaligned_le32(&buf[0x3c]);
> =20
> -	/* Size of image */
> -	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
> -
>  	/*
>  	 * Size of code: Subtract the size of the first sector (512 bytes)
>  	 * which includes the header.
> @@ -219,6 +221,22 @@ static void update_pecoff_text(unsigned int text=
_start, unsigned int file_sz)
>  	update_pecoff_section_header(".text", text_start, text_sz);
>  }
> =20
> +static void update_pecoff_bss(unsigned int file_sz, unsigned int ini=
t_sz)
> +{
> +	unsigned int pe_header;
> +	unsigned int bss_sz =3D init_sz - file_sz;
> +
> +	pe_header =3D get_unaligned_le32(&buf[0x3c]);
> +
> +	/* Size of uninitialized data */
> +	put_unaligned_le32(bss_sz, &buf[pe_header + 0x24]);
> +
> +	/* Size of image */
> +	put_unaligned_le32(init_sz, &buf[pe_header + 0x50]);
> +
> +	update_pecoff_section_header_fields(".bss", file_sz, bss_sz, 0, 0);
> +}
> +
>  #endif /* CONFIG_EFI_STUB */
> =20
> =20
> @@ -270,6 +288,9 @@ int main(int argc, char ** argv)
>  	int fd;
>  	void *kernel;
>  	u32 crc =3D 0xffffffffUL;
> +#ifdef CONFIG_EFI_STUB
> +	unsigned int init_sz;
> +#endif
> =20
>  	/* Defaults for old kernel */
>  #ifdef CONFIG_X86_32
> @@ -343,7 +364,9 @@ int main(int argc, char ** argv)
>  	put_unaligned_le32(sys_size, &buf[0x1f4]);
> =20
>  #ifdef CONFIG_EFI_STUB
> -	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) -=
 sz));
> +	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
> +	init_sz =3D get_unaligned_le32(&buf[0x260]);
> +	update_pecoff_bss(i + (sys_size * 16), init_sz);
> =20
>  #ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
>  	efi_stub_entry -=3D 0x200;
> --=20
> 1.8.4.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
