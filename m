From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Sat, 5 Aug 2017 14:41:21 -0700
Message-ID: <CACdnJuuT-LYsOcuiKUisMomicej-3Hk4-cgXziksj9B9V0xDMg@mail.gmail.com>
References: <20170804212010.15064-1-mjg59@google.com> <CAKv+Gu-fe-dw-UXZxen4909b=QOF=_RP-V6GHZ8A4u=iVaaqpw@mail.gmail.com>
 <CACdnJuvCjWLxGfXY-6tytyTr-v8s0TZb_48J5Pju9p5OUuREuQ@mail.gmail.com> <20170805173410.GB8872@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170805173410.GB8872-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 5, 2017 at 10:34 AM, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> Just an innocent question from a bystander, what's the downside of
> unconditionally requesting that memory be overwritten?  Does it
> prolong reboot noticeably?

Yes, it's just to avoid stalling reboot for as long as it takes to clear RAM.

> I've also wondered why you've chosen to put this in a separate file
> rather than the existing secureboot.c, my naive understanding is that
> TPM and SecureBoot is related but I'm not an expert on this.  It would
> allow you to reuse the existing get_efi_var() macro.

It's not related to Secure Boot (systems can have TPMs but not Secure
Boot, and vice versa), the spec is managed by a different body (TCG
rather than UEFI), and there'll be more TPM-related code for the boot
stub in future.
