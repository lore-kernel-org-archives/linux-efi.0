From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 20 Aug 2014 21:30:11 +0100
Message-ID: <20140820203011.GH29733@console-pimps.org>
References: <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
 <20140813140219.GP15082@console-pimps.org>
 <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
 <20140813184449.GV15082@console-pimps.org>
 <20140820170520.GF29733@console-pimps.org>
 <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
 <53F4FCC9.1030405@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53F4FCC9.1030405-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-efi@vger.kernel.org

[ Pulling in EDK2 folks for help ]

On Wed, 20 Aug, at 08:53:45PM, Michael Brown wrote:
> On 20/08/14 20:05, Mantas Mikul=C4=97nas wrote:
> >
> >I experimented with some things (like setting chunk size to a few kB
> >to see if it hangs earlier or only at the very end; etc.), and final=
ly
> >found out that it stops freezing if I pad the initrd file to a
> >multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
> >bytes will not.
> >
> >...In other words, seems like it cannot read chunks that aren't
> >multiples of 512 into a location above 4 GB. Or something like that.=
=2E.
>=20
> I haven't been following this thread closely, but that immediately
> sounds like a problem within the EFI_DISK_IO_PROTOCOL implementation
> (which is responsible for handling smaller-than-block-sized reads).
> Looking at the EDK2 implementation in
> MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIo.c, the memory
> management does appear to be somewhat inventive.  In particular,
> there's a frequent pattern in DiskIoCreateSubtaskList() equivalent
> to:
>=20
>   if ( blocking_io ) {
>      buffer =3D some_static_buffer;
>   } else {
>      buffer =3D malloc ( len );
>      if ( ! buffer )
>         goto single_shared_error_label;
>   }
>   ... do not record whether or not buffer was dynamically allocated .=
=2E.
>   ... use buffer as part of an asynchronous I/O operation ...
>   ... eventually choose whether or not to free buffer, and hope the
> choice is correct ...
>=20
> It's not at all obvious that memory is freed correctly, especially
> under some of the error paths within that code.
>=20
> I can't immediately see anything that should fail with a pointer
> above 4G, but I wouldn't be surprised to find a path that causes a
> double free or similar error.

Guys, the original thread starts here,

  http://article.gmane.org/gmane.linux.kernel.efi/4424

Basically, reading into a buffer above 0xffffffff using
EFI_FILE_PROTOCOL causes Mantas' machine to crash, irrespective of the
size of the read.

Is this a known issue? Perhaps here be dragons?

Halp?

--=20
Matt Fleming, Intel Open Source Technology Center
