From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64: efi: make sure vmlinux load address aligned on
 2MBytes
Date: Wed, 28 Oct 2015 11:28:39 +0000
Message-ID: <20151028112839.GA24930@leverpostej>
References: <1445981041-8774-1-git-send-email-timur@codeaurora.org>
 <CAKv+Gu_ivkemFva-Fu0E24mQqE-m0jPWBzo5OZAr7cyM08hqug@mail.gmail.com>
 <56302E7C.7000605@codeaurora.org>
 <CAKv+Gu9t=dGoaVem+h11cXfimpEzmte36_j4tKW_h8rA8c1jBg@mail.gmail.com>
 <56302F42.4040408@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56302F42.4040408-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 27, 2015 at 09:13:22PM -0500, Timur Tabi wrote:
> Ard Biesheuvel wrote:
> >No. I screwed up the patch since the trailing ) should not be there,
> >but we do need to round first, and only then add the offset.
> 
> But if the offset is not a multiple of 2MB, won't the address passed
> to allocate_pages be unaligned?  I'll test your patch on our system,
> but I thought the problem was that the allocated address must be
> aligned.

The kernel needs to be loaded at an address which is text_offset bytes
past a 2M-aligned base. It is not loaded at the 2M-aligned base itself.

Ard's patch correctly findd a 2M-aligned base, then adds the text
offset.

Mark.
