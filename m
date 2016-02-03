From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: efistub: drop __init annotation from
 handle_kernel_image()
Date: Wed, 3 Feb 2016 15:19:27 +0000
Message-ID: <20160203151927.GJ2597@codeblueprint.co.uk>
References: <1453979254-25374-1-git-send-email-ard.biesheuvel@linaro.org>
 <1453979254-25374-2-git-send-email-ard.biesheuvel@linaro.org>
 <20160128225809.GF2571@codeblueprint.co.uk>
 <CAKv+Gu9sE4oJrFmSK8sEjTrU8A7k53Hj1S1pTyCqyA5Gsba2Kw@mail.gmail.com>
 <20160129160006.GD2611@codeblueprint.co.uk>
 <CAKv+Gu96tdf8ZrGHDi_YKacsRF_b336Nu4Anh61j4u3Lg18BHg@mail.gmail.com>
 <20160202110821.GB2642@codeblueprint.co.uk>
 <CAKv+Gu_rvLMFF9ssdY4GCWpdcOwaXVsaCvBTYG30NS0zw5xBWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_rvLMFF9ssdY4GCWpdcOwaXVsaCvBTYG30NS0zw5xBWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 02 Feb, at 12:09:41PM, Ard Biesheuvel wrote:
> On 2 February 2016 at 12:08, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> >
> > What about,
> >
> > #define __init __compiletime_error("__init not supported in EFI boot stub")
> >
> 
> That only works for invocations, i.e., it needs to be used in header
> files, and will trigger the error if a call to the function remains
> after optimization. We want it at function definition time instead.

Good point.

OK, how about we just do the #undef, call it good, and I add the task
of printing some helpful error message to my growing TODO list?
