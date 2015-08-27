From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFC 2/3] firmware_class: split out transaction helpers
Date: Thu, 27 Aug 2015 20:43:49 +0100
Message-ID: <20150827194349.GC3596@codeblueprint.co.uk>
References: <1430348859.2189.37.camel@HansenPartnership.com>
 <1430349052.2189.41.camel@HansenPartnership.com>
 <20150827144727.GB3596@codeblueprint.co.uk>
 <1440692717.2196.123.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440692717.2196.123.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Aug, at 09:25:17AM, James Bottomley wrote:
> On Thu, 2015-08-27 at 15:47 +0100, Matt Fleming wrote:
> > 
> > (Sorry, I'm coming to this incredibly late)
> > 
> > This patch is pretty neat and I wish something like this had existed
> > when I originally wrote the EFI capsule patches.
> > 
> > James, do you have any plans to resubmit this as a non-RFC? If not, do
> > you mind if I pick this up and rebase my capsule patches ontop of it?
> 
> Sort of, but I was stalled trying to work out how to combine with your
> capsule patches.  If you're going to do that work, I can resubmit my
> stuff as a patch with all the changes based on the review comments and
> then you can do the real work ...

Yeah, that sounds great. I'm happy to respin my patches on top.

-- 
Matt Fleming, Intel Open Source Technology Center
