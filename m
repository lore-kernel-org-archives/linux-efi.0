From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 9 Sep 2015 11:59:58 +0200
Message-ID: <CAKv+Gu81_ZsK8GXR8AJ-zTk=C21g3G-7gZvhNAVrxPrKODmzPg@mail.gmail.com>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
	<CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
	<20150904182307.GE2737@codeblueprint.co.uk>
	<CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
	<20150908131622.GA2854@codeblueprint.co.uk>
	<CAKv+Gu_us3Nu_gMd4GxPe7z0eqtMfM4DM_UEmGW2MTqVDxg5vA@mail.gmail.com>
	<20150908203630.GB2854@codeblueprint.co.uk>
	<CAKv+Gu8oYgkbxd_L-t2JhtvfUvpmMDEgE3A67cQTtFBpXspAiw@mail.gmail.com>
	<20150909095806.GA4973@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150909095806.GA4973-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 9 September 2015 at 11:58, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 09 Sep, at 09:37:21AM, Ard Biesheuvel wrote:
>> On 8 September 2015 at 22:37, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> >
>> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> > index 691b333e0038..a2af35f6093a 100644
>> > --- a/arch/x86/platform/efi/efi.c
>> > +++ b/arch/x86/platform/efi/efi.c
>> > @@ -704,6 +704,44 @@ out:
>> >         return ret;
>> >  }
>> >
>> > +static inline void *efi_map_next_entry_reverse(void *entry)
>> > +{
>> > +       if (!entry)
>> > +               return memmap.map_end - memmap.desc_size;
>> > +
>> > +       entry -= memmap.desc_size;
>> > +       if (entry < memmap.map)
>> > +               return NULL;
>> > +
>> > +       return entry;
>> > +}
>> > +
>> > +static void *efi_map_next_entry(void *entry)
>> > +{
>> > +       bool reverse = false;
>> > +
>> > +       if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>>
>> Here, you could also test whether the
>> EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA bit
>> (sigh) is set
>
> No, leaving this out was intentional because we're already suffering
> from the combinatoral explosion of config options. Introducing more
> code paths is very much the wrong thing to do unless absolutely
> necessary.
>
> If we can get away with using one mapping scheme here, we should.
>
> When trying to debug this code in the future I do not want to be
> thinking "Do you have EFI_PROPERTIES_RUNTIME_OMG_THIS_IS_SILLY bit
> set? because that means we're mapping the runtime regions in a
> different order".
>

OK, point taken. I suppose buggy firmware already has the option of
using EFI_OLD_MEMMAP as a fallback.

-- 
Ard.
