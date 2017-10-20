From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Sat, 21 Oct 2017 03:26:22 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210326100.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> From: Chun-Yi Lee <joeyli.kernel@gmail.com>
> 
> When KEXEC_VERIFY_SIG is not enabled, kernel should not loads image
> through kexec_file systemcall if securelevel has been set.
> 
> This code was showed in Matthew's patch but not in git:
> https://lkml.org/lkml/2015/3/13/778
> 


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>
