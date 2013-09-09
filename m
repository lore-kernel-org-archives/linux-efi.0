From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 09 Sep 2013 16:30:47 -0400
Message-ID: <1378758647.2257.136.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org, jmorris@namei.org, linux-security-module@vger.kernel.org, David Lang <david@lang.hm>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-09-09 at 11:49 -0400, Matthew Garrett wrote:
> Some use cases require the ability to ensure that anything running in ring 0
> is trusted code. We have support for signing the kernel and kernel modules,
> but there's still a range of exported kernel interfaces that make it easy to
> modify the running kernel. Previous attempts to implement a generic interface
> to restrict this have included a new capability (breaks existing userspace)
> and tying it to a requirement for signed modules (breaks assumptions in
> certain situations where userspace is already running with restricted
> privileges).
> 
> So, this is my final attempt at providing the functionality I'm interested
> in without inherently tying it to Secure Boot. There's strong parallels
> between the functionality that I'm interested in and the BSD securelevel
> interface, so here's a trivial implementation. 

Thank you for not tying this functionality to UEFI secure boot.  There
are, and will continue to be, many systems out there that don't support
UEFI secure boot, yet would be interested in this functionality.

As David Lang aptly said, "... security is not a binary thing, just
because there is one hole, it isn't worthless to close another one."

Mimi

