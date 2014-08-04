From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Mon, 4 Aug 2014 13:27:28 +0100
Message-ID: <20140804122728.GH15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140804113435.34ed8c76@pluto>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: P J P <ppandit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 04 Aug, at 11:34:35AM, Bruno Pr=E9mont wrote:
> Hi,
>=20
> Since 3.13 kernels with built-in initrd fail to boot on Fujitsu hardw=
are
> in EFI mode (efi stub) though the exact same kernel binary does boot =
in
> BIOS mode (grub).
> Interestingly EFI kernels with different config do boot under VMWare.
>=20
> Your patch "initramfs: read CONFIG_RD_ variables for initramfs
> compression" is the trigger.
>=20
>=20
> Is something missing in EFI stub or why do things behave differently?
=20
Nuts. I suspect it's an EFI boot stub bug. Have you definitely tried ou=
t
3.16? In particular the following commit might make a difference,

  commit c7fb93ec51d4
  Author: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
  Date:   Thu Jul 10 12:26:20 2014 +0100

      x86/efi: Include a .bss section within the PE/COFF headers
   =20
      The PE/COFF headers currently describe only the initialised-data
      portions of the image, and result in no space being allocated for=
 the
      uninitialised-data portions.  Consequently, the EFI boot stub wil=
l end
      up overwriting unexpected areas of memory, with unpredictable res=
ults.
   =20
      Fix by including a .bss section in the PE/COFF headers (functiona=
lly
      equivalent to the init_size field in the bzImage header).
   =20
      Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
      Cc: Thomas B=E4chler <thomas-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
      Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
      Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
      Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


> Looking at compiled kernel with and without this patch the resulting
> bzImage is similar in size but in build directory I get:

Could you send me the initrd image? I'd like to try and reproduce this
on my end, even though I regularly boot with a built-in initrd.

--=20
Matt Fleming, Intel Open Source Technology Center
