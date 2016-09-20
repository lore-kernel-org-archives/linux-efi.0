From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [GIT PULL 0/2] EFI urgent fixes
Date: Tue, 20 Sep 2016 16:27:19 +0100
Message-ID: <20160920152719.GJ2892@codeblueprint.co.uk>
References: <20160920144829.30873-1-matt@codeblueprint.co.uk>
 <57E153B1.3040907@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57E153B1.3040907-ZPxbGqLxI0U@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Douglas Hatch <doug.hatch-ZPxbGqLxI0U@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Scott J Norton <scott.norton-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Sep, at 11:20:17AM, Waiman Long wrote:
> On 09/20/2016 10:48 AM, Matt Fleming wrote:
> >Folks, please pull the following two fixes that address the boot hang
> >issue Waiman reported here,
> >
> >   https://lkml.kernel.org/r/57DF56D4.50304-ZPxbGqLxI0U@public.gmane.org
> >
> >The following changes since commit 3be7988674ab33565700a37b210f502563d932e6:
> >
> >   Linux 4.8-rc7 (2016-09-18 17:27:41 -0700)
> >
> >are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> >
> >for you to fetch changes up to 1297667083d5442aafe3e337b9413bf02b114edb:
> >
> >   x86/efi: Only map RAM into EFI page tables if in mixed-mode (2016-09-20 14:53:04 +0100)
> >
> >----------------------------------------------------------------
> >  * Fix a boot hang on large memory machines (multiple terabyte) caused
> >    by type conversion errors in the x86 pat code - Matt Fleming
> >
> >----------------------------------------------------------------
> >Matt Fleming (2):
> >       x86/mm/pat: Prevent hang during boot when mapping pages
> >       x86/efi: Only map RAM into EFI page tables if in mixed-mode
> >
> >  arch/x86/mm/pageattr.c         | 21 +++++++++++----------
> >  arch/x86/platform/efi/efi_64.c |  2 +-
> >  2 files changed, 12 insertions(+), 11 deletions(-)
> 
> Are you also going to send these fixes to the 4.6 and 4.7 stable trees as
> well?

I just checked and I failed to tag the first patch for stable, though
I did mean to. Yes, I'll send them to stable once they're merged.
