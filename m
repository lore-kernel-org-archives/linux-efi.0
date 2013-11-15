From: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] arm: [U]EFI runtime services support
Date: Fri, 15 Nov 2013 10:04:22 -0800
Message-ID: <CAOesGMh+2Qs_cVMtdkpyXR44NJkQscs0eP_=pxwKXHkopaAKog@mail.gmail.com>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380799481-5470-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

On Thu, Oct 3, 2013 at 4:24 AM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> In systems based on [U]EFI-conformant firmware, runtime services provide
> a standardised way for the kernel to update firmware environment
> variables. This is used for example by efibootmgr to update which image
> should be loaded on next boot.
>
> This patchset implements basic support for UEFI runtime services on ARM
> platforms, as well as the basic underlying EFI support. It also defines
> a mechanism by which the required information is passed from the
> bootloader to the kernel via FDT entries.
>
> This patchset depends on the previously submitted early_ioremap() and
> generic UEFI config table scanning patchsets.
>
> Changes from v1:
> - Updated FDT bindings, based on feedback.
> - Use common config table scanning and address lookup code.
> - Add dependency on !CPU_BIG_ENDIAN (for now).
> - Add proper efi_enabled() facility.
> - Documentation updates.

This series is generally looking sane to me without looking at the
code in very close detail.

Do you have a test setup that you've been using for this that you
could give a pointer to?


-Olof
