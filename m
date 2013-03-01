From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Fri, 01 Mar 2013 22:49:35 +0800
Message-ID: <1362149375.23932.167.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <5130757F.4090702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5130757F.4090702-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-03-01 =E6=96=BC 17:31 +0800=EF=BC=8CLi=
ngzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> On 03/01/2013 11:20 AM, Lee, Chun-Yi wrote:
> > From: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
> >=20
> > On HP z220 system (firmware version 1.54), some EFI variables are i=
ncorrectly
> > named :
> >=20
> > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d=
-00e098032b8c
> >=20
> > That causes by the following statement in efivar_create_sysfs_entry=
 function:
> >=20
> >   *(short_name + strlen(short_name)) =3D '-';
> > efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> >=20
> > The trailing \0 is overwritten with '-', but the next char doesn't =
seem to be a \0
> > as well for HP. So, the second strlen return the point of next '\0'=
, causes there
> > have garbage string attached before GUID.
> >=20
> > Tested on On HP z220.
>=20
> So short_name has trailing garbage, or rather, variable_name_size
> is larger than variable_name actually is, wouldn't new_efivar->var.Va=
riableName
> also gets filled with trailing garbage?
>=20
> In efivar_store_raw the VariableName's trailing garbage can cause
> problem for comparison. You might want to also cover that or fix
> variable_name_size.
>=20
>=20
> Lingzhu Xiang
>=20

Yes, it's possible! I will add patch for print more debug messages to
bug reporter for check it.


Thanks for your review!
Joey Lee
