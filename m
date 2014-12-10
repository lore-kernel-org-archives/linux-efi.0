From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: Shorten efi regions output
Date: Wed, 10 Dec 2014 11:46:28 +0100
Message-ID: <20141210104627.GA17053@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <20141210021741.GA3280@darkstar.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141210021741.GA3280-4/PLUo9XfK+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 10, 2014 at 10:17:41AM +0800, Dave Young wrote:
> I have same feeling with you, it is too long for most of people.
>
> Since the printk code are for EFI_DEBUG, they are around the #ifdef
> so I would like to see a kernel param like efi_debug=on, so only
> efi_debug is specified then these verbose messages are printed.
> Without the param kernel can print some basic infomation about the
> memory ranges.
>
> In arm64 code there's already a uefi_debug param it can be moved to
> general code so that there will be a goable switch.

Hmm, makes sense to me. Maybe we should really hide those behind a
debug switch, the question is whether asking the user to boot with
"efi_debug=on" in order to see the regions is ok. And I think it is ok
because we do that when debugging other stuff so I don't see anything
different here.

And then when they're disabled by default, we don't really need to
shorten them as they're pure debug output then.

Matt?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
