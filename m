From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/30] kexec_file: Restrict at runtime if the kernel is locked down
Date: Thu, 11 Jan 2018 12:43:20 +0000
Message-ID: <12880.1515674600@warthog.procyon.org.uk>
References: <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111115915.dejachty3l7fwpmf-Q+Z4OdfSLAKN3ZZ/Hiejyg@public.gmane.org>
Content-ID: <12879.1515674600.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org> wrote:

> I don't like the idea that the lockdown (which is a runtime
> thing) requires a compile time option (KEXEC_VERIFY_SIG) that
> forces the verification even when the kernel is then not locked
> down at runtime.

It doesn't.  The EPERM only triggers if:

 (1) File signatures aren't mandatory (ie. CONFIG_KEXEC_VERIFY_SIG) is not
     set, and

 (2) you're not using IMA appraisal to validate the file contents, and

 (3) lockdown mode is enabled.

If file signatures are mandatory or IMA appraisal is in use, then the lockdown
state doesn't need to be checked.

David
