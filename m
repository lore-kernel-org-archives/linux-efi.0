From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 2 Sep 2013 07:42:10 +0000 (UTC)
Message-ID: <loom.20130902T093547-621@post.gmane.org>
References: <1376900735.2322.26.camel@shinybook.infradead.org> <20130819125507.GA19093@srcf.ucam.org> <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com> <20130819160018.GA22532@srcf.ucam.org> <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com> <20130819172139.GA24393@srcf.ucam.org> <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com> <1376942994.2322.39.camel@shinybook.infradead.org> <20130819201952.GA28740@srcf.ucam.org> <1376943671.2322.40.camel@shinybook.infradead.org> <20130819203937.GA28967@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matthew Garrett <mjg59@...> writes:

> 
> On Mon, Aug 19, 2013 at 09:21:11PM +0100, David Woodhouse wrote:
> > On Mon, 2013-08-19 at 21:19 +0100, Matthew Garrett wrote:
> > > 
> > > We have no way to guarantee that. Most board vendors don't turn up to 
> > > the plugfests and aren't going to run anything we ship.
> > 
> > Oh well, let's just wring our hands and not bother to turn up to the
> > plugfest at all then. No point trying to *improve* the situation, after
> > all.
> 
> The plugfests have, from our perspective, always been useful in 
> identifying new implementation interpretations before hardware ships. 
> But even then, it's usually too late to modify the firmware. Vendors who 
> care about Linux compatibility have already tested Linux before we turn 
> up.
> 


Even if most vendors never bother testing at all, and even if a good number
of those that do use only the SCT and it hopefully gets extended to check
more things, for the ones who do care I feel having a 'disable all
workarounds' option would be useful.

Having multiple *independent* implementations, all verifying for both
interoperability (workarounds enabled) and correctness (workarounds
disabled) is *exactly* what plugfests are intended to do.

Coming to a plugfest and saying "Well, *my* code runs fine, but I'm not
going to tell you whether you're 'doing it right' or just 'doing it wrong in
a way we already know about'" is rather rude.
