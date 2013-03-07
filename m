From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Thu, 07 Mar 2013 22:03:33 +0800
Message-ID: <1362665013.28562.48.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362664663.15011.194.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,=20

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-03-07 =E6=96=BC 13:57 +0000=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 2013-03-07 at 11:39 +0000, Matt Fleming wrote:
> > On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> > > The VariableNameSize is not reliable when EFI_SUCCESS is returned
> > > because UEFI 2.3.1 spec only mention VariableNameSize should upda=
ted
> > > when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buf=
fer is
> > > from old UEFI spec. There doesn't have any size condition of vari=
able
> > > data or variable name in 2.3.1 spec.
> >=20
> > The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL =
case,
> > but for EFI_SUCCESS, any behaviour other than leaving VariableNameS=
ize
> > alone or updating it with the required size of the buffer is just
> > completely insane.
> >=20
> > > I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO=
_SMALL,
> > > the behavior like what we do in efivarfs_file_read().
> >=20
> > Thanks, this does seem like the most robust solution.
>=20
> Also, you're probably going to need to update
> efivar_update_sysfs_entries() too.
>=20

Thanks for your review! I will send out v2 patch after modify and test
on issue machine.


Thanks a lot!
Joey Lee
