From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/9] KEYS: Blacklisting & UEFI database load
Date: Wed, 07 Mar 2018 07:28:37 -0800
Message-ID: <1520436517.5558.2.camel@HansenPartnership.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <6eabbb43-295e-9ba0-c0d9-120f48aa0e1d@suse.cz>
         <1520428682.10396.445.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520428682.10396.445.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2018-03-07 at 08:18 -0500, Mimi Zohar wrote:
> On Tue, 2018-03-06 at 15:05 +0100, Jiri Slaby wrote:
> > what's the status of this please? Distributors (I checked SUSE,
> > RedHat and Ubuntu) have to carry these patches and every of them
> > have to forward-port the patches to new kernels. So are you going
> > to resend the PR to have this merged?
[...]
> Just because I trust the platform keys prior to booting the kernel,
> doesn't mean that I *want* to trust those keys once booted.  There
> are, however, places where we need access to those keys to verify a
> signature (eg. kexec kernel image).

Which is essentially the reason I always give when these patches come
back

> Nayna Jain's "certs: define a trusted platform keyring" patch set
> introduces a new, separate keyring for these platform keys.

Perhaps, to break the deadlock, we should ask Jiří what the reason is
the distros want these keys to be trusted.  Apart from the Microsoft
key, it will also give you an OEM key in your trusted keyring.  Is it
something to do with OEM supplied modules?

James
