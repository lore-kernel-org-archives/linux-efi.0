From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked down
Date: Mon, 30 Oct 2017 17:00:34 +0000
Message-ID: <3565.1509382834@warthog.procyon.org.uk>
References: <1509130095.3716.13.camel@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1509130095.3716.13.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This kernel_is_locked_down() check is being called for both the
> original and new module_load syscalls.  We need to be able
> differentiate them.  This is fine for the original syscall, but for
> the new syscall we would need an additional IMA check -
> !is_ima_appraise_enabled().

IMA can only be used with finit_module()?

David
