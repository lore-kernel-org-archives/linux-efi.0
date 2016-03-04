From: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13 3/6] of, numa: Add NUMA of binding implementation.
Date: Thu, 3 Mar 2016 18:21:01 -0600
Message-ID: <CAL_JsqL4FEkP-GhHf0Hyh9spKf=oV+Ft+GFfVFoZmYMyvCoDkw@mail.gmail.com>
References: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com>
 <1456959362-2036-4-git-send-email-ddaney.cavm@gmail.com> <CAL_JsqLRP6tmpY7cJ61Ybrrai4ctA7ezyUGmYwdbywe+-qBG5A@mail.gmail.com>
 <56D87572.3090002@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D87572.3090002-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 3, 2016 at 11:33 AM, David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> On 03/02/2016 07:34 PM, Rob Herring wrote:
>>
>> On Wed, Mar 2, 2016 at 4:55 PM, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>
>>> Add device tree parsing for NUMA topology using device
>>> "numa-node-id" property in distance-map and cpu nodes.
>>>
>>> This is a complete rewrite of a previous patch by:
>>>     Ganapatrao Kulkarni<gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>>
>>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   drivers/of/Kconfig   |   3 +
>>>   drivers/of/Makefile  |   1 +
>>>   drivers/of/of_numa.c | 200
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/of.h   |   9 +++
>>>   4 files changed, 213 insertions(+)
>>>   create mode 100644 drivers/of/of_numa.c

[...]

>>> +static int __init of_parse_distance_map(void)
>>> +{
>>> +       int ret = -EINVAL;
>>> +       struct device_node *np = of_find_node_by_name(NULL,
>>> "distance-map");
>>> +
>>> +       if (!np)
>>> +               return ret;
>>> +
>>> +       if (of_device_is_compatible(np, "numa-distance-map-v1")) {
>>
>>
>> You can use of_find_compatible_node() instead of these 2 calls.
>
>
> Well, we need to match exactly the name "distance-map",
> of_find_compatible_node() doesn't match on the name, so I think we need two
> checks, one for name and one for compatible.

Node names generally aren't supposed to matter and the kernel's job is
not to validate DTs, So just finding the compatible should be enough.

Not a big deal, so I've acked v14. If there's a v15, then please make
the change.

Rob
