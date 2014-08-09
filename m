From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Loading initrd above 4G causes freeze on boot
Date: Sat, 09 Aug 2014 17:23:43 +0300
Message-ID: <53E62EEF.9040801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
the kernel freezes at the earliest possible moment when trying to boot
via UEFI on my Asus laptop. (It still boots via BIOS.)

If I revert that commit on current master (c309bfa9b481), it boots
correctly again [although I see "setup_efi_pci() failed" being printed]=
=2E

(Seems like it freezes when handle_cmdline_files() attempts to read
the last chunk of the initramfs -- the last call to efi_file_read()
never returns. Figuring out why that happens is beyond me, though.)

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
