From: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Fri, 22 Aug 2014 16:24:34 +0200
Message-ID: <53F752A2.7080604@redhat.com>
References: <53E62EEF.9040801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E62EEF.9040801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09.08.2014 16:23, Mantas Mikul=C4=97nas wrote:
> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G")=
,
> the kernel freezes at the earliest possible moment when trying to boo=
t
> via UEFI on my Asus laptop. (It still boots via BIOS.)
>=20
> If I revert that commit on current master (c309bfa9b481), it boots
> correctly again [although I see "setup_efi_pci() failed" being printe=
d].
>=20
> (Seems like it freezes when handle_cmdline_files() attempts to read
> the last chunk of the initramfs -- the last call to efi_file_read()
> never returns. Figuring out why that happens is beyond me, though.)
>=20

I fixed my issue with: https://lkml.org/lkml/2014/8/22/232

Care to test?
