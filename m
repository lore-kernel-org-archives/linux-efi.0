From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Thu, 29 Sep 2016 01:54:34 +0200
Message-ID: <201609290154.34433.arnd@arndb.de>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474543806-19210-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thursday 22 September 2016, Ard Biesheuvel wrote:
> ================================================================================
> NOTE: this is a work in progress, and not fully functional yet. In particular,
> the actual MMC host protocol methods are stubbed out at the moment, and need to
> be wired up to the Linux device drivers.
> ================================================================================
> 
> On mobile and embedded systems, there is usually only a single MMC device for
> non-volatile storage, which sits behind a controller that is owned by the OS at
> runtime. This makes it difficult to host the UEFI variable store on MMC as well,
> since the UEFI runtime services routines expect ownership of the underlying
> device as well.
> 
> This series proposes an approach to work around this. It implements the UEFI
> MMC host protocol in the kernel, in a way that makes it possible to expose it
> to the firmware. At the same time, the firmware needs be set up for this, i.e.,
> it needs to expose its MMC host protocol pointer via a UEFI configuration table,
> so that the kernel can override it if it decides to expose this functionality
> to the firmware.
> 
> Note that these patches are based on patches in the EFI tree that are queued
> for v4.9, which replace the runtime wrappers spinlock with a semaphore. This
> allows us to sleep in the firmware callbacks.

Would it be possible to implement the UEFI varstore more generally on top
of the Linux pstore interface and then have a pstore backend on top of
MMC? That could give us very similar behavior, but also a bit more flexibility.
It would be a bit confusing to have the 'dmesg' pstore target on top of
UEFI varstore which in turn is on top of pstore on MMC, but I think that's
ok as long as we prevent recursion.

	Arnd
