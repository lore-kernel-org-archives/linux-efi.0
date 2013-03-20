From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Wed, 20 Mar 2013 15:16:08 -0400
Message-ID: <1363806968.2580.86.camel@falcor1.watson.ibm.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
	 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
	 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
	 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
	 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
	 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363803158.2553.33.camel-tCUS0Eywp2Pehftex57rkxo58HMYffqeLoYNBG0abjxeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-20 at 18:12 +0000, Matthew Garrett wrote:
> On Wed, 2013-03-20 at 14:01 -0400, Mimi Zohar wrote:
> 
> > Sorry, I'm not sure to which work you're referring. If you're referring
> > to Dmitry's "initramfs with digital signature protection" patches, then
> > we're speaking about enforcing integrity, not MAC security.  
> 
> Well, in the absence of hardcoded in-kernel policy, there needs to be
> some mechanism for ensuring the integrity of a policy. Shipping a signed
> policy initramfs fragment and having any Secure Boot bootloaders pass a
> flag in bootparams indicating that the kernel should panic if that
> fragment isn't present would seem to be the easiest way of doing that.
> Or have I misunderstood the question?

Ok, I was confused by the term "fragmented" initramfs.  So once you have
verified the "early" fragmented initramfs signature, this initramfs will
load the "trusted" public keys and could also load the MAC policy. (I
realize that dracut is currently loading the MAC policy, not the
initramfs.)  The MAC policy would then be trusted, right?  Could we then
use the LSM labels for defining an integrity policy for kexec?

thanks,

Mimi
