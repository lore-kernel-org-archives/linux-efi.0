From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Date: Wed, 7 Jan 2015 12:56:39 +0000
Message-ID: <20150107125639.GL3827@bivouac.eciton.net>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
 <20150107120608.GJ3827@bivouac.eciton.net>
 <CAKv+Gu_k0_anqvm24P8J4WaMrFLMxOhQETAfUb6xmzaJ+Z2vBQ@mail.gmail.com>
 <20150107122515.GK3827@bivouac.eciton.net>
 <CAKv+Gu-aRkoRj5zVXrsBc0APCehZ9W926J6fxH380K9EURXe_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-aRkoRj5zVXrsBc0APCehZ9W926J6fxH380K9EURXe_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 07, 2015 at 12:30:27PM +0000, Ard Biesheuvel wrote:
> >> >> +     kernel_neon_begin();    /* disables preemption */               \
> >> >
> >> > Same nitpick.
> >> >
> >>
> >> Is there anything wrong with that?
> >
> > I said nitpick.
> >
> > My (very minor) objection is that a (very reasonable) comment is added
> > to existing functionality by a patch that adds new functionality. It
> > makes the git blame/praise output less clear.
> >
> >> Would you prefer the comment to be on a separate line?
> >
> > I would _prefer_ the comments to be a separate patch.
> > But again, a nitpick.
> >
> 
> Well, adding the comment is relevant to this patch, as we need to
> disable preemption now before switching to the new address space. In
> fact, it might be better even to drop the comment, and add an explicit
> (if redundant) preempt_disable/preempt_enable pair.

That would be more clear, yes.

/
    Leif
