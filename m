From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Tue, 5 Aug 2014 15:14:17 +0100
Message-ID: <20140805141417.GQ15082@console-pimps.org>
References: <1407168960-30128-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140805120332.GO15082@console-pimps.org>
 <CAKv+Gu8tdHE_iE-1nv6d0TuuUTmpL5-rB3+Exht7jAdE+1jW=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8tdHE_iE-1nv6d0TuuUTmpL5-rB3+Exht7jAdE+1jW=A@mail.gmail.com>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Aug, at 02:14:38PM, Ard Biesheuvel wrote:
> 
> """
> Some of the assumptions underlying the decision whether locks are
> needed or not (e.g., SetVariable() against ResetSystem()) may not
> apply universally to all [new] architectures that implement UEFI.
> Rather than try to reason our way out of this, let's just implement at
> least what the spec requires in terms of locking.
> """

Thanks Ard, I've picked this commit up for the 'next' branch.

-- 
Matt Fleming, Intel Open Source Technology Center
