From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Mon, 30 Oct 2017 08:01:40 -0400
Message-ID: <1509364900.3583.54.camel@linux.vnet.ibm.com>
References: <1509027463.5886.26.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
         <1508774083.3639.124.camel@linux.vnet.ibm.com>
         <20171026074243.GM8550@linux-l9pv.suse>
         <17798.1509354029@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17798.1509354029@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: joeyli <jlee@suse.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-10-30 at 09:00 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Yes, that works.  Thanks!  Remember is_ima_appraise_enabled() is
> > dependent on the "ima: require secure_boot rules in lockdown mode"
> > patch - http://kernsec.org/pipermail/linux-security-module-archive/201
> > 7-October/003910.html.
> 
> What happens if the file in question is being accessed from a filesystem that
> doesn't have xattrs and doesn't provide support for appraisal?  Is it rejected
> outright or just permitted?

IMA-appraisal returns -EACCES for any error, including lack of xattr
support.

Thiago Bauermann posted the "Appended signatures support for IMA
appraisal" patch set.  This patch set allows the current kernel module
appended signature format to be used for verifying the kernel image.
 Once that patch set is upstreamed, we'll be able to update the IMA
"secure_boot" policy to permit appended signatures.

Mimi
