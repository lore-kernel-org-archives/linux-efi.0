From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Tue, 04 Jun 2013 13:29:41 +0800
Message-ID: <51AD7B45.1040603@redhat.com>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370117180-1712-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: rja-sJ/iWh9BUns@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 06/02/2013 04:06 AM, Matthew Garrett wrote:
> This patch reworks the UEFI anti-bricking code, including an effective
> reversion of cc5a080c and 31ff2f20. It turns out that calling
> QueryVariableInfo() from boot services results in some firmware
> implementations jumping to physical addresses even after entering virtual
> mode, so until we have 1:1 mappings for UEFI runtime space this isn't
> going to work so well.
>
> Reverting these gets us back to the situation where we'd refuse to create
> variables on some systems because they classify deleted variables as "used"
> until the firmware triggers a garbage collection run, which they won't do
> until they reach a lower threshold. This results in it being impossible to
> install a bootloader, which is unhelpful.
>
> Feedback from Samsung indicates that the firmware doesn't need more than
> 5KB of storage space for its own purposes, so that seems like a reasonable
> threshold. However, there's still no guarantee that a platform will attempt
> garbage collection merely because it drops below this threshold. It seems
> that this is often only triggered if an attempt to write generates a
> genuine EFI_OUT_OF_RESOURCES error. We can force that by attempting to
> create a variable larger than the remaining space. This should fail, but if
> it somehow succeeds we can then immediately delete it.
>
> I've tested this on the UEFI machines I have available, but I don't have
> a Samsung and so can't verify that it avoids the bricking problem.

This patch works well on my Dell Windows 8 logo machine.

This Dell machine will use up ~2K nvram space on each reboot and do 
garbage collection at boot time when full. With the new 5K threshold, it 
is only a few reboots away from boot time garbage collection anyway.

Run time garbage collection also works. But the write takes 5 seconds.


Lingzhu Xiang
