From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 14/17] XEN: EFI: Move x86 specific codes to architecture
 directory
Date: Tue, 26 Jan 2016 20:26:06 +0800
Message-ID: <56A765DE.7040408@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com> <1453519184-11908-15-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601251643230.9687@kaball.uk.xensource.com> <56A72B4F.2040909@huawei.com> <alpine.DEB.2.02.1601261117200.3619@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1601261117200.3619-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/1/26 19:31, Stefano Stabellini wrote:
> On Tue, 26 Jan 2016, Shannon Zhao wrote:
>> > On 2016/1/26 0:44, Stefano Stabellini wrote:
>>> > > On Sat, 23 Jan 2016, Shannon Zhao wrote:
>>>>> > >> > From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>> > >> >=20
>>>>> > >> > Move x86 specific codes to architecture directory and expo=
rt those EFI
>>>>> > >> > runtime service functions. This will be useful for initial=
izing runtime
>>>>> > >> > service on ARM later.
>>>>> > >> >=20
>>>>> > >> > Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> > > This patch causes a build breakage on x86:
>>> > >=20
>>> > > arch/x86/xen/efi.c: In function =E2=80=98xen_efi_probe=E2=80=99=
:
>>> > > arch/x86/xen/efi.c:101:2: error: implicit declaration of functi=
on =E2=80=98HYPERVISOR_platform_op=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
>>> > >=20
>> > This patch is based on following patch [1]. Maybe you need to upda=
te
>> > your branch. :)
>> >=20
>> > [1] xen: rename dom0_op to platform_op
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Dcfafae940381207d48b11a73a211142dba5947d3
> Sorry, I made a mistake rebasing the series. It doesn't help that I
> couldn't find any Linux RCs on top of which it applies cleanly. As Li=
nus
> tags RCs often enough, it is usually helpful to base one's work on a =
tag
> so that it is easier for other people to work on it.
>
Ah, I'll rebase this series on top of the newest master at next version
since the relevant patches are in master.

> Please add my Reviewed-by to this patch.
Thanks a lot!

--=20
Shannon

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
