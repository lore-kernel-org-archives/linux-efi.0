From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix dummy variable buffer allocation
Date: Mon, 17 Jun 2013 11:08:16 +0100
Message-ID: <20130617100816.GA8569@console-pimps.org>
References: <1371414432.3321.7.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371414432.3321.7.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 16 Jun, at 09:27:12PM, Ben Hutchings wrote:
> 1. Check for allocation failure
> 2. Clear the buffer contents, as they may actually be written to flash
> 3. Don't leak the buffer
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Oops. This looks good to me, Ben. The writing of random kernel memory to
flash is particularly bad.

Matthew, care to Ack? I'll add this to my urgent queue.

-- 
Matt Fleming, Intel Open Source Technology Center
