From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: UEFI Secure boot lockdown patchset
Date: Thu, 1 Mar 2018 23:15:11 +1100
Message-ID: <20180301231511.4dd1e79f@canb.auug.org.au>
References: <26787.1519902415@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4==S0+IHk4B=DVeUSOUGCCI"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26787.1519902415@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, jforbes@redhat.com, mjg59@google.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-efi@vger.kernel.org

--Sig_/4==S0+IHk4B=DVeUSOUGCCI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, 01 Mar 2018 11:06:55 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Can you pull the following branch into linux-next please?  It does three
> things:
>=20
>  (1) It restricts various accesses userspace may make upon the kernel whe=
n the
>      kernel is locked down.
>=20
>  (2) It engages the lockdown if UEFI Secure Boot mode is detected.
>=20
>  (3) It passes the UEFI Secure Boot mode indication across kexec.
>=20
> The restrictions include:
>=20
>  - Enforcing the use of module signatures
>  - Enforcing the use of kexec image signatures
>  - Requring IMA to use secure boot rules
>  - Disabling:
>    - The kexec_load() syscall
>    - Use of /dev/{mem,kmem,port,kcore}
>    - Hibernation
>    - PCI BAR access
>    - Direct I/O port access
>  - Preventing direct port specification in drivers:
>    - SCSI EATA
>    - TIOCSSERIAL
>    - Module parameters
>  - Restricting:
>    - MSR access
>    - Certain ACPI features
>    - kprobes
>    - BPF
>    - Perf
>    - Debugfs
>=20
> The aim of the restrictions is twofold:
>=20
>   (1) Prevent userspace from altering the kernel image directly (eg. by
>       /dev/mem) or indirectly (eg. by manipulating a device to do DMA);
>=20
>   (2) Prevent userspace from accessing crypto data stored in the kernel
>       (eg. filesystem keys).
>=20
> A warning is logged if a restriction is triggered for which I've written a
> manpage that is referenced in the message (see attached).

Added from tomorrow.  I actually used this url:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git#efi-l=
ock-down

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/4==S0+IHk4B=DVeUSOUGCCI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlqX7s8ACgkQAVBC80lX
0GxxiAf/fVZB9wRNZSPSOiTYZ7yUkUKgnGzIoKURgobYx+FmY8UIvKIMoq75km5T
aeeG0HKenRwxAWSxPvVb0fsGtPOLTCAaltB1kWXLHZbAKL8LDAgA8Nz69D7oh+dw
1YtBQkjAz7uyZjUGvQTSeH2jaSCw5tgvdn/hZoI1c9+X68Ululdacw/VKc4T/i46
H7qpgn3SalPcfz1UHqeFYbt2lDKZPnYuqxZ2Tcmb3gBlc71O64VCLndds2IwDZ1p
3xP7zv58Z54LHx69tbdI8LzwTItbL4DF66CGP5eYhUdZNlww1TZvOF7fG4+BbSqR
jl+SWSAVV99QPh7KEPX74slCfyPj1w==
=vg3S
-----END PGP SIGNATURE-----

--Sig_/4==S0+IHk4B=DVeUSOUGCCI--
