From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/16] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c. This code is now shared, so using a global
 variable as part of the interface is not that nice. Also, by avoiding any
 global variables in the ARM EFI stub, this allows the code to be position
 independent without requiring GOT fixups.
Date: Tue, 13 Aug 2013 09:56:29 -0400
Message-ID: <1376402189.27484.13.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-3-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-3-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   38 +++++++------
>  drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
>  2 files changed, 72 insertions(+), 62 deletions(-)

Tested on arm64.

Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
