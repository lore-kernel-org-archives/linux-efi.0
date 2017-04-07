From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/24] kexec_file: Disable at runtime if securelevel has
 been set
Date: Fri, 7 Apr 2017 16:42:42 +0800
Message-ID: <20170407084242.GB11402@dhcp-128-65.nay.redhat.com>
References: <20170407061935.GB10100@dhcp-128-65.nay.redhat.com>
 <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142335441.5101.2294976563846442575.stgit@warthog.procyon.org.uk>
 <20170407030545.GA4296@dhcp-128-65.nay.redhat.com>
 <1491536950.4184.10.camel@linux.vnet.ibm.com>
 <21418.1491548875@warthog.procyon.org.uk>
 <20170407074159.GB10737@dhcp-128-65.nay.redhat.com>
 <1491553688.4184.73.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491553688.4184.73.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/07/17 at 04:28am, Mimi Zohar wrote:
> On Fri, 2017-04-07 at 15:41 +0800, Dave Young wrote:
> > On 04/07/17 at 08:07am, David Howells wrote:
> > > Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > > > > +	/* Don't permit images to be loaded into trusted kernels if we're not
> > > > > > > +	 * going to verify the signature on them
> > > > > > > +	 */
> > > > > > > +	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) && kernel_is_locked_down())
> > > > > > > +		return -EPERM;
> > > > > > > +
> > > > > > >  
> > > > > 
> > > > > IMA can be used to verify file signatures too, based on the LSM hooks
> > > > > in  kernel_read_file_from_fd().  CONFIG_KEXEC_VERIFY_SIG should not be
> > > > > required.
> > > > 
> > > > Mimi, I remember we talked somthing before about the two signature 
> > > > verification. One can change IMA policy in initramfs userspace,
> > > > also there are kernel cmdline param to disable IMA, so it can break the
> > > > lockdown? Suppose kexec boot with ima disabled cmdline param and then
> > > > kexec reboot again..
> > > 
> > > I guess I should lock down the parameter to disable IMA too.
> > 
> > That is one thing, user can change IMA policy in initramfs userspace,
> > I'm not sure if IMA enforce the signed policy now, if no it will be also
> > a problem.
> 
> I'm not sure how this relates to the question of whether IMA verifies
> the kexec kernel image signature, as the test would not be based on a
> Kconfig option, but on a runtime variable.

I assumed one can change the policy to avoid kexec and initramfs check
And we use a global IMA status in the -EPERM check for the lockdown
checking.  But if there is some fine grained checking to ensure kernel
signature verification it should be fine.
> 
> To answer your question, the rule for requiring the policy to be
> signed is:  appraise func=POLICY_CHECK appraise_type=imasig
> 
> When the ability to append rules is Kconfig enabled, the builtin
> policy requires the new policy or additional rules to be signed.
>  Unfortunately, always requiring the policy to be signed, would have
> broken userspace.
> 
> Mimi
> 

Thanks
Dave
