From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v1 4/6] vmbus: Switch to use new generic UUID API
Date: Mon, 24 Jul 2017 17:54:13 +0200
Message-ID: <20170724155413.GB17917@lst.de>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-5-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719182857.73693-5-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 19, 2017 at 09:28:55PM +0300, Andy Shevchenko wrote:
> There are new types and helpers that are supposed to be used in new code.
> 
> As a preparation to get rid of legacy types and API functions do
> the conversion here.

Can you split the uapi changes into a separate patch?

I'd love to kill the guid_le userspace exposure, but I'd also like to
see how current userspace uses them.  Obviously your change is not
a break in the ABI, but it is a break in the API.  I would prefer if
we could not expose it, but I'd like to hear feedback from the consumers
of these UAPI headers - the fields aren't used in kernel space at all,
but userspace might be using it, and we'll need to look into alternatives
for it.
