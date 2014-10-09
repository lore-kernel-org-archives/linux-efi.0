From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Thu, 09 Oct 2014 18:19:39 -0400
Message-ID: <1412893179.29182.71.camel@deneb.redhat.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
	 <20141009172354.GA466@leverpostej>
	 <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-10-09 at 21:03 +0200, Ard Biesheuvel wrote:
> On 9 October 2014 19:23, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > Hi Ard,
> >
> > On Wed, Oct 08, 2014 at 03:11:27PM +0100, Ard Biesheuvel wrote:
> >> After the EFI stub has done its business, it jumps into the kernel=
 by
> >> branching to offset #0 of the loaded Image, which is where it expe=
cts
> >> to find the header containing a 'branch to stext' instruction.
> >>
> >> However, the UEFI spec 2.1.1 states the following regarding PE/COF=
=46
> >> image loading:
> >> "A UEFI image is loaded into memory through the LoadImage() Boot
> >> Service. This service loads an image with a PE32+ format into memo=
ry.
> >> This PE32+ loader is required to load all sections of the PE32+ im=
age
> >> into memory."
> >>
> >> In other words, it is /not/ required to load parts of the image th=
at are
> >> not covered by a PE/COFF section, so it may not have loaded the he=
ader
> >> at the expected offset, as it is not covered by any PE/COFF sectio=
n.
> >
> > What does this mean for handle_kernel_image? Given we might not hav=
e
> > _text through to _stext mapped, do we not need to take that into
> > account?
> >
>=20
> Actually, handle_kernel_image() does not interpret the header, it jus=
t
> copies it along with the rest of the image if it needs to be
> relocated, so I don't see an issue there. However, I do remember Mark
> Salter mentioning that there is at least one other location that need=
s
> to be fixed up if this concern is valid. Mark?

I think at one time we were using the the EFI_LOADED_IMAGE_PROTOCOL
ImageBase field and assuming it pointed to the start of the copied
file, but I don't think we do so currently. My thought at the time was
that the ImageBase pointer didn't really make sense unless the whole
image file was copied by LoadImage(). The description for LoadImage has=
:

  The LoadImage() function loads an EFI image into memory and returns
  a handle to the image. The image is loaded in one of two ways.

  =E2=80=A2 If SourceBuffer is not NULL, the function is a memory-to-me=
mory
    load  in which SourceBuffer points to the image to be loaded and
    SourceSize indicates the image=E2=80=99s size in bytes. In this cas=
e, the
    caller has copied the image into SourceBuffer and can free the
    buffer once loading is complete.

  =E2=80=A2 If SourceBuffer is NULL, the function is a file copy operat=
ion that
    uses the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.

Which makes me think the whole thing gets copied. But in any case, I
have no objection to your patch.

>=20
> > Also, have we seen problems on any systems yet?
> >
>=20
> No, I am not aware of any occurrences of this exact issue, this is
> just one of the things I spotted while working on this code.
> But I think we mostly agree that branching through the header relies
> on behavior of the PE/COFF loader that is not covered by the spec.
>=20
