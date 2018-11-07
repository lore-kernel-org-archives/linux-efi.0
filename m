From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 1/7] x86/boot: Introduce cmdline_find_option_arg()to
 detect if option=arg in cmdline
Date: Wed, 7 Nov 2018 09:24:01 +0800
Message-ID: <20181107012400.GB2683@localhost.localdomain>
References: <20181022093720.21426-1-fanc.fnst@cn.fujitsu.com>
 <20181022093720.21426-2-fanc.fnst@cn.fujitsu.com>
 <20181106122253.GG13712@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181106122253.GG13712@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2018 at 01:22:53PM +0100, Borislav Petkov wrote:
>On Mon, Oct 22, 2018 at 05:37:14PM +0800, Chao Fan wrote:
>> Now, there are cmdline_find_option() and cmdline_find_option_bool() in
>> cmdline.c. Sometimes, when detecting such as whether 'acpi=off' is
>> in cmdline, we need to cmdline_find_option() first, then compare
>> the argument. Now splite the operation as a independent function.
>> Introduce a new function cmdline_find_option_arg() to detect whether
>> option is in command line and the value is arg.
>
>For all future commit messages you write:
>
>Use passive tone in your commit message: no "we", etc.

Got it.

>
>Also, pls read section "2) Describe your changes" in
>Documentation/process/submitting-patches.rst.
OK.
>
>> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
>> ---
>>  arch/x86/boot/compressed/cmdline.c | 15 +++++++++++++++
>>  arch/x86/boot/compressed/misc.h    |  1 +
>>  2 files changed, 16 insertions(+)
>> 
>> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
>> index af6cda0b7900..61118c69feb8 100644
>> --- a/arch/x86/boot/compressed/cmdline.c
>> +++ b/arch/x86/boot/compressed/cmdline.c
>> @@ -1,5 +1,7 @@
>>  // SPDX-License-Identifier: GPL-2.0
>>  #include "misc.h"
>> +#define STATIC
>> +#include <linux/decompress/mm.h>
>>  
>>  #if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE || CONFIG_X86_5LEVEL
>>  
>> @@ -30,5 +32,18 @@ int cmdline_find_option_bool(const char *option)
>>  {
>>  	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
>>  }
>> +bool cmdline_find_option_arg(const char *option, const char *arg, int argsize)
>> +{
>> +	char *buffer = malloc(argsize+1);
>> +	bool find = false;
>> +	int ret;
>> +
>> +	ret = cmdline_find_option(option, buffer, argsize+1);
>> +	if (ret == argsize && !strncmp(buffer, arg, argsize))
>> +		find = true;
>> +
>> +	free(buffer);
>> +	return find;
>> +}
>
>I don't think such wrapper is needed. Simply calling
>cmdline_find_option() and then examining the buffer - like other call
>sites do - is perfectly fine.

I will change it.

Thanks,
Chao Fan
>
>Thx.
>
>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
