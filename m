From: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] firmware: efi: remove unneeded guid unparse
Date: Thu, 29 Jan 2015 16:57:29 +0200
Message-ID: <54CA4A59.7000905@linaro.org>
References: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org> <1422542869.21110.8.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422542869.21110.8.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Oh, sorry.
Just didn't note that it's picked up from linaro list.


On 01/29/2015 04:47 PM, Matt Fleming wrote:
> On Thu, 2015-01-29 at 16:35 +0200, Ivan Khoronzhuk wrote:
>> There is no reason to translate guid number to string here.
>> So remove it in order to not do unneeded work.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>   drivers/firmware/efi/efi.c | 5 -----
>>   1 file changed, 5 deletions(-)
> Why the resend? I already picked this commit up,
>
>    https://lkml.kernel.org/r/20150120223238.GC12079-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
>
