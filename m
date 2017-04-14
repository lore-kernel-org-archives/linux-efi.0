From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/24] x86: Restrict MSR access when the kernel is locked
 down
Date: Fri, 14 Apr 2017 20:30:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1704142028440.2327@nanos>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142339340.5101.1283602261267937893.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149142339340.5101.1283602261267937893.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, matthew.garrett@nebula.com, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, x86@kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 5 Apr 2017, David Howells wrote:

Can you please change the subsys in $subject to 'x86/msr:' ?

> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Writing to MSRs should not be allowed if the kernel is locked down, since
> it could lead to execution of arbitrary code in kernel mode.  Based on a
> patch by Kees Cook.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> cc: x86@kernel.org

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
