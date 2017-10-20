From: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/27] uswsusp: Disable when the kernel is locked down
Date: Sat, 21 Oct 2017 03:29:00 +0400 (+04)
Message-ID: <alpine.LFD.2.20.1710210328510.9435@t440>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842470227.7923.15293760935442172683.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150842470227.7923.15293760935442172683.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Oct 2017, David Howells wrote:

> From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> 
> uswsusp allows a user process to dump and then restore kernel state, which
> makes it possible to modify the running kernel.  Disable this if the kernel
> is locked down.
> 
> Signed-off-by: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Reviewed-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
James Morris
<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
