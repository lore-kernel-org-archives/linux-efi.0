From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: fwupdate
Date: Tue, 10 Mar 2015 10:56:32 -0400
Message-ID: <20150310145632.GA1208@fenchurch.internal.datastacks.com>
References: <20150302122955.GB24476@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
 <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AF4F2@PGSMSX102.gar.corp.intel.com>
 <CALCETrWKwQVe46gASNbb0miwcuHe+wirVSO-pQt6uF-Jd6e-bw@mail.gmail.com>
 <20150306081334.GA3514@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C2B8AF844@PGSMSX102.gar.corp.intel.com>
 <20150306144725.GF3514@pd.tnic>
 <20150309212322.GG9234@pd.tnic>
 <CAFECyb8xq+Ozn9Op4EHkiGGdn4q64h1fE_X+GHw=0X5d3r_9_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb8xq+Ozn9Op4EHkiGGdn4q64h1fE_X+GHw=0X5d3r_9_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 09, 2015 at 06:54:12PM -0700, Roy Franz wrote:
> On Mon, Mar 9, 2015 at 2:23 PM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> > + pjones.
> >
> > So reportedly, there is already a capsule-loading thing which doesn't
> > need the kernel at all:
> >
> > https://github.com/rhinstaller/fwupdate
> >
> > So why are we even wasting energy with this discussion here?
> >
> > --
> > Regards/Gruss,
> >     Boris.
> 
> The network boot case can be taken care of as Peter described (ie
> taking network device paths, instead of just file paths), so
> this should work for those cases as well.  There would be some extra
> setup, as for this to work the EFI firmware update program
> would need to be run at boot (via the BootNext variable), but I don't
> think this is unreasonable.
> It looks like GnuEFI now supports Aarch64, so building the firmware
> update utility shouldn't be a problem.  Peter - have you you tried
> building
> this on Aarch64 yet?  If not I'll give it a try.

I tried a very early version of the code on an Aarch64 machine where I
also wrote the firmware feature, and it basically seemed to work, modulo
my buggy firmware ;)  I haven't tried it recently, but I do have all the
right makefile goo in there to build it reasonably, and I don't know of
any reason it wouldn't work.

That said, I haven't sent my patch to add the capsule headers to gnu-efi
yet, so you won't get very far - I'll make sure and send those this
week, hopefully today.  Also note that fwupdate is still a very active
work in progress; it's not /quite/ ready for general purpose deployment
even in a "trying it out" phase, but I'm hoping to get to that point
this week or next - in particular the code on github right now assumes
an HD() device path with a specific partition guid.

That is, it has literally worked on two machines ever.  Yes, it's a
thing we intend on supporting, but it's not /there/ yet.

> I think there is some value in using runtime update capsule calls, as
> that will help make sure the feature works in the firmware.  I think
> with arm64 servers in an early stage of development, we can influence
> the firmware support of various features by using them.  I don't know
> that this is a sufficient reason, but if runtime capsules are never
> used then there is a good chance that there will be many broken
> implementations.

That's certainly potentially valid, but it doesn't necessarily yield
something we (the OS vendor deploying features to customers) can
actually depend on.  Usually firmware features like this become
generally usable when there's some market maker causing hardware vendors
to have a large interest in making sure the feature works.  That means
most often the carrot being dangled is MS Logo certification marketing
dollars, and the testing all follows from the situations they require to
work.  So far, it appears MS has been using this only from Boot
Services, so that's what works.  

It looks to me like that's probably likely to remain true.  One reason
is peripheral cards.  My expectation (though possibly unfounded) is that
MS will require peripheral cards to use this same update mechanism for
option ROMs, and even if they don't I know some vendors are working on
it.  To do so, the card's UEFI driver (supplied on the option ROM) will
be using EFI's Firmware Management Protocol (FMP) to participate in the
capsule update system.

The 2.5 spec drafts that include FMP and UpdateCapsule() support for FMP
state that capsule updates for FMP aren't required to be available
during runtime - it expressly calls out the case where
CAPSULE_FLAGS_PERSIST_ACROSS_RESET is used.  (I don't think I'm allowed
to quote language from drafts in public, but if you have a copy, I'm
talking about the last paragraph of 22.2.1)  In my mind this means most
implementations are going to always try to do updates from before
ExitBootServices() for those option types - anything else and you're
just in an error case where you have to do that anyway.

So again, I'm not dead-set against having a kernel implementation, but I
think its use cases are severely constrained, and most of the time most
implementations will want to do this before the kernel loads.  The best
case for doing it in the kernel is embedded devices where a) there's no
persistent storage except the flash part you're updating anyway, and b)
the vendor nominally controls both the firmware and the deployed OS.

-- 
        Peter, heading back to the code.
