From: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 08/30] kexec_file: Restrict at runtime if the kernel is
 locked down
Date: Thu, 11 Jan 2018 12:59:15 +0100
Message-ID: <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
 <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151024869793.28329.4817577607302613028.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

sorry for replying to such an old thread.

On Thu, Nov 09, 2017 at 05:31:38PM +0000, David Howells wrote:
> When KEXEC_VERIFY_SIG is not enabled, kernel should not load images through
> kexec_file systemcall if the kernel is locked down unless IMA can be used
> to validate the image.

I don't like the idea that the lockdown (which is a runtime
thing) requires a compile time option (KEXEC_VERIFY_SIG) that
forces the verification even when the kernel is then not locked
down at runtime.

Distribution kernels will then have KEXEC_VERIFY_SIG on and
everyone will need signed kexec images even when totally
uninterested in secureboot.

So instead of this patch, I propose the two followup patches that
split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE just as
we have with modules:

[PATCH 08a/30] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE
[PATCH 08b/30] kexec_file: Restrict at runtime if the kernel is locked down

Lockdown would not require KEXEC_SIG_FORCE but when enabled it
would check the signature.

Thanks,

-- 
Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, Prague, Czechia
