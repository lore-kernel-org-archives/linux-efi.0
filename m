From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v12 3/5] dt, numa: Add NUMA dt binding implementation.
Date: Mon, 29 Feb 2016 14:56:55 -0800
Message-ID: <56D4CCB7.2020505@caviumnetworks.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com> <1456192703-2274-4-git-send-email-ddaney.cavm@gmail.com> <20160229172956.GF31343@rric.localdomain> <56D48A5C.6040709@caviumnetworks.com> <20160229194522.GH31343@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229194522.GH31343-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/29/2016 11:45 AM, Robert Richter wrote:
> On 29.02.16 10:13:48, David Daney wrote:
>> On 02/29/2016 09:29 AM, Robert Richter wrote:
>>> On 22.02.16 17:58:21, David Daney wrote:
>>>> From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>>>
>>>> ADD device tree node parsing for NUMA topology using device
>>>> "numa-node-id" property distance-map.
>>>>
>>>> Reviewed-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>   drivers/of/Kconfig   |   3 +
>>>>   drivers/of/Makefile  |   1 +
>>>>   drivers/of/of_numa.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   include/linux/of.h   |   9 +++
>>>>   4 files changed, 224 insertions(+)
>>>>   create mode 100644 drivers/of/of_numa.c
>>>>
>>>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>>>> index e2a4841..b3bec3a 100644
>>>> --- a/drivers/of/Kconfig
>>>> +++ b/drivers/of/Kconfig
>>>> @@ -112,4 +112,7 @@ config OF_OVERLAY
>>>>   	  While this option is selected automatically when needed, you can
>>>>   	  enable it manually to improve device tree unit test coverage.
>>>>
>>>> +config OF_NUMA
>>>
>>> In arch/arm64/Kconfig you now need to:
>>>
>>> 	select OF_NUMA if NUMA && OF
>>>
>>> This should depend here on OF and NUMA and enabled in that case. Why
>>> moving that to arch code?
>>
>> The dependency on of_numa.o is in the architecture specific code, so that is
>> where the Kconfig select should be too.
>
> If you grep for select in Kconfig files you will see that dependency
> checkers in the form of select ... if ... are very rare.

You are right...

$ find . -name Kconfig | xargs grep -e 'select.*if' | wc -l
1513
$ find . -name Kconfig | xargs grep -e 'select' | wc -l
14179

The 'if' variety is encountered in fewer than 11% of the cases.

That said, I am not sure if this type of statistic should be used to 
evaluate code "goodness".

[...]
>
> But to avoid arch configs in generic Kconfigs, define HAVE_OF_NUMA,
> add it as dependency to OF_NUMA and select it in arch/arm64/Kconfig.
> OF_NUMA is then enabled with defbool y if all requirements are met.
>

Really, what we want is NEEDS_OF_NUMA.  That is exactly what "select 
OF_NUMA" means.

There is no need to build a Rube Goldberg device out of these Kconfig 
things.  The "select OF_NUMA if NUMA && OF" is concise, allowed by the 
Kconfig system and exactly expresses when the file should be compiled.

Unless there are other objections, I am going to use the the Kconfig 
changes in the v12 form.

David.
