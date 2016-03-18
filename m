From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 16/17] FDT: Add a helper to get the subnode by given name
Date: Fri, 18 Mar 2016 08:53:44 -0500
Message-ID: <CAL_JsqJbvZc2D6zUxOK3z=0CHrPkM4pCna_Q0Ri3k7C9WFm0EA@mail.gmail.com>
References: <1457073455-11516-1-git-send-email-zhaoshenglong@huawei.com> <1457073455-11516-17-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457073455-11516-17-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 4, 2016 at 12:37 AM, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Sometimes it needs to check if there is a subnode of given node in FDT
> by given name. Introduce this helper to get the subnode if it exists.
>
> CC: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
