From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Tue, 8 Jul 2014 10:52:47 +0100
Message-ID: <20140708095247.GE27474@console-pimps.org>
References: <1404295802-28030-1-git-send-email-ard.biesheuvel@linaro.org>
 <1404295802-28030-2-git-send-email-ard.biesheuvel@linaro.org>
 <20140707202954.GC27474@console-pimps.org>
 <CAKv+Gu91CQADTQ8KMjXQPwVDvW1XkUYO2E5=Mu=aAtrB8B3q_A@mail.gmail.com>
 <CAKv+Gu8LbfuuEYyhAeu3dUiKHqzN_UFMbOjY0agVihbmmVL9CA@mail.gmail.com>
 <20140708092958.GD27474@console-pimps.org>
 <CAKv+Gu9HkJgsnzUAROVwPKaHGHRU9FwAp+eOT8N8kYDR3Dda+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9HkJgsnzUAROVwPKaHGHRU9FwAp+eOT8N8kYDR3Dda+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Jul, at 11:45:03AM, Ard Biesheuvel wrote:
> 
> Well, that is what is says in the comment:
>          * ops.get_next_variable() is only called from register_efivars()
>          * or efivar_update_sysfs_entries(),
>          * which is protected by the BKL, so that path is safe.
 
Oops, so it does. That's a stale comment. I'll update it.

> I agree. So shall I update my patch to add a single spin_lock that is
> used by all wrappers?
> We will likely need the wrappers on ARM as well, only ia64 needs
> another approach (if desired)

Please do, that would be great!

-- 
Matt Fleming, Intel Open Source Technology Center
