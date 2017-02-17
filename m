From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: libstub: treat missing SecureBoot variable as S/B disabled
Date: Fri, 17 Feb 2017 07:08:19 +0000
Message-ID: <CAKv+Gu_=BwvYJoyuf89PUVjnrJeJyvr-p6yFAu4Mw+ErLc4nxQ@mail.gmail.com>
References: <1487268503-21570-1-git-send-email-ard.biesheuvel@linaro.org> <20170217051355.GA1141@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217051355.GA1141-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 February 2017 at 05:13, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Thu, Feb 16, 2017 at 06:08:23PM +0000, Ard Biesheuvel wrote:
>> The newly refactored code that infers the firmware's Secure Boot state
>> prints the following error when the variables 'SecureBoot' is missing.
>>
>>   EFI stub: ERROR: Could not determine UEFI Secure Boot status.
>>
>> However, this variable is only guaranteed to be defined on a system that
>> is Secure Boot capable to begin with, and so it is not an error if it is
>> missing. So report Secure Boot as being disabled in this case, without
>> printing any error messages.
>
> In fact I pointed out this change of behaviour on ARM during the
> review process:
>
> https://lkml.org/lkml/2016/12/8/702
>
> But David thought otherwise. :-(
>

I do remember that discussion. But I think David catered for that by
returning enabled/disabled/unknown, deferring the decision how to deal
with 'unknown' to the caller.

But I did not appreciate at the time that this was a change in
behavior nonetheless, and printing errors that are not errors only
confuses people.
