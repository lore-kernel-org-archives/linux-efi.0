From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Wed, 06 Mar 2013 15:39:49 +0800
Message-ID: <1362555589.23932.582.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362555258.23932.573.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-03-06 =E6=96=BC 15:34 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi Matt,=20
>=20
> =E6=96=BC =E5=85=AD=EF=BC=8C2013-03-02 =E6=96=BC 07:41 +0800=EF=BC=8C=
joeyli =E6=8F=90=E5=88=B0=EF=BC=9A
> > =E6=96=BC =E4=BA=94=EF=BC=8C2013-03-01 =E6=96=BC 16:31 +0000=EF=BC=8C=
Matt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> > > On Fri, 2013-03-01 at 15:17 +0000, Matt Fleming wrote:
> > > > On Fri, 2013-03-01 at 11:20 +0800, Lee, Chun-Yi wrote:
> > > > > From: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
> > > > >=20
> > > > > On HP z220 system (firmware version 1.54), some EFI variables
> are incorrectly
> > > > > named :
> > > > >=20
> > > > > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be return=
s
> > > >
> > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > > >
> > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > > >
> > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e0=
98032b8c
> > > >
> > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d=
-00e098032b8c
> > > > >=20
> > > > > That causes by the following statement in
> efivar_create_sysfs_entry function:
> > > > >=20
> > > > >  *(short_name + strlen(short_name)) =3D '-';
> > > > > efi_guid_unparse(vendor_guid, short_name +
> strlen(short_name));
> > > > >=20
> > > > > The trailing \0 is overwritten with '-', but the next char
> doesn't seem to be a \0
> > > > > as well for HP. So, the second strlen return the point of nex=
t
> '\0', causes there
> > > > > have garbage string attached before GUID.
> > > > >=20
> > > > > Tested on On HP z220.
> > > >=20
> > > > What's more likely happening here is that GetNextVariable() is
> broken on
> > > > this HP firmware and variable_name_size is too big for the give=
n
> > > > variable in variable_name. We've seen other reports of similar
> bugs,
> > > >=20
> > > >   https://bugzilla.kernel.org/show_bug.cgi?id=3D47631
> > > >=20
> > > >=20
> > > > Could someone try this patch against Linus' tree?
> > >=20
> > > Urgh, and here's a version that isn't utterly, utterly broken...
> >=20
> > Thanks for Matt's patch, we will try it!
> >=20
> > Joey Lee
>=20
> Frederic confirmed your patch works to him for fix issue on HP
> machine.
>=20
> Tested-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>

Sorry forgot paste variable_name_size from log:

efivars: bogus variable_name_size: 34 1024
efivars: bogus variable_name_size: 22 1024

The GetNextVariable() always return variable_name_size is 1024.


Thanks a lot!
Joey Lee
