From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 17/24] acpi: Ignore acpi_rsdp kernel param when the
 kernel has been locked down
Date: Fri, 7 Apr 2017 14:31:07 +0800
Message-ID: <20170407063107.GA10451@dhcp-128-65.nay.redhat.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142341772.5101.12366553346604485034.stgit@warthog.procyon.org.uk>
 <CAJZ5v0j580XfGHd+GVQe+7vuSGyxFzfrDOjYfOcGTnKZSvjCoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j580XfGHd+GVQe+7vuSGyxFzfrDOjYfOcGTnKZSvjCoA@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On 04/06/17 at 09:43pm, Rafael J. Wysocki wrote:
> On Wed, Apr 5, 2017 at 10:16 PM, David Howells <dhowells@redhat.com> wrote:
> > From: Josh Boyer <jwboyer@redhat.com>
> >
> > This option allows userspace to pass the RSDP address to the kernel, which
> > makes it possible for a user to circumvent any restrictions imposed on
> > loading modules.  Ignore the option when the kernel is locked down.
> 
> I'm not really sure here.
> 
> What exactly is the mechanism?

Actually this acpi_rsdp param is created for EFI kexec reboot in old
days when we had not supported persistent efi vm space across kexec
reboot. At that time kexec reboot runs as noefi mode, it can not find
the acpi root table thus kernel will hang early.

Now kexec can support EFI boot so this param is not necessary for most
user unless they still use efi=old_map.

> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
