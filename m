From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM
 UEFI stub
Date: Thu, 10 Mar 2016 14:30:39 +0000
Message-ID: <20160310143039.GF15775@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160310082522.GB8618@gmail.com>
 <CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Mar, at 03:36:24PM, Ard Biesheuvel wrote:
> 
> Thank you. I am perfectly happy exercising some more caution here,
> though, considering that our past experiences involving reshuffling
> stub code for x86 were not a huge success (and broke Linus's laptop,
> among others')
> 
> I was very careful not to introduce cross-object data symbol
> references (which were the culprit before), and I tested both i386 and
> x86_64 to the extent feasible to me, but we'd need to confirm that
> those things are still fully correct before queuing this.

I agree 100% with Ard. It's far too late in the development cycle to
be introducing cross-architecture changes, and in particular, changes
to the code driving the early boot console.

I haven't reviewed the patches yet, but this is all v4.7 material.
