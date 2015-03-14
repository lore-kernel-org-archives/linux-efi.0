From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Sat, 14 Mar 2015 10:59:23 +0100
Message-ID: <20150314095923.GA3114@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150313122756.GA28855@gmail.com>
 <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg@mail.gmail.com>
 <20150314075357.GA8319@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314075357.GA8319-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 14, 2015 at 08:53:57AM +0100, Ingo Molnar wrote:
> You are still talking only about the low level code and about low
> level symptoms, while in contrast to that the primary question with...

<snip text which will be ignored again, unfortunately>

Thanks for doing that!

I really doubt it'll bring anything this time either but I don't care -
certainly I've wasted enough time trying to improve things as far as I
can so hell yeah, this bullshit has to stop!

In addition to what you've said, I have only one proposal: we revert
the whole crap and do it again, this time nice and clean in tip. It'll
stay there as long as it has to. No half-arsed commit messages, no
misunderstood crap, no lala code f*ckery. Whatever it takes, as long as
it takes.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
