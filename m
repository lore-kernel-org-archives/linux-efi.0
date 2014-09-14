From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 6/6] x86/efi: introduce EFI_BOOT_SERVICES_WARN
Date: Sun, 14 Sep 2014 02:01:30 +0200
Message-ID: <20140914000130.GC18296@nazgul.tnic>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410633376-8822-7-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 13, 2014 at 11:36:16AM -0700, Ricardo Neri wrote:
> Being more verbose about this kind of illegal access from the firmware
> increases the likelihood of this kind firmware bugs to be fixed.

I sincerely hope you're right and, more importantly, how do we make sure
those warnings get seen in time for a fix to even be possible..?

-- 
Regards/Gruss,
    Boris.
--
