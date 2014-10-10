From: Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Date: Fri, 10 Oct 2014 18:55:49 +0300
Message-ID: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

1. Why x86 code isn't separated to another patch?
2. drivers/firmware/efi/reboot.c: efi_reboot():
    One shouldn't use "printk()" with no KERN_* stuff passed into it.
I'd recommend to use "pr_info()" macro or something like that.
