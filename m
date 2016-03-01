From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 08/10] dt, numa: Add NUMA dt binding implementation.
Date: Tue, 1 Mar 2016 10:47:19 -0600
Message-ID: <CAL_JsqLoTh_ZTUT26g4wz=6sofuRpFDCc_Aw+Oq66p8cGMp19g@mail.gmail.com>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
 <1455930799-5371-9-git-send-email-ddaney.cavm@gmail.com> <20160223193651.GA8491@rob-hp-laptop>
 <56CFA9CA.6090803@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CFA9CA.6090803-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 25, 2016 at 7:26 PM, David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> On 02/23/2016 11:36 AM, Rob Herring wrote:
>>
>> On Fri, Feb 19, 2016 at 05:13:17PM -0800, David Daney wrote:
>>>
>>> From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
>>>
>>> ADD device tree node parsing for NUMA topology using device
>>> "numa-node-id" property distance-map.
>>
>>
>> I still want an adequate explanation why NUMA setup cannot be done with
>> an unflattened tree. PowerPC manages to do that and should have a
>> similar init flow being memblock based, so I would expect arm64 can too.
>
>
> Many things could be done.  Really, we want to know what *should* be done.
>
> In the context of the current arm64 memory initialization we (more or less)
> do:
>
>  1) early_init_fdt_scan_reserved_mem();
>  2) memory_present()
>  3) sparse_init()
>  4) other things
>  5) unflatten_device_tree()
>
> We are already reading information out of the FDT at #1.
>
> This patch set adds a step between 1 and 2 where we read NUMA information
> out of the FDT.

The dependency on unflattening is that memblock is up and we can
allocate a chunk from it. Isn't that dependency met by step 1 or is
there a dependency on sparsemem (or something else)?

Rob
