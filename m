From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Thu, 23 Jun 2016 14:17:38 +0100
Message-ID: <20160623131738.GH8836@leverpostej>
References: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
 <20160530211212.GG2984@codeblueprint.co.uk>
 <20160603100040.GJ9915@arm.com>
 <20160617211601.GN2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160617211601.GN2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 17, 2016 at 10:16:01PM +0100, Matt Fleming wrote:
> On Fri, 03 Jun, at 11:00:40AM, Will Deacon wrote:
> > 
> > Mark, Jeremy?
> > 
> > I've kept this patch marked as unread, but it's not clear to me (a) how
> > urgent it is (b) what tree it should go through and (c) whether it's the
> > right thing to do!
> 
> Ping? Anyone got an update here?

Sorry, I'd been meaning to come back to this.

As Ard noted, there are serious cases that this detects which we cannot
handle, and a WARN_ON for those is appropriate.

For the alignment of regions as required for permissions, I believe we
need clarification in the spec, and in the mean time I think we should
keep the WARN_ON.

To accurately report problems with differing attributes within a
(kernel) page, we need more comprehensive checks on the EFI memory map,
and potentially in some cases where we handle things dynamically at run
time. I haven't had the chance to delve into those yet.

So I guess for the timebeing this should stay as a WARN_ON, even if in
some cases it is spurious.

Thanks,
Mark.
