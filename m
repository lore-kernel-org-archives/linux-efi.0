From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/esrt: cleanup bad memory map log messages
Date: Wed, 8 Feb 2017 10:56:47 -0500
Message-ID: <20170208155646.rxtctllfvqywrdor@redhat.com>
References: <20170207190823.10223-1-drake@endlessm.com>
 <20170208142201.bjwafwxykj3i2icu@redhat.com>
 <CAD8Lp46MUW95vWVMayYYAwOyjOOze-ABc7Qj+RvtrbGVf46wtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD8Lp46MUW95vWVMayYYAwOyjOOze-ABc7Qj+RvtrbGVf46wtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Upstreaming Team <linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 08, 2017 at 09:42:34AM -0600, Daniel Drake wrote:
> On Wed, Feb 8, 2017 at 8:22 AM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > The machine you've got does seem to be presenting a valid (if poorly
> > considered) table, but I don't quite think this is the right approach.
> 
> I don't think it is fully valid. Section 22.3 of the UEFI spec says:
> "The ESRT shall be stored in memory of type EfiBootServicesData"
> 
> > The first hunk of your patch is fine, but the test on the result of
> > efi_mem_desc_lookup() is more or less our check for "might reading this
> > table reboot the system or worse".  You're demoting it to a warning
> > while still /treating/ it as an error, so at least it remains safe,
> > but the when we get to that point, they've (plausibly) given us data
> > that could cause horrible behavior, and that is a thing worth logging an
> > error about.
> 
> Although from the user's perspective (thinking about graphical
> experience) it's a bit unfortunate to have early boot code like this
> print a cryptic error on-screen, when the system is otherwise
> perfectly usable and they might not even be interested in the ESRT's
> functionality.

Fair enough.

> > It would be better to /check/ if it straddles multiple contiguous
> > segments which both have reasonable access modes and print an error if
> > there are gaps.  I'm still in favor of printing a warning to the log if
> > it straddles them and there /aren't/ gaps, because we're *going* to see
> > other weird bugs from any code base that decides it's stitching config
> > tables together from separate allocations.  It's not a fundamentally
> > reasonable thing to do, and as a lens it shows us some code with a
> > really worrisome internal structure.
> 
> If I'm following your suggestion correctly I think it would not affect
> the system I have here, where the ESRT sits entirely within a gap in
> the memory map, without touching the allocations on either side.

Oh!  Then I've misunderstood your commit message.  You said:

> Out of curiosity I looked closer at the Weibu F3C. There is no entry
> in the UEFI-provided memory map which corresponds to the ESRT pointer,
> but hacking the code to map it anyway, the ESRT does appear to be
> valid with 2 entries.

And I read "valid with 2 entries" to mean it straddles across two memory
map entries, but what you're saying is it has two entries in the ESRT.

So the machine is buggy, but you're right.

Acked-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
        Peter
