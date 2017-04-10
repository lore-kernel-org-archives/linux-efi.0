From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has been set
Date: Mon, 10 Apr 2017 14:19:52 +0100
Message-ID: <13679.1491830392@warthog.procyon.org.uk>
References: <1491568577.4184.97.camel@linux.vnet.ibm.com> <1491551180.4184.50.camel@linux.vnet.ibm.com> <1491536950.4184.10.camel@linux.vnet.ibm.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk> <20170407030545.GA4296@dhcp-128-65.nay.redhat.com> <21572.1491548994@warthog.procyon.org.uk> <27362.1491556638@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491568577.4184.97.camel@linux.vnet.ibm.com>
Content-ID: <13678.1491830392.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Chun-Yi Lee <jlee@suse.com>, gregkh@linuxfoundation.org, kexec@lists.infradead.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> From an IMA perspective, either a file hash or signature are valid,
> but for this usage it must be a signature.

Not necessarily.  If IMA can guarantee that a module is the same based on its
hash rather than on a key, I would've thought that should be fine.

David
