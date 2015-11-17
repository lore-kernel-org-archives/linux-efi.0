From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 11/12] ARM: wire up UEFI init and runtime support
Date: Tue, 17 Nov 2015 06:33:46 +0100
Message-ID: <CAKv+Gu8H5oqrke-TpMj9i00=OJpi82NKySF40yVQoOhXbaQvXA@mail.gmail.com>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447698757-8762-12-git-send-email-ard.biesheuvel@linaro.org>
	<20151116190156.GH8644@n2100.arm.linux.org.uk>
	<CAKv+Gu8w+2GA5tV4roYtEsza+mkCZKYX_=tT2t=+eh-ZO1Y2fA@mail.gmail.com>
	<20151116194812.GJ8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151116194812.GJ8644-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2015 at 20:48, Russell King - ARM Linux
<linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> wrote:
> On Mon, Nov 16, 2015 at 08:04:00PM +0100, Ard Biesheuvel wrote:
>> OK. So you mean set TTBR to the zero page, perform the TLB flush and
>> only then switch to the new page tables?
>
> Not quite.
>
> If you have global mappings below TASK_SIZE, you would need this
> sequence when switching either to or from the UEFI page tables:
>
> - switch to another set of page tables which only map kernel space
>   with nothing at all in userspace.
> - flush the TLB.
> - switch to your target page tables.
>

Doh. I am so used to always having two TTBR's available, but indeed,
we shouldn't pull the rug from under our feet.

> As I say in response to one of your other patches, it's probably
> much easier to avoid any global mappings below TASK_SIZE.

Let me look into that.

Thanks,
Ard.
