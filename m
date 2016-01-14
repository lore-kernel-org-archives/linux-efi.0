From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: implement interruptible runtime services
Date: Thu, 14 Jan 2016 16:21:42 +0000
Message-ID: <20160114162142.GD3602@codeblueprint.co.uk>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
 <1450434591-31104-2-git-send-email-sylvain.chouleur@gmail.com>
 <20160106125846.GC2671@codeblueprint.co.uk>
 <CAD_mUW3gLnCV6NW0V-HPNUoMd9dS0wQnecXotpS4Vvij9ZrObg@mail.gmail.com>
 <20160108103837.GB2532@codeblueprint.co.uk>
 <CAD_mUW3gNhWcT02b_5+mhAx764eEFVNq7EWf5TnjngSEVFFvNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD_mUW3gNhWcT02b_5+mhAx764eEFVNq7EWf5TnjngSEVFFvNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Jan, at 02:57:13PM, Sylvain Chouleur wrote:
> 
> I understand, like I said above I'll modify efi_interruptible handlers to
> call legacy ones in case of panic context.
> I would like to avoid removing the panic part of this patch and take time
> to clean it before merging the whole.
 
OK, well at least split out the panic diddling into a separate patch
so that we can discuss the merits of it separately to the other, less
contentious changes.

> > Kconfig is a last resort because it's a build-time decision and
> > greatly limits the flexibility of the kernel. It becomes no longer
> > possible to run a single kernel image with various CONFIG_* enabled on
> > x86 hardware - you now need a special EFI_INTERRUPTIBLE build.
> >
> > Which apart from being a major headache for distributions in general
> > is generally frowned upon for the x86 architecture.
> >
> > If there's any way at all of making this a runtime decision that would
> > be much better.
> 
> I think the best would be to bind this driver with the one which receives the
> interrupts from CSE to write the variables. Then we would have a consistency
> on the feature.
> Does this seems ok for you?

I think that'd be an improvement, yeah.
