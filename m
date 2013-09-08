From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sat, 7 Sep 2013 23:40:27 -0700
Message-ID: <20130908064027.GA3587@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1378252218-18798-9-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.

I see no match between kexec and signed kernel modules.

In fact, I personally _want_ signed kernel modules, and still the option
to run kexec.  kexec is to run a whole new kernel/OS, not a tiny kernel
module.

If you apply this, you break everyone who is currently relying on kexec
(i.e. kdump, bootloaders, etc.), from using signed kernel modules, which
personally, seems like a very bad idea.

Please just rely on the existing permission checks for kexec, to add on
another layer of restrictions seems unneeded, and will force some users
to have to patch this out.

thanks,

greg k-h
