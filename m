From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 10/14] efi: Make checkpatch complain less about efi.h
 GUID additions
Date: Wed, 03 Feb 2016 03:09:34 -0800
Message-ID: <1454497774.7291.73.camel@perches.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
	 <1454364428-494-11-git-send-email-matt@codeblueprint.co.uk>
	 <20160203103335.GA7310@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203103335.GA7310@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@canonical.com>, Dan Carpenter <error27@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2016-02-03 at 11:33 +0100, Ingo Molnar wrote:
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>=20
> > From: Peter Jones <pjones@redhat.com>
> >=20
> > This reformats the GUID definitions in include/linux/efi.h so that =
if
> > you add another one with the same style, checkpatch won't complain =
about
> > it.
> >=20
> > Signed-off-by: Peter Jones <pjones@redhat.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> > ---
> > =A0include/linux/efi.h | 63 +++++++++++++++++++++++++++++++++++----=
--------------
> > =A01 file changed, 42 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 09f1559e7525..f468f7c53236 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -535,67 +535,88 @@ void efi_native_runtime_setup(void);
> > =A0 *=A0=A0EFI Configuration Table and GUID definitions
> > =A0 */
> > =A0#define NULL_GUID \
> > -=A0=A0=A0=A0EFI_GUID(=A0=A00x00000000, 0x0000, 0x0000, 0x00, 0x00,=
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
> > +	EFI_GUID(0x00000000, 0x0000, 0x0000, \
> > +		=A00x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
> > =A0
> > =A0#define MPS_TABLE_GUID=A0=A0=A0=A0\
> > -=A0=A0=A0=A0EFI_GUID(=A0=A00xeb9d2d2f, 0x2d88, 0x11d3, 0x9a, 0x16,=
 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
> > +	EFI_GUID(0xeb9d2d2f, 0x2d88, 0x11d3, \
> > +		=A00x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>=20
> So I really think this is a step backwards.

Some people take checkpatch messages altogether too seriously.

from: https://lkml.org/lkml/2015/7/16/568
----------------------------------
The other thing that might help is for people to take
the warnings the script produces less seriously.

Maybe convert:

ERROR -> defect
WARNING -> unstylish
CHECK -> nitpick

or some such
----------------------------------
> Checkpatch should be fixed/enhanced to allow targeted exemption. Some=
thing like:
>=20
>=20
> 	#define CHECKPATCH_IGNORE
> 	...
> 	#undef CHECKPATCH_IGNORE
>=20
> ... which checkpatch would parse and interpret accordingly.

A similar proposal: https://lkml.org/lkml/2016/1/30/175

checkpatch works on patches.
If the #define isn't in the patch scope the script won't know.

Perhaps it's simpler to add some facility to allow lines
with known keywords to exceed $max_line_length similar
to the format strings of logging functions.
