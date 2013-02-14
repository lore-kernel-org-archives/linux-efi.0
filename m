From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by
 "noefi" boot parameter
Date: Thu, 14 Feb 2013 07:37:52 +0000
Message-ID: <1360827472.24917.35.camel@mfleming-mobl1.ger.corp.intel.com>
References: <511C2C04.2070108@jp.fujitsu.com> <511C3BDE.5060503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511C3BDE.5060503-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux EFI ml <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-stable ml <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux x86 ml <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-02-13 at 17:20 -0800, H. Peter Anvin wrote:
> On 02/13/2013 04:12 PM, Satoru Takeuchi wrote:
> > From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > 
> > There was a serious problem in samsung-laptop that its platform driver is
> > designed to run under BIOS and running under EFI can cause the machine to
> > become bricked or can cause Machine Check Exceptions.
> > 
> 
> Matt, unless you object I'll pick this one up as urgent, please take the
> cleanup patch in normal order.

No objection from me, this looks correct.
