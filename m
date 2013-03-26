From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: efi: be more paranoid about available space when creating
 variables
Date: Tue, 26 Mar 2013 15:43:59 +0000
Message-ID: <20130326154359.GA20530@srcf.ucam.org>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
 <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
 <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
 <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
 <514E31B0.4030305@intel.com>
 <20130326035600.GA6209@srcf.ucam.org>
 <51517A59.30002@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51517A59.30002@console-pimps.org>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Ben Hutchings <ben@decadent.org.uk>, Josh Boyer <jwboyer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 26, 2013 at 10:37:13AM +0000, Matt Fleming wrote:

> Hmm... I'm not convinced this will provide a long-term solution. Is there
> anything that mandates that the size of all variables has to correlate
> sensibly
> with the results from QueryVariableInfo()? Even if there is in theory, I
> doubt
> it'll be true everywhere in practice, and trying to workaround
> implementation
> bugs in our workarounds for other bugs is the path to madness.

I'm not quite clear what you mean. We have a fairly solid idea as to 
what the underlying problem here is, and I don't think this makes any 
more assumptions than the existing code does.

> We can't continue this approach where we attempt to guess how the firmware
> implements variable storage, because as we've seen, there are various
> schemes
> out there. We're taking one step forward and two steps backwards at the
> moment
> with these kinds of patches. As you've seen, it's like playing
> whac-a-mole :-(

That's always been the way we end up dealing with firmware interactions. 
Read the git log for the ACPI video driver for an example...

> I think, rather unfortunately, it comes down to solving these problems on a
> case-by-case basis. We've tried broad, all-encompassing solutions, but
> they're
> just not working. Lets contain the damage with a blacklist, because even
> if the
> list is really vague, i.e. "Apply size checks for all Samsung and Lenovo
> machines with Phoenix BIOS", it's still more relaxed than what we have
> now, and
> there's more chance of finding a single way to reliably workaround the
> bug if
> we restrict it to one IBV and a couple of OEMs.

I'm kind of reluctant, because the cost of getting this wrong is 
hardware damage. Right now we believe that we're resistant to hardware 
damage but have introduced another problem in the process. If we can 
find a way to satisfy both constraints then I think that that's 
worthwhile.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
