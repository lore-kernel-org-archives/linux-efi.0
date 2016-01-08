From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit
 is 0
Date: Fri, 8 Jan 2016 10:09:25 -0800
Message-ID: <20160108180925.GA3488@cloud>
References: <1450648391-4631-1-git-send-email-me@moshe.nl>
 <20160105154640.GB2714@codeblueprint.co.uk>
 <568BF19E.3040701@moshe.nl>
 <20160108113047.GD2532@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160108113047.GD2532-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 08, 2016 at 11:30:47AM +0000, Matt Fleming wrote:
> On Tue, 05 Jan, at 05:38:54PM, M=C3=B4she van der Sterre wrote:
> > On 01/05/2016 04:46 PM, Matt Fleming wrote:
> > >Shouldn't this be pr_debug() instead of pr_err()?
> >=20
> > It is an actual error for the image to be anything else. I did look=
 at your
> > commit "x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid BGR=
T", and
> > actually intentionally chose pr_err() instead of pr_debug() because=
 of it.
> >=20
> > From that commit message:
> >     However, Josh points that out it still makes sense to test the
> >     validity of the upper 7 bits of the 'status' field, since
> >     they're marked as "reserved" in the spec and must be zero. If
> >     firmware violates this it really *is* an error.
> >=20
> > From the ACPI spec:
> >     If the value is 0, the Image Type is Bitmap. The format for a B=
itmap is
> > defined at the reference located in the ACPI Link Document under th=
e heading
> > "Types of Bitmaps". All other values not defined in the table are r=
eserved
> > for future use.
> > and also:
> >     Implementations must present the image in a 24 bit bitmap with =
pixel
> > format 0xRRGGBB, or a 32-bit bitmap with the pixel format 0xrrRRGGB=
B, where
> > =E2=80=98rr=E2=80=99 is reserved.
> > Following the link to MSDN, the header id is definitely also requir=
ed to be
> > "BM" for those types,
> > That said, I'm not 100% sure if pr_err() is right for any of the er=
rors in
>=20
> OK, I'll queue this up. Josh, does this look OK to you?

Yes, checking the bitmap file header seems like a good additional
cross-check.  And since the spec says that the image must be a bitmap
(given the one possible value for the format field), and since we can't
reliably know *how much* data to read without reading the bitmap header=
,
we should indeed error out if the data doesn't look like a bitmap.

Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
