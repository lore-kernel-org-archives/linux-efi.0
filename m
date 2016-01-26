From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v3 14/17] XEN: EFI: Move x86 specific codes to architecture
 directory
Date: Tue, 26 Jan 2016 16:16:15 +0800
Message-ID: <56A72B4F.2040909@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com> <1453519184-11908-15-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601251643230.9687@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1601251643230.9687@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org



On 2016/1/26 0:44, Stefano Stabellini wrote:
> On Sat, 23 Jan 2016, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> >=20
>> > Move x86 specific codes to architecture directory and export those=
 EFI
>> > runtime service functions. This will be useful for initializing ru=
ntime
>> > service on ARM later.
>> >=20
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> This patch causes a build breakage on x86:
>=20
> arch/x86/xen/efi.c: In function =E2=80=98xen_efi_probe=E2=80=99:
> arch/x86/xen/efi.c:101:2: error: implicit declaration of function =E2=
=80=98HYPERVISOR_platform_op=E2=80=99 [-Werror=3Dimplicit-function-decl=
aration]
>=20
This patch is based on following patch [1]. Maybe you need to update
your branch. :)

[1] xen: rename dom0_op to platform_op
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
?id=3Dcfafae940381207d48b11a73a211142dba5947d3

--=20
Shannon
