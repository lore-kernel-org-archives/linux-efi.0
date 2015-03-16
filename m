From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] Revert "x86/mm/ASLR: Propagate base load address
 calculation"
Date: Mon, 16 Mar 2015 14:56:11 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1503161441280.25438@pobox.suse.cz>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org> <1425766041-6551-2-git-send-email-yinghai@kernel.org> <20150313122756.GA28855@gmail.com> <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg@mail.gmail.com> <20150314075357.GA8319@gmail.com>
 <20150314095923.GA3114@pd.tnic> <20150316100628.GD22995@pd.tnic>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150316100628.GD22995-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Mar 2015, Borislav Petkov wrote:

> On Sat, Mar 14, 2015 at 10:59:23AM +0100, Borislav Petkov wrote:
> > In addition to what you've said, I have only one proposal: we revert
> > the whole crap and do it again, this time nice and clean in tip. It'll
> > stay there as long as it has to. No half-arsed commit messages, no
> > misunderstood crap, no lala code f*ckery. Whatever it takes, as long as
> > it takes.
> 
> And here it is:
> 
> ---
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Date: Mon, 16 Mar 2015 10:57:56 +0100
> Subject: [PATCH] Revert "x86/mm/ASLR: Propagate base load address calculation"
> 
> This reverts commit f47233c2d34f243ecdaac179c3408a39ff9216a7.
> 
> The main reason for the revert is that in order to make this work, we
> need non-trivial changes to the x86 boot code which we didn't manage to
> get done in time for merging.
> 
> And even if we did, they would've been too risky so instead of rushing
> things and break booting 4.1 on boxes left and right, we will be very
> strict and conservative and will take our time with this to fix and test
> it properly.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

Agreed. Let's work on a better refresh for 4.1+. The fix attempts were 
quite chaotic.

Acked-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

-- 
Jiri Kosina
SUSE Labs
