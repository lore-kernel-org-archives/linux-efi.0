From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 00/29] EFI changes for v4.9
Date: Mon, 12 Sep 2016 13:42:30 +0200
Message-ID: <20160912114229.GA7597@gmail.com>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
 <20160912105813.GC3872@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160912105813.GC3872-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Fri, 09 Sep, at 04:18:22PM, Matt Fleming wrote:
> > Folks, please queue up the following patches for v4.9. There's more
> > work on refactoring EFI code to be architecture independent and the
> > largest number of patches is spent cleaning up the EFI memory map code
> > and allowing drivers on x86 to reserve EFI boot services for all of
> > runtime.
> > 
> > The architecture independent quest is going pretty well and it was
> > only a couple of lines to get the esrt driver working on arm64.
> > 
> > Other than that there's some cleanups and fixes, and a merge of the
> > out of tree EFI runtime driver from the FWTS project.
> 
> Ard just raised the point that some of the changes in this pull,
> particularly the conversion of the EFI runtime services from
> spinlock-protection to semaphore, would benefit enormously from
> testing in linux-next before the merge window.
> 
> Could someone please pull these changes into tip soon so that we can
> get as much testing done as possible?

Yeah, planned to do it over the weekend but got distracted - will do it later 
today.

Thanks,

	Ingo
