From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 6/7] efi: runtime-wrapper: get rid of the rtc_lock
 spinlock
Date: Tue, 8 Dec 2015 12:48:54 +0000
Message-ID: <20151208124854.GC2518@codeblueprint.co.uk>
References: <1448967020-20190-1-git-send-email-ard.biesheuvel@linaro.org>
 <1448967020-20190-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448967020-20190-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Dec, at 11:50:19AM, Ard Biesheuvel wrote:
> The rtc_lock spinlock aims to serialize access to the CMOS RTC between
> the UEFI firmware and the kernel drivers that use it directly. However,
> x86 is the only arch that performs such direct accesses, and that never
> uses the time related UEFI runtime services. Since no other UEFI enlightened
> architectures have a legcay CMOS RTC anyway, we can remove the rtc_lock
> spinlock entirely.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 32 +++++---------------
>  1 file changed, 8 insertions(+), 24 deletions(-)

Is this really true? It's not possible, for instance, for 32-bit ARM
systems to use the rtc-cmos driver which would access the same
physical device that UEFI would with the GetTime() service?

With the pending 32-bit ARM UEFI support coming, this needs to be
considered carefully.
