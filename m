From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] arm: [U]EFI runtime services support
Date: Fri, 15 Nov 2013 19:54:58 +0100
Message-ID: <20131115185458.GA30374@rocoto.smurfnet.nu>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
 <CAOesGMh+2Qs_cVMtdkpyXR44NJkQscs0eP_=pxwKXHkopaAKog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOesGMh+2Qs_cVMtdkpyXR44NJkQscs0eP_=pxwKXHkopaAKog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Olof,

Many thanks for having a look.

On Fri, Nov 15, 2013 at 10:04:22AM -0800, Olof Johansson wrote:
> This series is generally looking sane to me without looking at the
> code in very close detail.

In the interest of full disclosure, I would like to point out that I
will be posting another version next week, based on the output of the
discussions around the DT bindings and documentation.
 
This set needs to be tested in combination with Roy's UEFI stub patches
is recommended, as this is the intended boot mechanism on UEFI
platforms. https://wiki.linaro.org/LEG/Engineering/Kernel/UEFI/EFIstub

> Do you have a test setup that you've been using for this that you
> could give a pointer to?

Well, I have been using vexpress ca9 and ca15_a7 (TC2), or the ARM
commercial software models (RTSM) of the same. I have also tested on
Arndale, but I don't know if that is fully supported by mainline yet.

Prebuilt UEFI images are available from
http://releases.linaro.org/13.09/components/kernel/uefi-linaro

efibootmgr is probably the best utility to test the runtime services,
if scanning the /sys entries are not sufficient. It builds for armhf
without modification.

/
    Leif
