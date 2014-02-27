From: Alon Ziv <alon-lkml-iOy/dmW02wpAfugRpC6u6w@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 27 Feb 2014 09:54:34 +0000 (UTC)
Message-ID: <loom.20140227T104216-669@post.gmane.org>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com> <CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com> <20140226222151.78854cd8@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

One Thousand Gnomes <gnomes@...> writes:
> Trusted is rather misleading. It's not trusted, it's *measured*.
> 
> It's the same bits you had when you made it, and when you booted it
> before. Whether you trust them is a different and quite unrelated
> question. You may have reasons to do either.

I believe mjg's point is that the patch implement's the kernel's view
of its trust requirements, and is thus independent of whether it is
measured or not.

Frankly, from my experience, the term "trust" is one of the most
confusing ones in the security field... In general, unlike the intuitive
definition, "trust" is a _negative_ feature.
To say it differently: a "Trusted Kernel" is "a kernel that believes
someone trusts it". It does _not_ mean the kernel is actually
_trustworthy_. A "measured" kernel is one way for it to be trustworthy -
but you cannot trust the kernel to tell you if it is measured. (This is
a classic case of the Epimenides paradox: if the kernel is untrustworhy,
it will always claim to be trusted.)

-Alon
