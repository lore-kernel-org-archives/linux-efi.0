From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked
 down
Date: Thu, 02 Nov 2017 18:18:43 -0400
Message-ID: <1509661123.3416.29.camel@linux.vnet.ibm.com>
References: <1509658881.3416.10.camel@linux.vnet.ibm.com>
         <1509650031.3507.20.camel@linux.vnet.ibm.com>
         <1509130095.3716.13.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
         <20240.1509643356@warthog.procyon.org.uk>
         <12321.1509658211@warthog.procyon.org.uk>
         <14108.1509660067@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <14108.1509660067@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-11-02 at 22:01 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Right, it would never get here if the IMA signature verification
> > fails.  If sig_enforce is not enabled, then it will also work.  So the
> > only case is if sig_enforced is enabled and there is no key.
> > 
> > eg.
> >          else if (can_do_ima_check && is_ima_appraise_enabled())
> >                 err = 0;
> 
> I'm not sure where you want to put that, but I can't just do this:
> 
> 	/* Not having a signature is only an error if we're strict. */
> 	if (err == -ENOKEY && !sig_enforce &&
> 	    (!can_do_ima_check || !is_ima_appraise_enabled()) &&

The above IMA checks aren't needed here.

> 	    !kernel_is_locked_down("Loading of unsigned modules"))
> 		err = 0;
> 	else if (can_do_ima_check && is_ima_appraise_enabled())
> 		err = 0;
> 
> because that'll print out a message in lockdown mode saying that you're not
> allowed to do that and then maybe do it anyway.

Then at least for now, document that even though kernel modules might
be signed and verified by IMA-appraisal, that in lockdown mode they
also require an appended signature.

Mimi

