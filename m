From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 1/3] efi: Determine how much space is used by boot
 services-only variables
Date: Fri, 12 Apr 2013 20:19:13 +0800
Message-ID: <5167FBC1.2090609@redhat.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365615967-27346-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/11/2013 01:46 AM, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot services.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the results
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfully,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stub
> up to the efivars code, letting us calculate a reasonably accurate value.
>
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

I just tried this 3.9-rc6 with this patchset with pstore fulling up 
space and various attempts to manually fulling up space. So far I've 
been able to delete variables and continue creating variables.

Since QueryVariableInfo is no longer trusted and the accounting is done 
by the kernel, I'm somewhat concerned that variables can be repeatedly 
created and deleted until nvram is full of garbage to collect and the 
firmware hits EFI_OUT_OF_RESOURCES. Could this be any kind of problem?


Lingzhu Xiang
