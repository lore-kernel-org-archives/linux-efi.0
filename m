From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked
 down
Date: Sat, 21 Oct 2017 03:21:22 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210321120.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> If the kernel is locked down, require that all modules have valid
> signatures that we can verify.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>

