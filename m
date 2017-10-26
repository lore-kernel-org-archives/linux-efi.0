From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Thu, 26 Oct 2017 11:46:45 -0400
Message-ID: <1509032805.5886.52.camel@linux.vnet.ibm.com>
References: <20171026074243.GM8550@linux-l9pv.suse>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
         <1508774083.3639.124.camel@linux.vnet.ibm.com>
         <26694.1509030144@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26694.1509030144-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[Cc'ing Matthew Garrett]

On Thu, 2017-10-26 at 16:02 +0100, David Howells wrote:
> joeyli <jlee-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > +	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) &&
> > +	    !is_ima_appraise_enabled() &&
> > +	    kernel_is_locked_down("kexec of unsigned images"))
> 
> This doesn't seem right.  It seems that you can then kexec unsigned images
> into a locked-down kernel if IMA appraise is enabled.

Huh?!  With the "secure_boot" policy enabled on the boot command line,
IMA-appraisal would verify the kexec kernel image, firmware, kernel
modules, and custom IMA policy signatures.  With the "ima: require
secure_boot rules in lockdown mode" patch, the "lockdown" mode would
enable IMA-appraisal's secure_boot policy, without requiring the boot
command line option.  It would also add the secure_boot rules to the
custom policy, so that if the builtin policy is replaced with a custom
policy, the "secure_boot" policy would still be enforced.

Other patches in this patch series need to be updated as well to check
if IMA-appraisal is enabled.

Mimi
