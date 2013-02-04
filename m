From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: CONFIG_GOOGLE_SMI and efivars
Date: Mon, 04 Feb 2013 12:29:39 +0000
Message-ID: <1359980979.7515.118.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359738442.7515.82.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAGTjWtBojr32cbtT8szjDt8+134KFZ7t8Ce-nEcdJ5T2PPikcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGTjWtBojr32cbtT8szjDt8+134KFZ7t8Ce-nEcdJ5T2PPikcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-02-01 at 09:37 -0800, Mike Waychison wrote:
> On Fri, Feb 1, 2013 at 9:07 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > Hey Mike,
> >
> > I'm taking a look at the google/gsmi.c code and wondering whether the
> > CONFIG_GOOGLE_SMI machines are expecting to use both the EFI variable
> > ops in google/gsmi.c and efivars.c simultaneously?
> 
> No.  On our systems that use gsmi.c, we wind up _not_ using the ops in
> efivars.c (the regular way to get access to these variables) and use
> those in gsmi.c instead.   We shouldn't ever need to use both
> simultaneously -- the gsmi stuff is effectively glue to get at the EFI
> variables in a non-standard way.  We do this due to a series of
> complications on our end that I can't get into here, but the effect is
> that for many of our machines, boots *look like* legacy boots
> (non-EFI), but we use gsmi to get at EFI state that isn't otherwise
> available.

Interesting!

> > If not, why do we
> > hang so much state off of "struct efivars"?
> 
> This was done to reduce code duplication -- I needed a way to get at
> these non-standard-access EFI vars in a clean way and didn't want to
> invent new/duplicate userland ABIs to do so.
> 
> At the time, I refactored so that all state into "struct efivars" to
> clearly delineate state from the regular efivars code and the gsmi
> code I was introducing. There isn't an actual need to have
> register_efivars() work more than once on any given system though.
> 
> > If these two backends *are*
> > meant to work at the same time, what happens with things like the pstore
> > code, which will only work with the first EFI variable backend to be
> > registered? I think it's the coupling/duplication all this sysfs glue
> > that is confusing me.
> 
> We don't expect to boot and use both sets of ops, ever.

That simplifies things *immensely*. Thanks! What we really need to do is
make it impossible to select more than one EFI variable frontend, so you
can have either have efivarfs, or the sysfs EFI code, or the gsmi code.
No synchronisation is done between any of these frontends at present, so
it's confusing to give the illusion that they work simultaneously - they
don't.

> > The reason I'm looking at this is because the new efivarfs filesystem
> > hard-codes access to the __efivars symbol as it just wants to access the
> > variable ops and serialising lock. It doesn't need any of the sysfs
> > glue. But it seems rather mean that efivarfs doesn't work with gsmi.c,
> > since there's no reason it shouldn't work. So I'm trying to understand
> > your usecases and arrive at a solution that doesn't break your machines,
> > before I start chainsawing things to kingdom come.
> 
> It sounds like it shouldn't be too difficult to make efivarfs work for
> our case as well :)

Nope, it wasn't. I've cooked something up that should hopefully make
this work for CONFIG_GOOGLE_SMI too. I'll mail it out once I've done
rototilling the efivars code.

-- 
Matt Fleming, Intel Open Source Technology Center
