From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 2/2] Fix efi_call
Date: Mon, 16 May 2016 11:24:55 -0500
Message-ID: <20160516162455.GD98477@stormcage.americas.sgi.com>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-3-git-send-email-athorlton@sgi.com>
 <20160512064835.GB30717@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512064835.GB30717-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, May 12, 2016 at 08:48:35AM +0200, Ingo Molnar wrote:
> I suppose the SGI/UV code is the only one using 7 arguments or more? Might make
> sense to point that out in the changelog.

First off, to everybody, sorry for the delayed responses.  I've been
AFK for a few days and forgot to set my vacation notice :(

Yes, I believe that's it.  I didn't do a full audit, but a quick glance
at the other users of this call showed that nobody else appears to be
using that many args.

> Just curious, how did you find this bug? It's a pretty obscure one, of the 
> 'developer tears out hairs from frustruation' type ...

Yes, this one was a real puzzle to figure out.  Basically I just stepped
through the assembly code from a known good point to see how we ended up
where we did.  I quite a bit of help from the vets around here, as well
as from our simulator that I used to step through our early boot code to
find the problem.

The real hair pulling mostly came from trying to figure out *WHY* we
were putting the return address in this seemingly random spot on the
stack.  After thoroughly re-reading assorted Intel (et. al.) docs about
a hundred times, I was able to piece together what I thought was
supposed to be going on here.  The solution may be simple, but arriving
there was anything but that :)

- Alex
