From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 14:31:34 +0200
Message-ID: <CAKv+Gu-Kk=hZ78T+_ePceTgb9m4KmvpLcYOwvxEWuUcT+ScK_Q@mail.gmail.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141009172354.GA466@leverpostej>
	<CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
	<20141010104923.GD4076@leverpostej>
	<CAKv+Gu_mx3uWqnRESAjqz6MdUJqBSjgeMCdnpzKiRQ+1FxUjCQ@mail.gmail.com>
	<20141010121918.GA5294@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141010121918.GA5294@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2014 14:19, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Oct 10, 2014 at 12:52:32PM +0100, Ard Biesheuvel wrote:
>> On 10 October 2014 12:49, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> > On Thu, Oct 09, 2014 at 08:03:52PM +0100, Ard Biesheuvel wrote:
>> >> On 9 October 2014 19:23, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> >> > Hi Ard,
>> >> >
>> >> > On Wed, Oct 08, 2014 at 03:11:27PM +0100, Ard Biesheuvel wrote:
>> >> >> After the EFI stub has done its business, it jumps into the kernel by
>> >> >> branching to offset #0 of the loaded Image, which is where it expects
>> >> >> to find the header containing a 'branch to stext' instruction.
>> >> >>
>> >> >> However, the UEFI spec 2.1.1 states the following regarding PE/COFF
>> >> >> image loading:
>> >> >> "A UEFI image is loaded into memory through the LoadImage() Boot
>> >> >> Service. This service loads an image with a PE32+ format into memory.
>> >> >> This PE32+ loader is required to load all sections of the PE32+ image
>> >> >> into memory."
>> >> >>
>> >> >> In other words, it is /not/ required to load parts of the image that are
>> >> >> not covered by a PE/COFF section, so it may not have loaded the header
>> >> >> at the expected offset, as it is not covered by any PE/COFF section.
>> >> >
>> >> > What does this mean for handle_kernel_image? Given we might not have
>> >> > _text through to _stext mapped, do we not need to take that into
>> >> > account?
>> >> >
>> >>
>> >> Actually, handle_kernel_image() does not interpret the header, it just
>> >> copies it along with the rest of the image if it needs to be
>> >> relocated, so I don't see an issue there.
>> >
>> > Sorry, I wasn't clear enough with my concern. My concern was whether we
>> > had any guarantee _something_ was mapped for the address range covering
>> > efi_head to stext.
>> >
>> > So long as _something_ is mapped there, we're ok -- handle_kernel_image
>> > will just copy some garbage along with the usable portion of the kernel.
>> >
>>
>> Indeed.
>>
>> > But if the EFI loader is allowed to load stext at the precise start of
>> > RAM (or anywhere not in the idmap), in attempting the copy we'd try to
>> > access unmapped addresses.
>> >
>> > So if that's a possibility, we need to shrink the copy to cover stext
>> > to _edata rather than _text to edata.
>> >
>> > Does that make sense?
>> >
>>
>> That cannot happen. The PE/COFF .text section's positive relative
>> virtual offset ensures that the memory image has room for the header,
>> it's just not guaranteed that anything gets copied there.
>
> Ok. If we're guaranteed to have some space there, we're fine.
>
> I'm probably being a bit thick here, but where is the "positive relative
> virtual offset" in the header? Which field defines that?
>

The fields VirtualSize, VirtualAddress (the field I was referring to),
SizeOfRawData and PointerToRawData define the relation between the
file layout and the memory layout of the .text section (line 219 and
up in head.S)

In our current definition, the memory offset and the file offset are
identical (which this patch redefines as 'stext_offset'). The virtual
size covers the entire static memory footprint of Image (minus the
header). whereas the SizeOfRawData contains the size of the payload in
the file (again, minus the header). The balance is zero initialized by
the loader.
