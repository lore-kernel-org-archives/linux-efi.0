From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 26 Oct 2017 14:22:22 -0400
Message-ID: <1509042142.5886.61.camel@linux.vnet.ibm.com>
References: <29447.1509035858@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29447.1509035858-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-10-26 at 17:37 +0100, David Howells wrote:
> Hi James,
> 
> Can you pull this patchset into security/next please?
> 
> It adds kernel lockdown support for EFI secure boot.  Note that it doesn't yet
> cover:
> 
> 	bpf	- No agreement as to how
> 	ftrace	- Recently suggested, query sent to maintainer
> 	perf	- Not looked at yet.
> 
> and there are some changes recently proposed that make it work with IMA that
> I'll pass on as a follow up when we've fully worked them out.

There's a major difference between leaving out support and preventing
properly signed code from working properly.  We're already at -rc6.
I'm just not sure how there will be time to include the patches, test,
and send James a subsequent pull request before the next open window?

Mimi

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
