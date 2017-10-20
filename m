From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 04/27] Restrict /dev/mem and /dev/kmem when the kernel
 is locked down
Date: Sat, 21 Oct 2017 03:21:54 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210321440.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150842466261.7923.14359746674406637357.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Allowing users to write to address space makes it possible for the kernel to
> be subverted, avoiding module loading restrictions.  Prevent this when the
> kernel has been locked down.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>
