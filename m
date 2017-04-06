From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Thu, 06 Apr 2017 09:41:00 +0100
Message-ID: <14980.1491468060@warthog.procyon.org.uk>
References: <1491460792.1645.1.camel@suse.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk> <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1491460792.1645.1.camel@suse.com>
Content-ID: <14979.1491468060.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: dhowells@redhat.com, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Oliver Neukum <oneukum@suse.com> wrote:

> Your swap partition may be located on an NVDIMM or be encrypted.

An NVDIMM should be considered the same as any other persistent storage.

It may be encrypted, but where's the key stored, how easy is it to retrieve
and does the swapout code know this?

> Isn't this a bit overly drastic?

Perhaps, but if it's on disk and it's not encrypted, then maybe not.

David
