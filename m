From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 26 Feb 2014 22:21:51 +0000
Message-ID: <20140226222151.78854cd8@alan.etchedpixels.co.uk>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> > kernel was trusted - untrusted userspace could have set it on an untrusted
> > kernel, but by the same metric an untrusted kernel could just set it itself.
> >
> > If people object to this name then I swear to god that I will open a poll
> > on Phoronix to decide the next attempt and you will like that even less.

Go on open the poll -  I dare you. But don't be shocked if it ends up
being called "Eric" or "Icanhazsigs" 8)

> For the Chrome OS use-case, it might be better described as "untrusted
> userspace", but that seems unfriendly. :) The "trusted kernel" name
> seems fine to me.

Trusted is rather misleading. It's not trusted, it's *measured*.

It's the same bits you had when you made it, and when you booted it
before. Whether you trust them is a different and quite unrelated
question. You may have reasons to do either.

Alan
