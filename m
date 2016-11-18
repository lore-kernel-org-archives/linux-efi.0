From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/16] efi: Add EFI_SECURE_BOOT bit
Date: Fri, 18 Nov 2016 17:28:01 +0000
Message-ID: <6528.1479490081@warthog.procyon.org.uk>
References: <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w@mail.gmail.com> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <147933287290.19316.3360403691390019935.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_8r3oM-jvvuSiXTzxp0YMEVgc5KkScJ2UhGTaXm28L6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <6527.1479490081.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> > @@ -1164,6 +1164,7 @@ void __init setup_arch(char **cmdline_p)
> >         if (boot_params.secure_boot &&
> >             IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
> >                 lock_kernel_down();
> > +               set_bit(EFI_SECURE_BOOT, &efi.flags);
> 
> Why is this x86 only?

It probably doesn't really need to be, but that's what the patches I ported
do.

> And why is this bit only set if CONFIG_EFI_SECURE_BOOT_LOCK_DOWN is enabled?

Actually, the EFI_SECURE_BOOT bit should probably be set outside of that
portion of the if-condition.

David
