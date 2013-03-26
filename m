From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Tue, 26 Mar 2013 10:37:13 +0000
Message-ID: <51517A59.30002@console-pimps.org>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk> <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk> <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net> <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326035600.GA6209-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26/03/13 03:56, Matthew Garrett wrote:
> Ok, so having thought some more about the actual problem (ie, Samsungs 
> go wrong if there's too much used space marked as being active, not 
> merely too much used space) I think we really want to be looking for the 
> amount of active space rather than the remaining space value that 
> QueryVariableInfo() gives us. Something like this (absolutely untested, 
> provided here for comment) patch? I'll try rigging something up under 
> OVMF to test it. This version certainly seems a little over-naive, since 
> it won't handle the case of a variable that's being overwritten with 
> something of a different size.

Hmm... I'm not convinced this will provide a long-term solution. Is there
anything that mandates that the size of all variables has to correlate
sensibly
with the results from QueryVariableInfo()? Even if there is in theory, I
doubt
it'll be true everywhere in practice, and trying to workaround
implementation
bugs in our workarounds for other bugs is the path to madness.

We can't continue this approach where we attempt to guess how the firmware
implements variable storage, because as we've seen, there are various
schemes
out there. We're taking one step forward and two steps backwards at the
moment
with these kinds of patches. As you've seen, it's like playing
whac-a-mole :-(

I think, rather unfortunately, it comes down to solving these problems on a
case-by-case basis. We've tried broad, all-encompassing solutions, but
they're
just not working. Lets contain the damage with a blacklist, because even
if the
list is really vague, i.e. "Apply size checks for all Samsung and Lenovo
machines with Phoenix BIOS", it's still more relaxed than what we have
now, and
there's more chance of finding a single way to reliably workaround the
bug if
we restrict it to one IBV and a couple of OEMs.

-- 
Matt Fleming, Intel Open Source Technology Center
