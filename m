From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 9 Sep 2015 10:58:06 +0100
Message-ID: <20150909095806.GA4973@codeblueprint.co.uk>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
 <20150904182307.GE2737@codeblueprint.co.uk>
 <CAKv+Gu-AQdgJNOtrgtEtqxsaSC_L=EANpC3pT8b6X2jmZ5qO_Q@mail.gmail.com>
 <20150908131622.GA2854@codeblueprint.co.uk>
 <CAKv+Gu_us3Nu_gMd4GxPe7z0eqtMfM4DM_UEmGW2MTqVDxg5vA@mail.gmail.com>
 <20150908203630.GB2854@codeblueprint.co.uk>
 <CAKv+Gu8oYgkbxd_L-t2JhtvfUvpmMDEgE3A67cQTtFBpXspAiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8oYgkbxd_L-t2JhtvfUvpmMDEgE3A67cQTtFBpXspAiw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Sep, at 09:37:21AM, Ard Biesheuvel wrote:
> On 8 September 2015 at 22:37, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> >
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index 691b333e0038..a2af35f6093a 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -704,6 +704,44 @@ out:
> >         return ret;
> >  }
> >
> > +static inline void *efi_map_next_entry_reverse(void *entry)
> > +{
> > +       if (!entry)
> > +               return memmap.map_end - memmap.desc_size;
> > +
> > +       entry -= memmap.desc_size;
> > +       if (entry < memmap.map)
> > +               return NULL;
> > +
> > +       return entry;
> > +}
> > +
> > +static void *efi_map_next_entry(void *entry)
> > +{
> > +       bool reverse = false;
> > +
> > +       if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
> 
> Here, you could also test whether the
> EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA bit
> (sigh) is set

No, leaving this out was intentional because we're already suffering
from the combinatoral explosion of config options. Introducing more
code paths is very much the wrong thing to do unless absolutely
necessary.

If we can get away with using one mapping scheme here, we should.

When trying to debug this code in the future I do not want to be
thinking "Do you have EFI_PROPERTIES_RUNTIME_OMG_THIS_IS_SILLY bit
set? because that means we're mapping the runtime regions in a
different order".
 
-- 
Matt Fleming, Intel Open Source Technology Center
