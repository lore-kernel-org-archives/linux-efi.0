From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/7] efi: Print the secure boot status in x86 setup_arch() [ver #7]
Date: Fri, 03 Feb 2017 17:19:07 +0000
Message-ID: <24335.1486142347@warthog.procyon.org.uk>
References: <CAKv+Gu88XuQAb7aSmJ=b+u5LDfkE=dgWMwnKUd0U=qKSQXxdrQ@mail.gmail.com> <CAKv+Gu-=-piH7FQF92T6Yn4KUHLQ-C4CtexWe8D27Tuc3h8KdA@mail.gmail.com> <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk> <148587565838.4026.2835771993519594392.stgit@warthog.procyon.org.uk> <CAKv+Gu8otPYWcKw72zP2q+34JAzZ-QRy8xGFmbStO6WseeANdw@mail.gmail.com> <13280.1486138918@warthog.procyon.org.uk> <13531.1486139256@warthog.procyon.org.uk> <13569.1486139355@warthog.procyon.org.uk> <CAKv+Gu-O+nWmu2s8bCrANJs0JNE4QgaM=ZkSa+bu60C=-6T-Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu88XuQAb7aSmJ=b+u5LDfkE=dgWMwnKUd0U=qKSQXxdrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <24334.1486142347.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> OK, I have queued these patches (minus the DeployedMode one) in the
> next branch on efi.git. Please double check, I will send out a pull
> request to tip shortly (once the autobuilder gives me the green light)

Looks okay.  Now if I can just squeeze a fixed grub2 out of Peter Jones...

David
