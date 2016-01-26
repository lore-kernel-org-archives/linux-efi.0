From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v3 14/17] XEN: EFI: Move x86 specific codes to architecture
 directory
Date: Tue, 26 Jan 2016 11:31:19 +0000
Message-ID: <alpine.DEB.2.02.1601261117200.3619@kaball.uk.xensource.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
 <1453519184-11908-15-git-send-email-zhaoshenglong@huawei.com>
 <alpine.DEB.2.02.1601251643230.9687@kaball.uk.xensource.com>
 <56A72B4F.2040909@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-1876608270-1453807887=:3619"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A72B4F.2040909@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ian.campbell@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

--1342847746-1876608270-1453807887=:3619
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT

On Tue, 26 Jan 2016, Shannon Zhao wrote:
> On 2016/1/26 0:44, Stefano Stabellini wrote:
> > On Sat, 23 Jan 2016, Shannon Zhao wrote:
> >> > From: Shannon Zhao <shannon.zhao@linaro.org>
> >> > 
> >> > Move x86 specific codes to architecture directory and export those EFI
> >> > runtime service functions. This will be useful for initializing runtime
> >> > service on ARM later.
> >> > 
> >> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > This patch causes a build breakage on x86:
> > 
> > arch/x86/xen/efi.c: In function ‘xen_efi_probe’:
> > arch/x86/xen/efi.c:101:2: error: implicit declaration of function ‘HYPERVISOR_platform_op’ [-Werror=implicit-function-declaration]
> > 
> This patch is based on following patch [1]. Maybe you need to update
> your branch. :)
> 
> [1] xen: rename dom0_op to platform_op
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cfafae940381207d48b11a73a211142dba5947d3

Sorry, I made a mistake rebasing the series. It doesn't help that I
couldn't find any Linux RCs on top of which it applies cleanly. As Linus
tags RCs often enough, it is usually helpful to base one's work on a tag
so that it is easier for other people to work on it.

Please add my Reviewed-by to this patch.
--1342847746-1876608270-1453807887=:3619--
