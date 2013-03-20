From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Wed, 20 Mar 2013 20:37:36 +0000
Message-ID: <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
 <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1363806968.2580.86.camel-T0Mscta5zSJpk64qw6wm7cxtgHpCUUYS@public.gmane.org>
Content-Language: en-US
Content-ID: <C17806DEE14C634C8D6F11E7ECF7DD2B-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-20 at 15:16 -0400, Mimi Zohar wrote:
> On Wed, 2013-03-20 at 18:12 +0000, Matthew Garrett wrote:
> > Well, in the absence of hardcoded in-kernel policy, there needs to be
> > some mechanism for ensuring the integrity of a policy. Shipping a signed
> > policy initramfs fragment and having any Secure Boot bootloaders pass a
> > flag in bootparams indicating that the kernel should panic if that
> > fragment isn't present would seem to be the easiest way of doing that.
> > Or have I misunderstood the question?
> 
> Ok, I was confused by the term "fragmented" initramfs.  So once you have
> verified the "early" fragmented initramfs signature, this initramfs will
> load the "trusted" public keys and could also load the MAC policy. (I
> realize that dracut is currently loading the MAC policy, not the
> initramfs.)  The MAC policy would then be trusted, right?  Could we then
> use the LSM labels for defining an integrity policy for kexec?

Right, that'd be the rough idea. Any further runtime policy updates
would presumably need to be signed with a trusted key.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
