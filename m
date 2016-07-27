From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V2 4/4] x86/efi: Use efi_exit_boot_services()
Date: Wed, 27 Jul 2016 19:08:39 +0100
Message-ID: <20160727180839.GJ31759@codeblueprint.co.uk>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
 <1469132894-17103-5-git-send-email-jhugo@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469132894-17103-5-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 21 Jul, at 02:28:14PM, Jeffrey Hugo wrote:
> The eboot code directly calls ExitBootServices.  This is inadvisable, and
> the eboot code attempts allocations after calling ExitBootSerives which is
> not permitted per the spec.  The efi_exit_boot_services() helper handles
> this scenario.
> 
> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 130 ++++++++++++++++++++-------------------
>  1 file changed, 67 insertions(+), 63 deletions(-)

FYI, this patch prevents my x86-64 test machines from booting. Of
course, because it's the early boot code there's no useful output on
the console other than "efi_main() failed!".

I'll debug further tomorrow.
