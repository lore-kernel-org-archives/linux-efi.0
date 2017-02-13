From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Mon, 13 Feb 2017 14:55:08 -0600
Message-ID: <CAOZdJXW7gN7_62KA93sz-9TtpDp-p52-j=yFt_X7N7F-N5ZE1A@mail.gmail.com>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org> <20170207190113.GG26173@leverpostej>
 <c49cc64e-4ca1-8d82-5faf-74c0355c35ef@codeaurora.org> <20170207191320.GI26173@leverpostej>
 <252539a6-72f6-1afa-6ed5-3cf6a1aa24c2@codeaurora.org> <20170207195558.GK26173@leverpostej>
 <20170208074301.GB18445@linaro.org> <CAKv+Gu8OXn20JvtFkE_bS=cbWV3XZ5b7a+XaG7tvea+4BqrHfw@mail.gmail.com>
 <20170209082702.GC18445@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170209082702.GC18445-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sameer Goel <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 9, 2017 at 2:27 AM, AKASHI, Takahiro
<takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> is there a requirement that the root node must have #address-cells/
> #size-cells?
> I found such a statement, at least, in booting-without-of.txt
> (only applied to ppc? See III-5-a).

If you want to be able to represent 64-bit 'reg' addresses anywhere in
the device tree, then you will need #address-cells = <2> and
#size-cells = <2> at any appropriate location, which is usually the
root node for a 64-bit processor.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
