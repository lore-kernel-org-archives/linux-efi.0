From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/6] x86/efi: use efi_memory_descriptor in convenience
 functions
Date: Fri, 19 Sep 2014 12:04:12 +0100
Message-ID: <20140919110412.GF18635@console-pimps.org>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410633376-8822-3-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 13 Sep, at 11:36:12AM, Ricardo Neri wrote:
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 64ecbb5..29c85fe 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -206,29 +206,23 @@ subsys_initcall(efisubsys_init);
>   */
>  void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
>  {
> -	struct efi_memory_map *map;
> -	void *p;
> -	map =3D efi.memmap;
> -	if (!map)
> +	efi_memory_desc_t *md;
> +
> +	md =3D efi_memory_descriptor(phys_addr);

Whoops. This change is causing the following build errors on ia64,

/home/build/git/efi/arch/ia64/kernel/efi.c:722:1: error: static declara=
tion of =E2=80=98efi_memory_descriptor=E2=80=99 follows non-static decl=
aration
 efi_memory_descriptor (unsigned long phys_addr)
 ^
In file included from /home/build/git/efi/arch/ia64/kernel/efi.c:32:0:
/home/build/git/efi/include/linux/efi.h:870:27: note: previous declarat=
ion of =E2=80=98efi_memory_descriptor=E2=80=99 was here
 extern efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_add=
r);
                           ^

and on arm64...

drivers/built-in.o: In function `efi_lookup_mapped_addr':
:(.text+0xb0e0): undefined reference to `efi_memory_descriptor'

--=20
Matt Fleming, Intel Open Source Technology Center
