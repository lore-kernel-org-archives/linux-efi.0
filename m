From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Thu, 26 Oct 2017 15:42:43 +0800
Message-ID: <20171026074243.GM8550@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
 <1508774083.3639.124.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508774083.3639.124.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi Mimi,

Thank you for reviewing.

On Mon, Oct 23, 2017 at 11:54:43AM -0400, Mimi Zohar wrote:
> On Thu, 2017-10-19 at 15:51 +0100, David Howells wrote:
> > From: Chun-Yi Lee <joeyli.kernel@gmail.com>
> > 
> > When KEXEC_VERIFY_SIG is not enabled, kernel should not loads image
> > through kexec_file systemcall if securelevel has been set.
> 
> The patch title and description needs to be updated to refer to
> lockdown, not securelevel.
> 
> As previously mentioned the last time these patches were posted, this
> leaves out testing to see if the integrity subsystem is enabled.
> 
> Commit 503ceaef8e2e "ima: define a set of appraisal rules requiring
> file signatures" was upstreamed.  An additional patch could force
> these rules to be added to the custom policy, if lockdown is enabled.
>  This and other patches in this series could then check to see if
> is_ima_appraise_enabled() is true.
> 
> Mimi
>

I have updated the patch title and description, and I also added
is_ima_appraise_enabled() as the following. Is it good to you?

On the other hand, I am not good on IMA. I have traced the code path
in kimage_file_prepare_segments(). Looks that the READING_KEXEC_IMAGE
doesn't show in selinux_kernel_read_file(). Where is the exact code
in IMA for checking the signature when loading crash kernel file? 

Thanks a lot!
Joey Lee
---

>From 274a2125132ba5aff49e4ccd167f52982732361f Mon Sep 17 00:00:00 2001
From: "Lee, Chun-Yi" <jlee@suse.com>
Date: Thu, 26 Oct 2017 15:24:50 +0800
Subject: [PATCH] kexec_file: The integrity must be checked when the kernel is
 locked down

When KEXEC_VERIFY_SIG and IMA appraise are not enabled, kernel should
not allow that the image to be loaded by kexec_file systemcall when the
kernel is locked down.

The original code was showed in Matthew's patch but not in the later
patch set:
    https://lkml.org/lkml/2015/3/13/778

Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 kernel/kexec_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 9f48f44..b6dc218 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -255,6 +255,14 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
 
+	/* Don't permit images to be loaded into trusted kernels if we're not
+	 * going to check the integrity on them
+	 */
+	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) &&
+	    !is_ima_appraise_enabled() &&
+	    kernel_is_locked_down("kexec of unsigned images"))
+		return -EPERM;
+
 	/* Make sure we have a legal set of flags */
 	if (flags != (flags & KEXEC_FILE_FLAGS))
 		return -EINVAL;
-- 
2.6.2
