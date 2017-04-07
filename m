From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 17/24] acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down
Date: Fri, 07 Apr 2017 08:05:27 +0100
Message-ID: <21360.1491548727@warthog.procyon.org.uk>
References: <20170407063107.GA10451@dhcp-128-65.nay.redhat.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142341772.5101.12366553346604485034.stgit@warthog.procyon.org.uk> <CAJZ5v0j580XfGHd+GVQe+7vuSGyxFzfrDOjYfOcGTnKZSvjCoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170407063107.GA10451-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Content-ID: <21359.1491548727.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > > This option allows userspace to pass the RSDP address to the kernel, which
> > > makes it possible for a user to circumvent any restrictions imposed on
> > > loading modules.  Ignore the option when the kernel is locked down.
> > 
> > I'm not really sure here.
> > 
> > What exactly is the mechanism?
> 
> Actually this acpi_rsdp param is created for EFI kexec reboot in old
> days when we had not supported persistent efi vm space across kexec
> reboot. At that time kexec reboot runs as noefi mode, it can not find
> the acpi root table thus kernel will hang early.
> 
> Now kexec can support EFI boot so this param is not necessary for most
> user unless they still use efi=old_map.

Is this patch now unnecessary?

David
