From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 10:14:28 -0400
Message-ID: <1412950468.29182.82.camel@deneb.redhat.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
	 <20141009172354.GA466@leverpostej>
	 <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
	 <1412893179.29182.71.camel@deneb.redhat.com>
	 <CAFECyb9Tz2Fo2ix0VYiM7WPeie7C=woiVwyQtR4aH_HPcLwkOg@mail.gmail.com>
	 <CAKv+Gu_6uww=W9M9hDfoSmY+zr2i75Y=JOxTLCya2rr=HiT6Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_6uww=W9M9hDfoSmY+zr2i75Y=JOxTLCya2rr=HiT6Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2014-10-10 at 08:30 +0200, Ard Biesheuvel wrote:
> On 10 October 2014 01:20, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Oct 9, 2014 at 3:19 PM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> >> On Thu, 2014-10-09 at 21:03 +0200, Ard Biesheuvel wrote:
> >>> On 9 October 2014 19:23, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrot=
e:
> >>> > Hi Ard,
> >>> >
> >>> > On Wed, Oct 08, 2014 at 03:11:27PM +0100, Ard Biesheuvel wrote:
> >>> >> After the EFI stub has done its business, it jumps into the ke=
rnel by
> >>> >> branching to offset #0 of the loaded Image, which is where it =
expects
> >>> >> to find the header containing a 'branch to stext' instruction.
> >>> >>
> >>> >> However, the UEFI spec 2.1.1 states the following regarding PE=
/COFF
> >>> >> image loading:
> >>> >> "A UEFI image is loaded into memory through the LoadImage() Bo=
ot
> >>> >> Service. This service loads an image with a PE32+ format into =
memory.
> >>> >> This PE32+ loader is required to load all sections of the PE32=
+ image
> >>> >> into memory."
> >>> >>
> >>> >> In other words, it is /not/ required to load parts of the imag=
e that are
> >>> >> not covered by a PE/COFF section, so it may not have loaded th=
e header
> >>> >> at the expected offset, as it is not covered by any PE/COFF se=
ction.
> >>> >
> >>> > What does this mean for handle_kernel_image? Given we might not=
 have
> >>> > _text through to _stext mapped, do we not need to take that int=
o
> >>> > account?
> >>> >
> >>>
> >>> Actually, handle_kernel_image() does not interpret the header, it=
 just
> >>> copies it along with the rest of the image if it needs to be
> >>> relocated, so I don't see an issue there. However, I do remember =
Mark
> >>> Salter mentioning that there is at least one other location that =
needs
> >>> to be fixed up if this concern is valid. Mark?
> >>
> >> I think at one time we were using the the EFI_LOADED_IMAGE_PROTOCO=
L
> >> ImageBase field and assuming it pointed to the start of the copied
> >> file, but I don't think we do so currently. My thought at the time=
 was
> >> that the ImageBase pointer didn't really make sense unless the who=
le
> >> image file was copied by LoadImage(). The description for LoadImag=
e has:
> >>
> >>   The LoadImage() function loads an EFI image into memory and retu=
rns
> >>   a handle to the image. The image is loaded in one of two ways.
> >>
> >>   =E2=80=A2 If SourceBuffer is not NULL, the function is a memory-=
to-memory
> >>     load  in which SourceBuffer points to the image to be loaded a=
nd
> >>     SourceSize indicates the image=E2=80=99s size in bytes. In thi=
s case, the
> >>     caller has copied the image into SourceBuffer and can free the
> >>     buffer once loading is complete.
> >>
> >>   =E2=80=A2 If SourceBuffer is NULL, the function is a file copy o=
peration that
> >>     uses the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.
> >>
> >> Which makes me think the whole thing gets copied. But in any case,=
 I
> >> have no objection to your patch.
> >>
> > In practice for the edk2, the whole thing does get loaded into memo=
ry.
> > Whether this
> > is mandated by the UEFI specification seems less clear.
> >
> > I just took a look at handle_kernel_image(), and I don't think it w=
ill do
> > the right thing if the firmware doesn't load the header.  Looking d=
eeper,
> > I think some other stuff will be broken in that case as well.
> > handle_kernel_image() takes the image_addr, which the ASM wrapper
> > computes using PC relative
> > operations and _text:
> >
> > adrp x8, _text
> > add x8, x8, #:lo12:_text
> >
> > So if the header is actually not loaded, this address will be wrong=
 -
> > it will be outside
> > the area loaded. While we're not using the EFI_LOADED_IMAGE_PROTOCO=
L,
> > our calculation is only
> > correct if it does load the whole file.
> >
> > I think a similar error would be present in handle_kernel_image() w=
ith regard
> > to determining how big the kernel is so it can be copied:
> > kernel_size =3D _edata - _text;
> > This is not correct amount to copy if the header isn't loaded.
> >
> > I think we'll also run into some alignment issues if the loader rea=
lly just
> > loads the section ( we just have the one) rather than the whole fil=
e.
> > From reviewing the PE/COFF spec again we violate the relationship
> > between FileAlignment and SectionAlignment.
> >
> > I think the patch is fine for what it does - avoids executing the
> > branch in the PE/COFF header,
> > and rather branching directly to the desired code that is in the
> > PE/COFF section.
> > There are variety of other issues that would need to be addressed i=
f
> > the EFI loader
> > is just loading the bare section.
> >
>=20
> The issue is *not* that the PE/COFF .text section may get loaded at
> ImageBase instead of at ImageBase+sizeof(header), so I don't think
> there is reason for any of your concerns.
> The issue I try to address here is where the loader allocates some
> memory starting at ImageBase, but only populates those regions that
> are covered by a section, i.e., only the .text section in our case.
> Copying the header from the file to memory at the same relative
> (negative) offset from .text as it happens to appear in the file is
> behavior that is not covered by the spec at all.
>=20

I think we need a loader that actually does this so all of these
patches can be tested in that scenario. Otherwise, there are likely
going to be other bugs related to it. If we're going to address that
possibility, it would be nice to know that it is actually fixed.
