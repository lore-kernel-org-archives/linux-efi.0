From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Mon, 4 Aug 2014 16:21:55 +0100
Message-ID: <20140804152155.GL15082@console-pimps.org>
References: <1405062556-14540-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140804130011.GI15082@console-pimps.org>
 <CAKv+Gu-LQ9ahV5js0V5XgyRwUkrc3BOT9YoZj=mvwCEMQVXfow@mail.gmail.com>
 <20140804144957.GK15082@console-pimps.org>
 <CAKv+Gu_rcWtRtNPy5BHH7B4s0wDF3odN-=LD8YsnRCiDLGyFsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_rcWtRtNPy5BHH7B4s0wDF3odN-=LD8YsnRCiDLGyFsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 04 Aug, at 05:05:53PM, Ard Biesheuvel wrote:
> 
> I think that makes sense. As I said, I don't have a strong preference
> either way regarding the NMI handling, as it does not affect the
> systems I am primarily concerned with (and it sounds like a big hack
> anyway). What I /am/ concerned with is not getting code into the
> kernel that turns out to be non-compliant a couple of months down the
> road and having to fix it urgently then.

Right, that's a valid concern.
 
> So other than GetVariable and SetVariable, or there any other services
> that need the NMI treatment?

The one and only (potential) NMI-context caller of EFI runtime services
is efi_pstore_write(), which calls (as part of efivar_entry_set_safe())
QueryVariableInfo() and SetVariable().

-- 
Matt Fleming, Intel Open Source Technology Center
