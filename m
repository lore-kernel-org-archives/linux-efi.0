From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 00/13] First batch of EFI updates for v4.13
Date: Mon, 5 Jun 2017 17:53:15 +0200
Message-ID: <20170605155315.4itewwfjhl5ac7c5@gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu8RCwmwifH5nONSi4BkkA0d5oNZP9uX0iBagXOOXe7tpA@mail.gmail.com>
 <20170605090755.6hf2b7hqgvfn44ao@gmail.com>
 <CAKv+Gu8fDd5Gb-8MNCErnyfO=Lhw4D9JewEPUqahu9LDJaJifg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8fDd5Gb-8MNCErnyfO=Lhw4D9JewEPUqahu9LDJaJifg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> > It would be nice to fix your SOB flow: the maintainer who queues up a patch should
> > add the SOB, and add an Acked-by of the co-maintainer if the co-maintainer agrees
> > with the patch as well. The tree should typically not be rebased after that point
> > (especially not by the other co-maintainer) - that's just indicative of a messy
> > workflow.
> 
> OK, so this is exactly what we have in the queue right now, and what I
> sent the pull request for.

Ok, the SOB chains are perfect - and I've started applying the patches to 
tip:efi/core.

Most of them are looking good, except #1 which won't apply. There were a few small 
details in changelogs that I have fixed up in place.

Will push out the rest if they pass testing.

Thanks,

	Ingo
