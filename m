From: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 26 Oct 2017 21:20:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.20.1710262116270.27877@localhost>
References: <29447.1509035858@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29447.1509035858-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Oct 2017, David Howells wrote:

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

How useful is this really if it's incomplete?

And I think it really needs more testing in -next.


-- 
James Morris
<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
