From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v2 6/6] efi/arm*: add support to dump the EFI page tables
Date: Wed, 27 Apr 2016 21:12:39 +0100
Message-ID: <20160427201239.GT19428@n2100.arm.linux.org.uk>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160422170112.GS10606@leverpostej>
 <CAKv+Gu-abf2g5htQSHA=ETnSfzVExFLwsjs2Kbs8fn86MfFv3Q@mail.gmail.com>
 <20160422172513.GV10606@leverpostej>
 <CAKv+Gu9fOnKK66Ee7N_5UXbZh_cZbQ0AnnPLHQhm8qCb-r5gVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9fOnKK66Ee7N_5UXbZh_cZbQ0AnnPLHQhm8qCb-r5gVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 25, 2016 at 01:26:07PM +0200, Ard Biesheuvel wrote:
> Well, the problem here is that we only sync the EFI page tables with
> the kernel page tables in switch_mm() (if they turn out to be out of
> sync). This means we should either sync them in this code path as
> well, or remove the kernel VA range from the output, since we'll be
> dumping known stale data otherwise.

The kernel VA range can always be different - even at task switch time
we don't always update it.  We only update when there's something that
needs to be removed from the page table, and we're running on UP systems.

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
