From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Mon, 13 Feb 2017 14:51:49 -0600
Message-ID: <CAOZdJXUKkkgvv=uqjoxrFzpRWgZFHAc=y26gtVRJyor-faV4Gw@mail.gmail.com>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org> <20170207190113.GG26173@leverpostej>
 <c49cc64e-4ca1-8d82-5faf-74c0355c35ef@codeaurora.org> <20170207191320.GI26173@leverpostej>
 <252539a6-72f6-1afa-6ed5-3cf6a1aa24c2@codeaurora.org> <20170207195558.GK26173@leverpostej>
 <20170208074301.GB18445@linaro.org> <CAKv+Gu8OXn20JvtFkE_bS=cbWV3XZ5b7a+XaG7tvea+4BqrHfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8OXn20JvtFkE_bS=cbWV3XZ5b7a+XaG7tvea+4BqrHfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sameer Goel <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 8, 2017 at 4:40 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> The point is that the tooling should take *existing* cell counts into
> account: if there are no address-cells/size-cells properties under
> /chosen or under the root node, the tooling should use 32-bit
> quantities for address and size. If there are such properties, it
> should emit reg tuples of the same size as the cells properties
> describe.

I agree with this 100%, but that means that we need to be able to
inject address-cells/size-cells properties at some point, otherwise
we'll never be able to store 64-bit addresses.  And that's what
Sameer's patch does.  It injects those properties at the appropriate
time.  Any code that parses 'reg' properties without taking the
address-cells/size-cells properties into account is technically
incorrect and should be fixed..

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
