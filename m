From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
Date: Tue, 14 May 2013 12:36:37 +0800
Message-ID: <1368506197.21417.172.camel@linux-s257.site>
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
	 <51913D4B.2000606@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51913D4B.2000606@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, Andy Whitcroft <apw@canonical.com>
List-Id: linux-efi@vger.kernel.org

Hi Matt,=20

=E6=96=BC =E4=B8=80=EF=BC=8C2013-05-13 =E6=96=BC 20:21 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On 05/10/2013 11:29 AM, Lingzhu Xiang wrote:
> > Previously in 1fa7e69 efi_status_to_err() translated firmware statu=
s
> > EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
> > avoid confusion. After refactoring in e14ab23, it is also used in o=
ther
> > places where the translation may be unnecessary.
> >=20
> > So move the translation to efivarfs specific code. Also return EOF
> > for reading zero-length files, which is what users would expect.
> >=20
> > Cc: Josh Boyer <jwboyer@redhat.com>
> > Cc: Jeremy Kerr <jk@ozlabs.org>
> > Cc: Lee, Chun-Yi <jlee@suse.com>
> > Cc: Andy Whitcroft <apw@canonical.com>
> > Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
> > ---
> > This is to be applied against mainline or Matt Fleming's chainsaw b=
ranch.
>=20
> Applied, thanks.
>=20
> FYI, I rebased my 'urgent' branch on v3.10-rc1, so your patch now
> applies there too.
>=20
>=20

I found the "[PATCH] x86, efi: initial the local variable of DataSize t=
o
zero" lost in urgent branch, and it also didn't in Linus's v3.10-rc1.

Did this patch move to other branch?


Thanks a lot!
Joey Lee
