From: Andrew Turner <andrew@fubar.geek.nz>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 12:32:51 +0100
Message-ID: <20150910123251.7e0810d1@bender.Home>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ian.campbell@citrix.com, ard.biesheuvel@linaro.org, stefano.stabellini@eu.citrix.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, xen-devel@lists.xen.org, julien.grall@citrix.com, freebsd-arm@freebsd.org, matt.fleming@intel.com, christoffer.dall@linaro.org, jbeulich@suse.com, peter.huangpeng@huawei.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Sep 2015 16:41:56 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> These EFI stub parameters are used to internal communication between
> EFI stub and Linux kernel and EFI stub creates these parameters. But
> for Xen on ARM when booting with UEFI, Xen will create a minimal DT
> providing these parameters for Dom0 and Dom0 is not only Linux
> kernel, but also other OS (such as FreeBSD) which will be used in the
> future. So here we plan to standardize the names by dropping the
> prefix "linux," and make them common to other OS. Also this will not
> break the compatibility since these parameters are used to internal
> communication between EFI stub and kernel.

It is unlikely FreeBSD will use this property when booting ad Xen dom0.
The kernel expects to be passed a data structure to find boot this
information.

My preference would be to have the FreeBSD loader load the xen binary,
the FreeBSD kernel, and set up these data structs before passing
control to Xen, with the information it needs to boot the kernel. My
understanding is this is how it is done on x86.

I can see a few issues with this where, for example, the device tree or
ACPI tables need to be modified, but these should be solvable.

Andrew
