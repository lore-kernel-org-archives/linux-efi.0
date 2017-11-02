From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/27] Enforce module signatures if the kernel is locked down
Date: Thu, 02 Nov 2017 22:01:07 +0000
Message-ID: <14108.1509660067@warthog.procyon.org.uk>
References: <1509658881.3416.10.camel@linux.vnet.ibm.com> <1509650031.3507.20.camel@linux.vnet.ibm.com> <1509130095.3716.13.camel@linux.vnet.ibm.com> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk> <20240.1509643356@warthog.procyon.org.uk> <12321.1509658211@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509658881.3416.10.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> Right, it would never get here if the IMA signature verification
> fails.  If sig_enforce is not enabled, then it will also work.  So the
> only case is if sig_enforced is enabled and there is no key.
> 
> eg.
>          else if (can_do_ima_check && is_ima_appraise_enabled())
>                 err = 0;

I'm not sure where you want to put that, but I can't just do this:

	/* Not having a signature is only an error if we're strict. */
	if (err == -ENOKEY && !sig_enforce &&
	    (!can_do_ima_check || !is_ima_appraise_enabled()) &&
	    !kernel_is_locked_down("Loading of unsigned modules"))
		err = 0;
	else if (can_do_ima_check && is_ima_appraise_enabled())
		err = 0;

because that'll print out a message in lockdown mode saying that you're not
allowed to do that and then maybe do it anyway.

David
