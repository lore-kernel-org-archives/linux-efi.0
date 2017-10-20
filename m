From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 01/27] Add the ability to lock down access to the running
 kernel image
Date: Sat, 21 Oct 2017 03:19:14 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210318410.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842463996.7923.6815305873334959305.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <150842463996.7923.6815305873334959305.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> Provide a single call to allow kernel code to determine whether the system
> should be locked down, thereby disallowing various accesses that might
> allow the running kernel image to be changed including the loading of
> modules that aren't validly signed with a key we recognise, fiddling with
> MSR registers and disallowing hibernation,
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


Acked-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<james.l.morris@oracle.com>

