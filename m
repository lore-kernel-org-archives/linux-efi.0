From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has been set
Date: Thu, 02 Nov 2017 17:00:08 +0000
Message-ID: <11096.1509642008@warthog.procyon.org.uk>
References: <1509381838.3583.134.camel@linux.vnet.ibm.com> <1509032805.5886.52.camel@linux.vnet.ibm.com> <20171026074243.GM8550@linux-l9pv.suse> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk> <1508774083.3639.124.camel@linux.vnet.ibm.com> <26694.1509030144@warthog.procyon.org.uk> <32764.1509378584@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509381838.3583.134.camel@linux.vnet.ibm.com>
Content-ID: <11095.1509642008.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, joeyli <jlee@suse.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> At some point, we'll want to also require the initramfs be signed as well.

That could be tricky.  In Fedora, at least, that's assembled on the fly to
include just the drivers you need to be able to mount your root fs and find
the rest of your modules.  (Unless you mean just for the installer)

David
