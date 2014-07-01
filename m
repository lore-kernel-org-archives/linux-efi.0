From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi/x86: move UEFI Runtime Services wrappers to
 generic code
Date: Tue, 1 Jul 2014 14:48:31 +0100
Message-ID: <20140701134831.GE7539@console-pimps.org>
References: <1403777346-28629-1-git-send-email-ard.biesheuvel@linaro.org>
 <1403777346-28629-2-git-send-email-ard.biesheuvel@linaro.org>
 <20140701133033.GD7539@console-pimps.org>
 <CAKv+Gu_hyXaFEydpRQCB0vP260oJpFftytN_Ex++shMdpFpafg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_hyXaFEydpRQCB0vP260oJpFftytN_Ex++shMdpFpafg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Olivier Martin <olivier.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Jul, at 03:35:09PM, Ard Biesheuvel wrote:
> 
> I agree, but I kind of followed the example of the Kconfig symbols in
> the vicinity.
> So sure, rip it out. Or would you like me to do a v(n+1)?

Thanks. Nah, no need for another version, I'ved fixed this up in 'next',
but please do check the commits to make sure nothing untoward has
occurred.

-- 
Matt Fleming, Intel Open Source Technology Center
