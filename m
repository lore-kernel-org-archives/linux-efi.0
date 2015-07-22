From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Don't print an error on unsupported BGRT version.
Date: Wed, 22 Jul 2015 13:09:06 -0400
Message-ID: <20150722170906.GA17419@redhat.com>
References: <1437583253-29600-1-git-send-email-pjones@redhat.com>
 <20150722165357.GC1203@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150722165357.GC1203@jtriplet-mobl1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 22, 2015 at 09:53:57AM -0700, Josh Triplett wrote:
> On Wed, Jul 22, 2015 at 12:40:53PM -0400, Peter Jones wrote:
> > BGRT can legitimately be a different version from what we support, and
> > that's a problem with the driver not supporting something, not an error
> > that needs to be surfaced to the user.
> > 
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Are you actually seeing this error on a real system?  Or is this just a
> theoretical concern with some future version?

Yeah, I have several systems where I see it every boot - and with
"quiet", it's the only message I see.  In all cases the version is 0,
i.e. the code was written before it was included in the standard, and
it's a version the driver legitimately does not handle.  Admittedly
these are mostly machines for developing UEFI on (including the Intel
S1200RP board with the UDK2014 B2 firmware.)  But the fact is there are
systems you can *buy* which will show this as an error, and it really
isn't an error.  It's just an earlier version than we support.

> While I agree that this doesn't need to be pr_err, I don't think
> pr_debug is appropriate either.  It may mean the driver needs updating,
> or it may mean that a system in the wild is actually broken and has an
> invalid version number.  I'd prefer at least pr_warn so that people see
> it and report it, but I could live with pr_notice; that should hide it
> from systems booting in quiet mode, while still having it in the log
> even on non-debug kernels.

I'd be okay with pr_notice.  I'll send a follow-up.

-- 
        Peter
