From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Thu, 9 Oct 2014 16:20:19 -0700
Message-ID: <CAFECyb9Tz2Fo2ix0VYiM7WPeie7C=woiVwyQtR4aH_HPcLwkOg@mail.gmail.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141009172354.GA466@leverpostej>
	<CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
	<1412893179.29182.71.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412893179.29182.71.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 9, 2014 at 3:19 PM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2014-10-09 at 21:03 +0200, Ard Biesheuvel wrote:
>> On 9 October 2014 19:23, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> > Hi Ard,
>> >
>> > On Wed, Oct 08, 2014 at 03:11:27PM +0100, Ard Biesheuvel wrote:
>> >> After the EFI stub has done its business, it jumps into the kerne=
l by
>> >> branching to offset #0 of the loaded Image, which is where it exp=
ects
>> >> to find the header containing a 'branch to stext' instruction.
>> >>
>> >> However, the UEFI spec 2.1.1 states the following regarding PE/CO=
=46F
>> >> image loading:
>> >> "A UEFI image is loaded into memory through the LoadImage() Boot
>> >> Service. This service loads an image with a PE32+ format into mem=
ory.
>> >> This PE32+ loader is required to load all sections of the PE32+ i=
mage
>> >> into memory."
>> >>
>> >> In other words, it is /not/ required to load parts of the image t=
hat are
>> >> not covered by a PE/COFF section, so it may not have loaded the h=
eader
>> >> at the expected offset, as it is not covered by any PE/COFF secti=
on.
>> >
>> > What does this mean for handle_kernel_image? Given we might not ha=
ve
>> > _text through to _stext mapped, do we not need to take that into
>> > account?
>> >
>>
>> Actually, handle_kernel_image() does not interpret the header, it ju=
st
>> copies it along with the rest of the image if it needs to be
>> relocated, so I don't see an issue there. However, I do remember Mar=
k
>> Salter mentioning that there is at least one other location that nee=
ds
>> to be fixed up if this concern is valid. Mark?
>
> I think at one time we were using the the EFI_LOADED_IMAGE_PROTOCOL
> ImageBase field and assuming it pointed to the start of the copied
> file, but I don't think we do so currently. My thought at the time wa=
s
> that the ImageBase pointer didn't really make sense unless the whole
> image file was copied by LoadImage(). The description for LoadImage h=
as:
>
>   The LoadImage() function loads an EFI image into memory and returns
>   a handle to the image. The image is loaded in one of two ways.
>
>   =E2=80=A2 If SourceBuffer is not NULL, the function is a memory-to-=
memory
>     load  in which SourceBuffer points to the image to be loaded and
>     SourceSize indicates the image=E2=80=99s size in bytes. In this c=
ase, the
>     caller has copied the image into SourceBuffer and can free the
>     buffer once loading is complete.
>
>   =E2=80=A2 If SourceBuffer is NULL, the function is a file copy oper=
ation that
>     uses the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.
>
> Which makes me think the whole thing gets copied. But in any case, I
> have no objection to your patch.
>
In practice for the edk2, the whole thing does get loaded into memory.
Whether this
is mandated by the UEFI specification seems less clear.

I just took a look at handle_kernel_image(), and I don't think it will =
do
the right thing if the firmware doesn't load the header.  Looking deepe=
r,
I think some other stuff will be broken in that case as well.
handle_kernel_image() takes the image_addr, which the ASM wrapper
computes using PC relative
operations and _text:

adrp x8, _text
add x8, x8, #:lo12:_text

So if the header is actually not loaded, this address will be wrong -
it will be outside
the area loaded. While we're not using the EFI_LOADED_IMAGE_PROTOCOL,
our calculation is only
correct if it does load the whole file.

I think a similar error would be present in handle_kernel_image() with =
regard
to determining how big the kernel is so it can be copied:
kernel_size =3D _edata - _text;
This is not correct amount to copy if the header isn't loaded.

I think we'll also run into some alignment issues if the loader really =
just
loads the section ( we just have the one) rather than the whole file.
=46rom reviewing the PE/COFF spec again we violate the relationship
between FileAlignment and SectionAlignment.

I think the patch is fine for what it does - avoids executing the
branch in the PE/COFF header,
and rather branching directly to the desired code that is in the
PE/COFF section.
There are variety of other issues that would need to be addressed if
the EFI loader
is just loading the bare section.

Roy


>>
>> > Also, have we seen problems on any systems yet?
>> >
>>
>> No, I am not aware of any occurrences of this exact issue, this is
>> just one of the things I spotted while working on this code.
>> But I think we mostly agree that branching through the header relies
>> on behavior of the PE/COFF loader that is not covered by the spec.
>>
>
>
