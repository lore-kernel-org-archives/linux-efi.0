From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 16:28:39 +0200
Message-ID: <CAKv+Gu_DdtBf=si_3pHOA81jMpqgNjyZz30oZ_wEQ2W6V6OMQg@mail.gmail.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141009172354.GA466@leverpostej>
	<CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
	<1412893179.29182.71.camel@deneb.redhat.com>
	<CAFECyb9Tz2Fo2ix0VYiM7WPeie7C=woiVwyQtR4aH_HPcLwkOg@mail.gmail.com>
	<CAKv+Gu_6uww=W9M9hDfoSmY+zr2i75Y=JOxTLCya2rr=HiT6Bw@mail.gmail.com>
	<1412950468.29182.82.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412950468.29182.82.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2014 16:14, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2014-10-10 at 08:30 +0200, Ard Biesheuvel wrote:
>> On 10 October 2014 01:20, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > On Thu, Oct 9, 2014 at 3:19 PM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>> >> On Thu, 2014-10-09 at 21:03 +0200, Ard Biesheuvel wrote:
>> >>> On 9 October 2014 19:23, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wro=
te:
>> >>> > Hi Ard,
>> >>> >
>> >>> > On Wed, Oct 08, 2014 at 03:11:27PM +0100, Ard Biesheuvel wrote=
:
>> >>> >> After the EFI stub has done its business, it jumps into the k=
ernel by
>> >>> >> branching to offset #0 of the loaded Image, which is where it=
 expects
>> >>> >> to find the header containing a 'branch to stext' instruction=
=2E
>> >>> >>
>> >>> >> However, the UEFI spec 2.1.1 states the following regarding P=
E/COFF
>> >>> >> image loading:
>> >>> >> "A UEFI image is loaded into memory through the LoadImage() B=
oot
>> >>> >> Service. This service loads an image with a PE32+ format into=
 memory.
>> >>> >> This PE32+ loader is required to load all sections of the PE3=
2+ image
>> >>> >> into memory."
>> >>> >>
>> >>> >> In other words, it is /not/ required to load parts of the ima=
ge that are
>> >>> >> not covered by a PE/COFF section, so it may not have loaded t=
he header
>> >>> >> at the expected offset, as it is not covered by any PE/COFF s=
ection.
>> >>> >
>> >>> > What does this mean for handle_kernel_image? Given we might no=
t have
>> >>> > _text through to _stext mapped, do we not need to take that in=
to
>> >>> > account?
>> >>> >
>> >>>
>> >>> Actually, handle_kernel_image() does not interpret the header, i=
t just
>> >>> copies it along with the rest of the image if it needs to be
>> >>> relocated, so I don't see an issue there. However, I do remember=
 Mark
>> >>> Salter mentioning that there is at least one other location that=
 needs
>> >>> to be fixed up if this concern is valid. Mark?
>> >>
>> >> I think at one time we were using the the EFI_LOADED_IMAGE_PROTOC=
OL
>> >> ImageBase field and assuming it pointed to the start of the copie=
d
>> >> file, but I don't think we do so currently. My thought at the tim=
e was
>> >> that the ImageBase pointer didn't really make sense unless the wh=
ole
>> >> image file was copied by LoadImage(). The description for LoadIma=
ge has:
>> >>
>> >>   The LoadImage() function loads an EFI image into memory and ret=
urns
>> >>   a handle to the image. The image is loaded in one of two ways.
>> >>
>> >>   =E2=80=A2 If SourceBuffer is not NULL, the function is a memory=
-to-memory
>> >>     load  in which SourceBuffer points to the image to be loaded =
and
>> >>     SourceSize indicates the image=E2=80=99s size in bytes. In th=
is case, the
>> >>     caller has copied the image into SourceBuffer and can free th=
e
>> >>     buffer once loading is complete.
>> >>
>> >>   =E2=80=A2 If SourceBuffer is NULL, the function is a file copy =
operation that
>> >>     uses the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.
>> >>
>> >> Which makes me think the whole thing gets copied. But in any case=
, I
>> >> have no objection to your patch.
>> >>
>> > In practice for the edk2, the whole thing does get loaded into mem=
ory.
>> > Whether this
>> > is mandated by the UEFI specification seems less clear.
>> >
>> > I just took a look at handle_kernel_image(), and I don't think it =
will do
>> > the right thing if the firmware doesn't load the header.  Looking =
deeper,
>> > I think some other stuff will be broken in that case as well.
>> > handle_kernel_image() takes the image_addr, which the ASM wrapper
>> > computes using PC relative
>> > operations and _text:
>> >
>> > adrp x8, _text
>> > add x8, x8, #:lo12:_text
>> >
>> > So if the header is actually not loaded, this address will be wron=
g -
>> > it will be outside
>> > the area loaded. While we're not using the EFI_LOADED_IMAGE_PROTOC=
OL,
>> > our calculation is only
>> > correct if it does load the whole file.
>> >
>> > I think a similar error would be present in handle_kernel_image() =
with regard
>> > to determining how big the kernel is so it can be copied:
>> > kernel_size =3D _edata - _text;
>> > This is not correct amount to copy if the header isn't loaded.
>> >
>> > I think we'll also run into some alignment issues if the loader re=
ally just
>> > loads the section ( we just have the one) rather than the whole fi=
le.
>> > From reviewing the PE/COFF spec again we violate the relationship
>> > between FileAlignment and SectionAlignment.
>> >
>> > I think the patch is fine for what it does - avoids executing the
>> > branch in the PE/COFF header,
>> > and rather branching directly to the desired code that is in the
>> > PE/COFF section.
>> > There are variety of other issues that would need to be addressed =
if
>> > the EFI loader
>> > is just loading the bare section.
>> >
>>
>> The issue is *not* that the PE/COFF .text section may get loaded at
>> ImageBase instead of at ImageBase+sizeof(header), so I don't think
>> there is reason for any of your concerns.
>> The issue I try to address here is where the loader allocates some
>> memory starting at ImageBase, but only populates those regions that
>> are covered by a section, i.e., only the .text section in our case.
>> Copying the header from the file to memory at the same relative
>> (negative) offset from .text as it happens to appear in the file is
>> behavior that is not covered by the spec at all.
>>
>
> I think we need a loader that actually does this so all of these
> patches can be tested in that scenario. Otherwise, there are likely
> going to be other bugs related to it. If we're going to address that
> possibility, it would be nice to know that it is actually fixed.
>

What I found is that you can easily test this by offsetting the
virtual address of the .text section by e.g., 0x1000. This results in
a hole in the memory image between the header and the .text section
that does not exist in the file, so negative offsets from .text (which
is essentially how we access the header currently) point into the
hole, not at the header.
