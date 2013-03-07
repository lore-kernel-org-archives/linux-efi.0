From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Thu, 07 Mar 2013 16:03:47 +0800
Message-ID: <1362643427.28562.16.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>  <51370A51.1050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51370A51.1050505-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-03-06 =E6=96=BC 17:20 +0800=EF=BC=8CLi=
ngzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> On 03/06/2013 03:34 PM, joeyli wrote:
> > +static unsigned long variable_name_length(efi_char16_t *variable_n=
ame)
> > +{
> > +	unsigned long len;
> > +	efi_char16_t c;
> > +
> > +	len =3D 2;
> > +	do {
> > +		c =3D variable_name[len / sizeof(c) - 1];
> > +		if (c)
> > +			len +=3D sizeof(c);
> > +	} while (c);
> > +
> > +	return len;
> > +}
> > +
>=20
> It looks like this function can be replaced with utf16_strsize.
>=20

Ah! thanks for you point out, I will use utf16_strsize.


Thanks a lot!
Joey Lee
