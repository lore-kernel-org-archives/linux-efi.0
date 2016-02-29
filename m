From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v12 3/5] dt, numa: Add NUMA dt binding implementation.
Date: Mon, 29 Feb 2016 10:13:48 -0800
Message-ID: <56D48A5C.6040709@caviumnetworks.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com> <1456192703-2274-4-git-send-email-ddaney.cavm@gmail.com> <20160229172956.GF31343@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229172956.GF31343-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/29/2016 09:29 AM, Robert Richter wrote:
> On 22.02.16 17:58:21, David Daney wrote:
>> From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>
>> ADD device tree node parsing for NUMA topology using device
>> "numa-node-id" property distance-map.
>>
>> Reviewed-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/of/Kconfig   |   3 +
>>   drivers/of/Makefile  |   1 +
>>   drivers/of/of_numa.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/of.h   |   9 +++
>>   4 files changed, 224 insertions(+)
>>   create mode 100644 drivers/of/of_numa.c
>>
>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>> index e2a4841..b3bec3a 100644
>> --- a/drivers/of/Kconfig
>> +++ b/drivers/of/Kconfig
>> @@ -112,4 +112,7 @@ config OF_OVERLAY
>>   	  While this option is selected automatically when needed, you can
>>   	  enable it manually to improve device tree unit test coverage.
>>
>> +config OF_NUMA
>
> In arch/arm64/Kconfig you now need to:
>
> 	select OF_NUMA if NUMA && OF
>
> This should depend here on OF and NUMA and enabled in that case. Why
> moving that to arch code?

The dependency on of_numa.o is in the architecture specific code, so 
that is where the Kconfig select should be too.

For new code, we try to avoid putting architecture specific things into 
the core Kconfig files.

Since arm64 is the only architecture that is currently using this, we 
don't want to select it for non-arm64 kernels that happen to select NUMA 
&& OF.

I will restore the depends, as it is guard against errors in the 
architecture specific Kconfig select statements, but I am going to leave 
the NUMA && OF in the arm64/Kconfig for clarity.

> This duplicates code as the same needs to be
> implemented for every arch.
>

Better to duplicate a single Kconfig select statement a few times in 
architecture specific Kconfig files, than force people to continuously 
modify the depends in  drivers/of/Kconfig

David.
