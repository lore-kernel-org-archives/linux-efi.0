From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] efi/libstub/arm: add opt-in Kconfig option for the DTB
 loader
Date: Mon, 25 Jun 2018 13:12:29 +0200
Message-ID: <4825d1cd-c490-0442-5d43-9991250d5c1f@suse.de>
References: <20180625063405.24387-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180625063405.24387-1-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
Cc: leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 06/25/2018 08:34 AM, Ard Biesheuvel wrote:
> There are various ways a platform can provide a device tree binary
> to the kernel, with different levels of sophistication:
> - ideally, the UEFI firmware, which is tightly coupled with the
>    platform, provides a device tree image directly as a UEFI
>    configuration table, and typically permits the contents to be
>    manipulated either via menu options or via UEFI environment
>    variables that specify a replacement image,
> - GRUB for ARM has a 'devicetree' directive which allows a device
>    tree image to be loaded from any location accessible to GRUB, and
>    supersede the one provided by the firmware,
> - the EFI stub implements a dtb= command line option that allows a
>    device tree image to be loaded from a file residing in the same
>    file system as the one the kernel image was loaded from.
>
> The dtb= command line option was never intended to be more than a
> development feature, to allow the other options to be implemented
> in parallel. So let's make it an opt-in feature that is disabled
> by default, but can be re-enabled at will.
>
> Note that we already disable the dtb= command line option when we
> detect that we are running with UEFI Secure Boot enabled.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Sounds reasonable to me.

Reviewed-by: Alexander Graf <agraf@suse.de>


Alex
