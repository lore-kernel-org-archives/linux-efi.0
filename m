From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 17/24] acpi: Ignore acpi_rsdp kernel param when the kernel
 has been locked down
Date: Thu, 6 Apr 2017 21:43:54 +0200
Message-ID: <CAJZ5v0j580XfGHd+GVQe+7vuSGyxFzfrDOjYfOcGTnKZSvjCoA@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142341772.5101.12366553346604485034.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <149142341772.5101.12366553346604485034.stgit@warthog.procyon.org.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 5, 2017 at 10:16 PM, David Howells <dhowells@redhat.com> wrote:
> From: Josh Boyer <jwboyer@redhat.com>
>
> This option allows userspace to pass the RSDP address to the kernel, which
> makes it possible for a user to circumvent any restrictions imposed on
> loading modules.  Ignore the option when the kernel is locked down.

I'm not really sure here.

What exactly is the mechanism?

Thanks,
Rafael
