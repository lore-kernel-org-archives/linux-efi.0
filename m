From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has been set
Date: Mon, 30 Oct 2017 09:00:29 +0000
Message-ID: <17798.1509354029@warthog.procyon.org.uk>
References: <1509027463.5886.26.camel@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk> <1508774083.3639.124.camel@linux.vnet.ibm.com> <20171026074243.GM8550@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509027463.5886.26.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, joeyli <jlee@suse.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Yes, that works.  Thanks!  Remember is_ima_appraise_enabled() is
> dependent on the "ima: require secure_boot rules in lockdown mode"
> patch - http://kernsec.org/pipermail/linux-security-module-archive/201
> 7-October/003910.html.

What happens if the file in question is being accessed from a filesystem that
doesn't have xattrs and doesn't provide support for appraisal?  Is it rejected
outright or just permitted?

David
