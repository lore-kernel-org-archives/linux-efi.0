From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 02/16] x86/efi: Add get and set variable to EFI
 services pointer table
Date: Wed, 19 Aug 2015 17:35:00 +0100
Message-ID: <20150819163500.GJ3233@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-3-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-3-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Aug, at 02:16:22PM, Lee, Chun-Yi wrote:
> Add get variable and set variable function to EFI services pointer
> table for supporting later functions of hibernate signature
> verification to keep the HMAC key in efi boot service variable.
> EFI boot stub needs get/set_variable functions for accessing key.
> 
> Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> Tested-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c   | 4 ++++
>  arch/x86/boot/compressed/head_32.S | 6 +++---
>  arch/x86/boot/compressed/head_64.S | 8 ++++----
>  arch/x86/include/asm/efi.h         | 2 ++
>  4 files changed, 13 insertions(+), 7 deletions(-)

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
