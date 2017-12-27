From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 0/2] EFI updates for v4.15
Date: Wed, 27 Dec 2017 19:46:51 +0100
Message-ID: <20171227184651.ma4dsoi3a77arjxu@gmail.com>
References: <20171025101419.26369-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu9UniZugun1LAJCUc0_NsMWDP3RLn4sLxRbvbTN0ocycA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9UniZugun1LAJCUc0_NsMWDP3RLn4sLxRbvbTN0ocycA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> On 25 October 2017 at 11:14, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:
> >
> >   Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-next
> >
> > for you to fetch changes up to c19611def8fd3f524bc945f0e8f9becace8fdf06:
> >
> >   arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set (2017-10-16 16:21:26 +0100)
> >
> > ----------------------------------------------------------------
> > EFI changes for v4.15:
> > - ignore EFI_MEMORY_XP attributes on ARM if _RP/_WP are set as well
> > - a cosmetic pr_err() format string fix
> >
> > ----------------------------------------------------------------
> > Ard Biesheuvel (1):
> >       arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set
> >
> > Arvind Yadav (1):
> >       efi/capsule-loader: pr_err() strings should end with newlines
> >
> >  arch/arm64/kernel/efi.c               | 4 +++-
> >  drivers/firmware/efi/capsule-loader.c | 2 +-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Ingo,
> 
> It appears these patches have never made it into the TIP tree. Shall I
> just resend them as part of the pull request for v4.16?

Indeed - my mistake ...

Feel free to send them as efi/urgent material, or as v4.16 bits.

Thanks,

	Ingo
