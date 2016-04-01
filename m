From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 12/17] ARM64: ACPI: Check if it runs on Xen to enable
 or disable ACPI
Date: Fri, 1 Apr 2016 17:32:39 +0800
Message-ID: <56FE4037.5060305@huawei.com>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org> <1458830676-27075-13-git-send-email-shannon.zhao@linaro.org> <20160329161837.GH6745@arm.com> <20160329163147.GB27223@leverpostej> <56FB7E00.7030400@huawei.com> <alpine.DEB.2.02.1603311155450.11739@kaball.uk.xensource.com> <CAKv+Gu-wPq_FzO3sm7bhSFuu7EVxHWB_v6HOn1GqNbdaE-iBoQ@mail.gmail.com> <20160331124216.GE26532@leverpostej> <56FE3E85.60403@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56FE3E85.60403-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, julien.grall-5wv7dgnIgG8@public.gmane.org, Stefano Stabellini <stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 2016/4/1 17:25, Shannon Zhao wrote:
> If it really needs is_xen_node(), I will not factor
> fdt_find_hyper_node() in patch 11 since it uses flat DT while here it's
> going to use unflatten DT.
Sorry, I'm wrong. They both use flat DT. But it's no need to factor
fdt_find_hyper_node() since is_xen_node is very simple like below I think.

of_flat_dt_is_compatible(node, "xen,xen");

And maybe it cloud directly use above check in dt_scan_depth1_nodes.

Thanks,
-- 
Shannon

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
