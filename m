From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/3 v2] Add function get_bootparam
Date: Tue, 12 Nov 2013 00:30:12 -0800
Message-ID: <20131112083012.GB7708@kroah.com>
References: <20131105082947.500512312@dhcp-16-126.nay.redhat.com>
 <20131105083428.411624560@dhcp-16-126.nay.redhat.com>
 <1384219658.1847.84.camel@misato.fc.hp.com>
 <52819E71.70201@zytor.com>
 <20131112075831.GA6213@kroah.com>
 <20131112080854.GD6999@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131112080854.GD6999-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 04:08:54PM +0800, Dave Young wrote:
> On 11/11/13 at 11:58pm, Greg KH wrote:
> > > kexec-tools can have a fallback to debugfs if we really need it, =
but
> > > making people mount debugfs to have some essential piece of
> > > functionality scares the heck out of me.
> >=20
> > I agree, that would not be good.
> >=20
> > I'm not sure what exactly the sysfs file is wanting to look like?  =
The
> > efi section variable sysfs file isn't ok (multiple lines with multi=
ple
> > values.)  What is this going to look like?
>=20
> The current structure in debugfs is like below, export every field of=
 setup
> header as one file will be too much IMHO:
> [root@darkstar debug]# tree boot_params
> boot_params
> =E2=94=9C=E2=94=80=E2=94=80 data /* binary data of setup header */
> =E2=94=9C=E2=94=80=E2=94=80 setup_data /* setup_data link list nodes =
*/
> =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 0
> =E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80=
 data /* binary data of setup data */
> =E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80=
 type /* type of setup data */
> =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 1
> =E2=94=82=C2=A0=C2=A0     =E2=94=9C=E2=94=80=E2=94=80 data
> =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 type
> =E2=94=94=E2=94=80=E2=94=80 version /* boot protocol version */

And these binary data blobs are a "standard" somewhere, and will not
change per kernel version change?

If so, that structure is fine with me.

thanks,

greg k-h
