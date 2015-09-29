From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 29 Sep 2015 14:52:56 +0100
Message-ID: <20150929135256.GA4401@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
 <20150926134329.GA3144@codeblueprint.co.uk>
 <20150927070355.GB26125@gmail.com>
 <CAKv+Gu8M2pmzfeA=NT4c44E6-PQvRKHZjEJt78mryGcp6bBD8w@mail.gmail.com>
 <20150928082245.GA28796@gmail.com>
 <CAKv+Gu-e5CRrJ1S7phXyWCUZ10ptukn0zr0wDGyX14H_SpEp1Q@mail.gmail.com>
 <20150929091230.GA2023@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150929091230.GA2023-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Sep, at 11:12:30AM, Ingo Molnar wrote:
> 
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
> > > except that I don't think
> > > the condition on 64-bit makes any sense:
> > >
> > > +       if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
> > >
> > > I can see us being nervous wrt. backported patches, but is there any strong reason
> > > to not follow this up with a third (non-backported) patch that changes this to:
> > >
> > > +       if (!efi_enabled(EFI_OLD_MEMMAP)) {
> > >
> > > for v4.4?
> > >
> > 
> > The 32-bit side essentially implements the old memmap only, which is the the 
> > bottom-up version. So old memmap will be implied by 32-bit but not set in the 
> > EFI flags, resulting in the reverse enumeration being used with the bottom-up 
> > mapping logic. The net result of that is that we create the same problem for 
> > 32-bit that we are trying to solve for 64-bit, i.e., the regions will end up in 
> > reverse order in the VA mapping.
> > 
> > To deobfuscate this particular conditional, we could set EFI_OLD_MEMMAP 
> > unconditionally on 32-bit x86. Or we could reshuffle variables and conditionals 
> > in various other way.
> 
> Setting EFI_OLD_MEMMAP would be fine, if doing that has no bad side effects.
 
Right, I think that's a very good suggestion, because like Ard
mentioned, since EFI_OLD_MEMMAP is implied for 32-bit (there's no
other way to map stuff currently), so it makes sense to force set the
bit.

> > [...] I am not convinced that the overall end result will be any better though.
> 
> That's not true, we change an obscure, implicit dependency on 32-bit detail to an 
> explicit EFI_OLD_MEMMAP flag that shows exactly what's happening. That's a clear 
> improvement.

Agreed.

-- 
Matt Fleming, Intel Open Source Technology Center
