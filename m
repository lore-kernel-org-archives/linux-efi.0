From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Wed, 27 Mar 2013 09:09:47 +0000
Message-ID: <5152B75B.5080305@console-pimps.org>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk> <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk> <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net> <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org> <51517A59.30002@console-pimps.org> <20130326154359.GA20530@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326154359.GA20530-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26/03/13 15:43, Matthew Garrett wrote:
> I'm not quite clear what you mean. We have a fairly solid idea as to 
> what the underlying problem here is, and I don't think this makes any 
> more assumptions than the existing code does.

Right, it doesn't make more assumptions, but the assumptions that the
existing code makes is causing problems, hence the need for your updated
patch. I'm fully expecting that the updated patch will also cause us
problems/require additional patches. I really don't want to keep
patching/tweaking this all the way to -rc6 and beyond.

Have you tested this patch against one of those machines that suffers
from the original bricking problem? Ben, does this patch fix your issue?
I dug my buggy-as-hell ASUS machine out from under my desk and it
suffers from the max_size == 0 problem which this patch doesn't fix, but
that's already been discussed.

> I'm kind of reluctant, because the cost of getting this wrong is 
> hardware damage. Right now we believe that we're resistant to hardware 
> damage but have introduced another problem in the process. If we can 
> find a way to satisfy both constraints then I think that that's 
> worthwhile.

I'm concerned we're going to end up introducing more constraints because
some other class of platforms doesn't work with this patch. It expects
DataSize and storage_size to correlate meaningfully, and I'm not at all
convinced that will be true everywhere, even though it's not an
unreasonable expectation.

Maybe we should leave the existing checks in place and create a
whitelist for those machines that absolutely must be able to write to
the variable store, e.g. to initiate garbage collection, or where
QueryVariableInfo() is known to be inaccurate, or where we know we can
have the full use of pstore without bricking the machine. Yes, we'll
have to maintain the whitelist and we'll no doubt get bug reports for
machines that need to be added to the list, but at least no one is going
to brick their laptops, and the fix is simply adding an ID to the list,
not reimplementing our workarounds with the risk of breaking X number of
machines that were previously working just fine.

-- 
Matt Fleming, Intel Open Source Technology Center
