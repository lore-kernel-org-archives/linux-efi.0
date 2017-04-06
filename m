From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/24] Add the ability to lock down access to the running kernel image
Date: Thu, 06 Apr 2017 11:43:20 +0100
Message-ID: <32240.1491475400@warthog.procyon.org.uk>
References: <alpine.LRH.2.20.1704061840090.12226@namei.org> <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk> <149141221365.31282.16276273075946694481.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1704061840090.12226@namei.org>
Content-ID: <32239.1491475400.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > +static __read_mostly bool kernel_locked_down;
> 
> How about marking this __ro_after_init if ALLOW_LOCKDOWN_LIFT is not 
> configured?

I guess lock_kernel_down() would need to be __init also in that case.

Also, the implementation of lift_kernel_lockdown() should be conditional on
CONFIG_ALLOW_LOCKDOWN_LIFT.

David
