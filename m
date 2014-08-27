From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Wed, 27 Aug 2014 11:59:01 +0100
Message-ID: <20140827105901.GC28116@console-pimps.org>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409089544-24221-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Aug, at 02:45:44PM, Yinghai Lu wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
>=20
> There are buggy EFI implementations: with EFI run time, kernel need
> to load file with 512bytes alignment when buffer is above 4G.
>=20
> So revert to old way to load initrd on first try,
> second try will use above 4G buffer when initrd is more than
> 2G and does not fit under 4G.
>=20
> Reported-by: Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> ---
>  arch/x86/boot/compressed/eboot.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

The reason I suggested introducing some kind of kernel parameter to
allow loading above 4G is because if Mantas loads a 5GB initrd with you=
r
patch, his machine is still going to hang, with no indication of why it
hung.

At least with a kernel paramter, by default we can try to load under 4G=
,
and if that fails because the file is too big we can print something
along the lines of,

  "initramfs file too large: try booting with efi=3Dfile-max"

No, it's not ideal, but I think it's a worthwhile compromise because
you're only going to run into this issue when loading a huge initramfs
with the EFI boot stub.

If instead you're using Grub or Syslinux (and the EFI handover protocol=
)
it's a non-issue because both of those boot loaders carry FAT drivers
and use EFI_BLOCK_IO_PROTOCOL which doesn't trigger the firmware bug.

It's only because we don't have a FAT driver in the EFI boot stub and
have to resort to using EFI_FILE_PROTOCOL that we've encountered this
problem at all.

--=20
Matt Fleming, Intel Open Source Technology Center
