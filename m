From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 16/17] FDT: Add a helper to get specified name subnode
Date: Wed, 24 Feb 2016 08:53:46 -0600
Message-ID: <CAL_JsqJJx_agcQRa=vU25Db33t8LtaoBw+dZB5jS2N7LA2KX2g@mail.gmail.com>
References: <1454641552-12576-1-git-send-email-zhaoshenglong@huawei.com>
 <1454641552-12576-17-git-send-email-zhaoshenglong@huawei.com>
 <CAL_JsqK8F6PQX2kC_+CtDk1-ykKRB3YB54o4FaypsRY_tNzK5w@mail.gmail.com> <56CC3ED9.5000101@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CC3ED9.5000101-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 23, 2016 at 5:13 AM, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org=
> wrote:
>
>
> On 2016/2/9 13:04, Rob Herring wrote:
>> On Thu, Feb 4, 2016 at 9:05 PM, Shannon Zhao <zhaoshenglong@huawei.c=
om> wrote:
>>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>> Sometimes it needs to check if there is a node in FDT by full path.
>>
>> I'm confused. Are you searching by full path or...
>>
>>> Introduce this helper to get the specified name subnode if it exist=
s.
>>
>> name of sub node?
>>
> get the offset of sub node by specified name.
>
>> Either way, fdt_subnode_offset or fdt_path_offset doesn't work?
>>
> Ah=EF=BC=8Cright=EF=BC=8Cboth of them should work. Does it need to ad=
d a wrapper in
> drivers/of/fdt.c for them or directly use them with the parameter
> initial_boot_params?

Add a wrapper in fdt.c.

Rob
