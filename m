From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Wed, 06 Mar 2013 13:38:06 +0000
Message-ID: <1362577086.15011.57.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362571097.7004.66.camel@par-r81vxc7.par.novell.com>
	 <1362573401.15011.48.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362576633.7004.69.camel@par-r81vxc7.par.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362576633.7004.69.camel-+GqLY1utCe+GwbuyVWskRBLdbW0B08c60E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-06 at 14:30 +0100, Frederic Crozat wrote:
> Le mercredi 06 mars 2013 =C3=A0 12:36 +0000, Matt Fleming a =C3=A9cri=
t :
> > On Wed, 2013-03-06 at 12:58 +0100, Frederic Crozat wrote:
> > > Le mercredi 06 mars 2013 =C3=A0 11:19 +0000, Matt Fleming a =C3=A9=
crit :
> > >=20
> > > > Also, which machine did you see this behaviour on?
> > >=20
> > > HP z220 desktop, System BIOS K51 v 1.54
> > >=20
> > > this issue is only the "Secure Boot" related variables, which mak=
e me
> > > think HP incorrectly created them in their latest firmware (where=
 they
> > > added Windows 8 support).
> >=20
> > Are you saying that the behaviour regarding VariableNameSize change=
s
> > depending on which variable is returned?
> >
> > Mercy.....
> =20
> Well, I only get the error message for some variables (8), not all of
> them.
>=20
> It was quite visible on unpatched kernel, with ls
> -d /sys/firmware/efi/vars.=20
>=20
> ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
> /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
> /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
> /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-0=
0e098032b8c
> /sys/firmware/efi/vars/SignatureSupport-pport8be4df61-93ca-11d2-aa0d-=
00e098032b8c
> /sys/firmware/efi/vars/VendorKeys-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
>=20
> All other variable names were fine.

Interesting. Thanks.

--=20
Matt Fleming, Intel Open Source Technology Center
