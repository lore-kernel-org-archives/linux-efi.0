From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has been set
Date: Fri, 07 Apr 2017 10:17:18 +0100
Message-ID: <27362.1491556638@warthog.procyon.org.uk>
References: <1491551180.4184.50.camel@linux.vnet.ibm.com> <1491536950.4184.10.camel@linux.vnet.ibm.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk> <20170407030545.GA4296@dhcp-128-65.nay.redhat.com> <21572.1491548994@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1491551180.4184.50.camel@linux.vnet.ibm.com>
Content-ID: <27361.1491556638.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Chun-Yi Lee <jlee@suse.com>, gregkh@linuxfoundation.org, kexec@lists.infradead.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > Okay, fair enough.  I can stick in an OR with an IS_ENABLED on some IMA
> > symbol.  CONFIG_IMA_KEXEC maybe?  And also require IMA be enabled?
> 
> Not quite, since as Dave pointed out, IMA is policy driven.  As a
> policy is installed, we could set a flag.

Does such a flag exist as yet?

David
