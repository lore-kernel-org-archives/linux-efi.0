From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 14:03:02 +0100
Message-ID: <20141010130302.GC5294@leverpostej>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141009172354.GA466@leverpostej>
 <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
 <20141010104923.GD4076@leverpostej>
 <CAKv+Gu_mx3uWqnRESAjqz6MdUJqBSjgeMCdnpzKiRQ+1FxUjCQ@mail.gmail.com>
 <20141010121918.GA5294@leverpostej>
 <CAKv+Gu-Kk=hZ78T+_ePceTgb9m4KmvpLcYOwvxEWuUcT+ScK_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Kk=hZ78T+_ePceTgb9m4KmvpLcYOwvxEWuUcT+ScK_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[...]

> >> > But if the EFI loader is allowed to load stext at the precise start of
> >> > RAM (or anywhere not in the idmap), in attempting the copy we'd try to
> >> > access unmapped addresses.
> >> >
> >> > So if that's a possibility, we need to shrink the copy to cover stext
> >> > to _edata rather than _text to edata.
> >> >
> >> > Does that make sense?
> >> >
> >>
> >> That cannot happen. The PE/COFF .text section's positive relative
> >> virtual offset ensures that the memory image has room for the header,
> >> it's just not guaranteed that anything gets copied there.
> >
> > Ok. If we're guaranteed to have some space there, we're fine.
> >
> > I'm probably being a bit thick here, but where is the "positive relative
> > virtual offset" in the header? Which field defines that?
> >
> 
> The fields VirtualSize, VirtualAddress (the field I was referring to),
> SizeOfRawData and PointerToRawData define the relation between the
> file layout and the memory layout of the .text section (line 219 and
> up in head.S)

I guess my confusion is over the semantics of the VirtualAddress field.
If it's treated as an offset, what is that offset relative to in memory?
And what defines that the space covered by that offset is accessible?

> In our current definition, the memory offset and the file offset are
> identical (which this patch redefines as 'stext_offset'). The virtual
> size covers the entire static memory footprint of Image (minus the
> header). whereas the SizeOfRawData contains the size of the payload in
> the file (again, minus the header). The balance is zero initialized by
> the loader.

I can see why this guarantees there is space for stext to _end, but I
don't understand how this guarantees there is a valid mapping for the
region that would otherwise be _head to stext.

Thanks,
Mark.
