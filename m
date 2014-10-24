From: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] arm64/efi: remove idmap manipulations from UEFI code
Date: Fri, 24 Oct 2014 14:55:23 +0100
Message-ID: <CACxGe6uAm0JN9qJscp2yuLACMYAAMJPK2er=4g48E6xzrGRhcQ@mail.gmail.com>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
 <1414154384-15385-7-git-send-email-ard.biesheuvel@linaro.org>
 <CACxGe6uc9VZs4fMS+U9W=wG3bJr2pm=tREQsqvF91LgKdsXjqw@mail.gmail.com> <CAKv+Gu8x3GGo=GeMWK4P8grTmZPq6dh3K-WZDmaWq=G-cKJhNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8x3GGo=GeMWK4P8grTmZPq6dh3K-WZDmaWq=G-cKJhNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Fleming, Matt (matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 24, 2014 at 2:53 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 24 October 2014 15:41, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On Fri, Oct 24, 2014 at 1:39 PM, Ard Biesheuvel
>> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> Now that we have moved the call to SetVirtualAddressMap() to the stub,
>>> UEFI has no use for the ID map, so we can drop the code that installs
>>> ID mappings for UEFI memory regions.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> I have to say, this series makes me happy. :-)
>>
>> This method will go a long way to catching UEFI implementations that
>> do incorrect things after exitbootservices is called. I'm assuming
>> that any attempt to access a region that boot services has not
>> requested will get trapped by the kernel, correct?
>>
>
> If we really want to catch firmware problems, we should probably wipe
> all boot services regions between the calls to ExitBootServices() and
> SetVirtualAddressMap(). Mark Salter's original approach here was
> fairly cautious here, i.e., reserving boot services regions until
> after the call to SetVirtualAddressMap(), but there is no point in
> doing that for kexec, that's why I removed it.

I quite like that idea. Let's do that and see if anyone screams in agony.

g.
