From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 12/27] x86/msr: Restrict MSR access when the kernel is
 locked down
Date: Fri, 20 Oct 2017 19:09:39 +0100
Message-ID: <20171020190939.569cedd2@alans-desktop>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
        <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842472452.7923.2592278090192179002.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017 15:52:04 +0100
David Howells <dhowells@redhat.com> wrote:

> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Writing to MSRs should not be allowed if the kernel is locked down, since
> it could lead to execution of arbitrary code in kernel mode.  Based on a
> patch by Kees Cook.

There are a load of standard tools that use this so I think you are going
to need a whitelist. Can you at least log *which* MSR in the failing case
so a whitelist can be built over time ?

Alan
