From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating
 variables
Date: Tue, 26 Mar 2013 04:34:43 +0000
Message-ID: <1364272483.3520.12.camel@deadeye.wl.decadent.org.uk>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
	 <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
	 <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
	 <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
	 <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
	 <5151248F.2010303@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5eR7NEllV0lVfIQ+50qN"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5151248F.2010303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--=-5eR7NEllV0lVfIQ+50qN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-26 at 12:31 +0800, Lingzhu Xiang wrote:
> On 03/26/2013 11:56 AM, Matthew Garrett wrote:
> > Ok, so having thought some more about the actual problem (ie, Samsungs
> > go wrong if there's too much used space marked as being active, not
> > merely too much used space) I think we really want to be looking for th=
e
> > amount of active space rather than the remaining space value that
> > QueryVariableInfo() gives us. Something like this (absolutely untested,
> > provided here for comment) patch? I'll try rigging something up under
> > OVMF to test it. This version certainly seems a little over-naive, sinc=
e
> > it won't handle the case of a variable that's being overwritten with
> > something of a different size.
> >
> > commit 263c2ee36c67dfa6d869304a3b5aef7a14f1ec4e
> > Author: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> > Date:   Mon Mar 25 13:40:28 2013 -0400
> >
> >      efi: Distinguish between "remaining space" and actually used space
> >
> >      EFI implementations distinguish between space that is actively use=
d by a
> >      variable and space that merely hasn't been garbage collected yet. =
Space
> >      that hasn't yet been garbage collected isn't available for use and=
 so isn't
> >      counted in the remaining_space field returned by QueryVariableInfo=
().
> >
> >      Combined with commit 68d9298 this can cause problems. Some impleme=
ntations
> >      don't garbage collect until the remaining space is smaller than th=
e maximum
> >      variable size, and as a result check_var_size() will always fail o=
nce more
> >      than 50% of the variable store has been used even if most of that =
space is
> >      marked as available for garbage collection. The user is unable to =
create
> >      new variables, and deleting variables doesn't increase the remaini=
ng space.
>=20
> Do you mean they don't garbage collect across reboots?
[...]

Yes, see <http://article.gmane.org/gmane.linux.kernel.stable/47156>.

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-5eR7NEllV0lVfIQ+50qN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVElY+e/yOyVhhEJAQpSVg//QXgk0Bbpr83tohSjnuo6MyYARL4bM3lY
Vf3iGf2UxFNp+x9UZ+KGAhdWb5GNvkkH7p8+cX0wX5aahKkjp44CL2yIftBo9vX0
xvCsdB2KFautHugz6/WMMavbv5EGwJtI3traOzoGJsGloj3WCukDu3VKm0Nf71qJ
AXhuoks7dBJjEI90I48ugdtiKpbHmT8XDUkeMPCkgSnmq+9d3clyNRFWRmMVV6I1
daJhbUfVgEVctDvWJiakkFyFmo+Z+XW0sf80sxTqROUzhJP1QV/9YA2b/vCTUgNw
hHZNm0udzvcW9ImXMkd+7UWaIlRn/7vfqPfTmxWzlIhjk2kbDKgD7RQuAGijggud
1Ko560MVdVWl+fMF+5Z7DZMuHQgkzn9BCURipgGu0vJxvolbrBN0u4TdosOp29ic
MOUoJ1U7MFnChSaAC43cMjxZvsEUNWNDSf3TGZkJgoEdmivmbr7eXKx+jRiIojy8
4JsvTbA3d+g/oxmm0BHh2F8flT433pngKim8VP7rAE+2LWJ4f5bttsyMRw/2ziXR
w1cKGuouHKA0zEBc4PLSwcMpzZz2e89iFVwsB3Y8epLAwyBAKSXpG6oTDNe3UBfb
tXBh596HriXSarJ8Wkh5BQs4mqgyuA9jnJsO9muQSTXO9lCp3tSLuFkwGd+xUf4K
KZAZFso5WiE=
=JaxR
-----END PGP SIGNATURE-----

--=-5eR7NEllV0lVfIQ+50qN--
