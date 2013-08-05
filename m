From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] EFI stub documentation updates
Date: Mon, 5 Aug 2013 16:56:12 -0700
Message-ID: <CAFECyb9h7aSzOAHC0t-xT1mNxW_CuMqpU8zGD50ZzZYQ74d0fg@mail.gmail.com>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
	<1375478948-22562-2-git-send-email-roy.franz@linaro.org>
	<20130805141221.GC2755@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805141221.GC2755-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 5, 2013 at 7:12 AM, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Aug 02, 2013 at 02:29:02PM -0700, Roy Franz wrote:
>> The ARM kernel also has an EFI stub which works largely the same way
>> as the x86 stub, so move the documentation out of x86 directory and
>> update to reflect that it is generic, and add ARM specific text.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  Documentation/efi-stub.txt     |   78 ++++++++++++++++++++++++++++++++++++++++
>>  Documentation/x86/efi-stub.txt |   65 ---------------------------------
>>  arch/x86/Kconfig               |    2 +-
>>  3 files changed, 79 insertions(+), 66 deletions(-)
>>  create mode 100644 Documentation/efi-stub.txt
>>  delete mode 100644 Documentation/x86/efi-stub.txt
>>
>> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
>> new file mode 100644
>> index 0000000..7837df1
>> --- /dev/null
>> +++ b/Documentation/efi-stub.txt
>> @@ -0,0 +1,78 @@
>> +                       The EFI Boot Stub
>> +                  ---------------------------
>> +
>> +On the x86 and ARM platforms, a bzImage can masquerade as a PE/COFF image,
>> +thereby convincing EFI firmware loaders to load it as an EFI
>> +executable. The code that modifies the bzImage header, along with the
>
>
> Minor nit, I don't think there is such a thing as "bzImage" for ARM.
>
> Cheers
> ---Dave
>
Yeah, I don't thinks so either...  How about:

On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade....


Roy
