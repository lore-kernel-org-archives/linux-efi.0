From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 05/27] kexec: Disable at runtime if the kernel is locked
 down
Date: Sat, 21 Oct 2017 03:22:41 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210322320.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842466996.7923.17995994984545441369.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842466996.7923.17995994984545441369.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that lock-down is meant to prevent. It makes sense to disable
> kexec in this situation.
> 
> This does not affect kexec_file_load() which can check for a signature on the
> image to be booted.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Dave Young <dyoung@redhat.com>
> cc: kexec@lists.infradead.org


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>

