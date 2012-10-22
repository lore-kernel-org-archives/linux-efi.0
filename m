From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V2 08/10] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Date: Mon, 22 Oct 2012 14:22:28 +0100
Message-ID: <1350912148.4951.7.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-9-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348152065-31353-9-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2012-09-20 at 10:41 -0400, Matthew Garrett wrote:
> The firmware has a set of flags that indicate whether secure boot is enabled
> and enforcing. Use them to indicate whether the kernel should lock itself
> down.
> 
> Signed-off-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/x86/zero-page.txt  |  2 ++
>  arch/x86/boot/compressed/eboot.c | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c          |  3 +++
>  include/linux/cred.h             |  2 ++
>  5 files changed, 41 insertions(+), 1 deletion(-)

Probably wants an update to Documentation/x86/boot.txt too. But
otherwise,

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
