From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit
 is 0
Date: Fri, 8 Jan 2016 11:30:47 +0000
Message-ID: <20160108113047.GD2532@codeblueprint.co.uk>
References: <1450648391-4631-1-git-send-email-me@moshe.nl>
 <20160105154640.GB2714@codeblueprint.co.uk>
 <568BF19E.3040701@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568BF19E.3040701-A/3C56C7qwM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Jan, at 05:38:54PM, M=C3=B4she van der Sterre wrote:
> On 01/05/2016 04:46 PM, Matt Fleming wrote:
> >Shouldn't this be pr_debug() instead of pr_err()?
>=20
> It is an actual error for the image to be anything else. I did look a=
t your
> commit "x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid BGRT"=
, and
> actually intentionally chose pr_err() instead of pr_debug() because o=
f it.
>=20
> From that commit message:
>     However, Josh points that out it still makes sense to test the
>     validity of the upper 7 bits of the 'status' field, since
>     they're marked as "reserved" in the spec and must be zero. If
>     firmware violates this it really *is* an error.
>=20
> From the ACPI spec:
>     If the value is 0, the Image Type is Bitmap. The format for a Bit=
map is
> defined at the reference located in the ACPI Link Document under the =
heading
> "Types of Bitmaps". All other values not defined in the table are res=
erved
> for future use.
> and also:
>     Implementations must present the image in a 24 bit bitmap with pi=
xel
> format 0xRRGGBB, or a 32-bit bitmap with the pixel format 0xrrRRGGBB,=
 where
> =E2=80=98rr=E2=80=99 is reserved.
> Following the link to MSDN, the header id is definitely also required=
 to be
> "BM" for those types,
> That said, I'm not 100% sure if pr_err() is right for any of the erro=
rs in

OK, I'll queue this up. Josh, does this look OK to you?

> efi-bgrt.c. I don't really feel knowledgeable enough to suggest anyth=
ing
> about that, so I tried to follow the previous discussion outcome as c=
losely
> as possible.
>=20
> By the way... Now I'm thinking about the ID, what about endianness? T=
his
> code is under "arch/x86", does this always imply a little-endian
> architecture? The new check will probably fail on big-endian but that=
 should
> never happen, right?

Yes, we can ignore big-endian.
