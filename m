From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 06/24] Add a sysrq option to exit secure boot mode
Date: Sun, 16 Apr 2017 21:46:21 +0100
Message-ID: <20170416204621.GA24360@codeblueprint.co.uk>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142332458.5101.14654616837280513947.stgit@warthog.procyon.org.uk>
 <alpine.DEB.2.20.1704142003570.2327@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1704142003570.2327@nanos>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Apr, at 08:05:07PM, Thomas Gleixner wrote:
> On Wed, 5 Apr 2017, David Howells wrote:
> 
> > From: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Make sysrq+x exit secure boot mode on x86_64, thereby allowing the running
> > kernel image to be modified.  This lifts the lockdown.
> > 
> > Signed-off-by: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> 
> Matt, Ard?
> 
> Any opinions on this?

Looks OK to me.
