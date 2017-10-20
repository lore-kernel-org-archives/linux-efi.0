From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is locked down
Date: Fri, 20 Oct 2017 21:48:16 +0100
Message-ID: <18499.1508532496@warthog.procyon.org.uk>
References: <20171020190939.569cedd2@alans-desktop> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020190939.569cedd2@alans-desktop>
Content-ID: <18498.1508532496.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:

> There are a load of standard tools that use this so I think you are going
> to need a whitelist. Can you at least log *which* MSR in the failing case
> so a whitelist can be built over time ?

Probably.  Is it just the file position for msr_write()?  Should the register
number increment with the copy loop?

What about for the X86_IOC_WRMSR_REGS ioctl?  What's the reg number there?

And do you know where wrmsr_safe_regs() might be found?  I can see things
using it and exporting it, but no implementation, so I'm guessing it's
macroised somewhere.

David
