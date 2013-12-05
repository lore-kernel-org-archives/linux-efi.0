From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Thu, 5 Dec 2013 10:56:23 +0000
Message-ID: <20131205105623.GA3823@console-pimps.org>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
 <1385762647.3539.4.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385762647.3539.4.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 30 Nov, at 06:04:07AM, joeyli wrote:
> Does there have chance to test Borislav's EFI runtime mapping work on
> Dell Venue?
> 
> Borislav's patches here:
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi
> 
> I am sure his patchset can walkaround physical address accessing issue
> on a broken 64-bit machine. But, I didn't test it on 32-bit issue
> machine.

Unfortunately there's no guarantee that once you fix the physical
accesses the runtime services will work. I've got a 64-bit box that
returns vendor-specific error codes once physical address accesses are
handled.

-- 
Matt Fleming, Intel Open Source Technology Center
