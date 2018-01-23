From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm*: Only register page tables when they exist
Date: Tue, 23 Jan 2018 18:50:33 +0000
Message-ID: <CAKv+Gu8kKW41ZEmyTi-OiwAuxPvObOj+b-QtNvXAN7Oc4kRHyg@mail.gmail.com>
References: <20180116140832.26731-1-mark.rutland@arm.com> <20180117101922.GB27892@arm.com>
 <CAKv+Gu_xB2XywijC0VMY48uR212pOnm7dFzOAp2ozevHC7fRSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_xB2XywijC0VMY48uR212pOnm7dFzOAp2ozevHC7fRSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 January 2018 at 12:01, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 17 January 2018 at 10:19, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
>> On Tue, Jan 16, 2018 at 02:08:32PM +0000, Mark Rutland wrote:
>>> Currently the arm/arm64 runtime code registers the runtime servies
>>> pagetables with ptdump regardless of whether runtime services page
>>> tables have been created.
>>>
>>> As efi_mm.pgd is NULL in these cases, attempting to dump the efi page
>>> tables results in a NULL pointer dereference in the ptdump code:
>>
>> Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>>
>> Ard -- please can you pick this one up?
>>
>
> I'll see if I can manage applying it.
>

Applied for -next, thanks.
