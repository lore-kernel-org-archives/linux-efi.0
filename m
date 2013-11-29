From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Sat, 30 Nov 2013 06:04:07 +0800
Message-ID: <1385762647.3539.4.camel@linux-s257.site>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385754283-2464-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matthew,=20

=E6=96=BC =E4=BA=94=EF=BC=8C2013-11-29 =E6=96=BC 14:44 -0500=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
>=20
> UEFI time services are often broken once we're in virtual mode. We
> were
> already refusing to use them on 64-bit systems, but it turns out that
> they're also broken on some 32-bit firmware, including the Dell Venue=
=2E
> Disable them for now, we can revisit once we have the 1:1 mappings
> code
> incorporated.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org=20

Does there have chance to test Borislav's EFI runtime mapping work on
Dell Venue?

Borislav's patches here:
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi

I am sure his patchset can walkaround physical address accessing issue
on a broken 64-bit machine. But, I didn't test it on 32-bit issue
machine.


Thanks a lot!
Joey Lee
