From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: be more paranoid about available space when
 creating variables
Date: Mon, 04 Mar 2013 20:24:48 +0000
Message-ID: <1362428688.15011.1.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362271217-31747-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362271217-31747-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 2013-03-02 at 19:40 -0500, Matthew Garrett wrote:
> UEFI variables are typically stored in flash. For various reasons, avaiable
> space is typically not reclaimed immediately upon the deletion of a
> variable - instead, the system will garbage collect during initialisation
> after a reboot.
> 
> Some systems appear to handle this garbage collection extremely poorly,
> failing if more than 50% of the system flash is in use. This can result in
> the machine refusing to boot. The safest thing to do for the moment is to
> forbid writes if they'd end up using more than half of the storage space.
> We can make this more finegrained later if we come up with a method for
> identifying the broken machines.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efivars.c | 106 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 79 insertions(+), 27 deletions(-)

Thanks, applied and marked for stable.
