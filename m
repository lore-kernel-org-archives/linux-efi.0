From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Fri, 27 Oct 2017 15:32:26 -0400
Message-ID: <1509132746.3729.9.camel@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
         <1508774083.3639.124.camel@linux.vnet.ibm.com>
         <20171026074243.GM8550@linux-l9pv.suse>
         <1509027463.5886.26.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509027463.5886.26.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-10-26 at 10:17 -0400, Mimi Zohar wrote:
> On Thu, 2017-10-26 at 15:42 +0800, joeyli wrote:
> > Hi Mimi,
> > 
> > Thank you for reviewing.
> > 
> > On Mon, Oct 23, 2017 at 11:54:43AM -0400, Mimi Zohar wrote:
> > > On Thu, 2017-10-19 at 15:51 +0100, David Howells wrote:
> > > > From: Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > 
> > > > When KEXEC_VERIFY_SIG is not enabled, kernel should not loads image
> > > > through kexec_file systemcall if securelevel has been set.
> > > 
> > > The patch title and description needs to be updated to refer to
> > > lockdown, not securelevel.
> > > 
> > > As previously mentioned the last time these patches were posted, this
> > > leaves out testing to see if the integrity subsystem is enabled.
> > > 
> > > Commit 503ceaef8e2e "ima: define a set of appraisal rules requiring
> > > file signatures" was upstreamed.  An additional patch could force
> > > these rules to be added to the custom policy, if lockdown is enabled.
> > >  This and other patches in this series could then check to see if
> > > is_ima_appraise_enabled() is true.
> > > 
> > > Mimi
> > >
> > 
> > I have updated the patch title and description, and I also added
> > is_ima_appraise_enabled() as the following. Is it good to you?
> 
> Yes, that works.  Thanks!  Remember is_ima_appraise_enabled() is
> dependent on the "ima: require secure_boot rules in lockdown mode"
> patch - http://kernsec.org/pipermail/linux-security-module-archive/201
> 7-October/003910.html.
> 
> The IMA "secure_boot" policy can be specified on the boot command line
> as ima_policy="secure_boot".  It requires kernel modules, firmware,
> kexec kernel image and the IMA custom policy to be signed.  In
> lockdown mode, these rules are enabled by default and added to the
> custom policy.
> 
> > On the other hand, I am not good on IMA. I have traced the code path
> > in kimage_file_prepare_segments(). Looks that the READING_KEXEC_IMAGE
> > doesn't show in selinux_kernel_read_file(). Where is the exact code
> > in IMA for checking the signature when loading crash kernel file?
> 
> kernel_read_file_from_fd() calls the security_kernel_read_file() and
> security_kernel_post_read_file() hooks, which call ima_read_file() and
> ima_post_read_file() respectively.

Hm, with "lockdown" enabled on the boot command line, I'm now able to
do the kexec load, but not the unload.  :/   After the kexec load with
the "--reuse-cmdline" option, the system reboots, but isn't in
"lockdown" mode.
