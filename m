From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub/arm64: handle randomized TEXT_OFFSET
Date: Tue, 24 Apr 2018 13:11:40 +0200
Message-ID: <CAKv+Gu813jnf1RPU0HKMXapeK04XhJMveeLb9uppx7recyUW5w@mail.gmail.com>
References: <20180424110058.29344-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180424110058.29344-1-mark.rutland@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-efi@vger.kernel.org, Kim Phillips <kim.phillips@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Hi Mark,

On 24 April 2018 at 13:00, Mark Rutland <mark.rutland@arm.com> wrote:
> When CONFIG_RANDOMIZE_TEXT_OFFSET is selected, TEXT_OFFSET is an
> arbitrary multiple of PAGE_SIZE in the interval [0, 2MB).
>
> The EFI stub doesn't accuont for this, and only handles the case where

'account'

If you agree, I will add something here to clarify that the newly
chosen offset should retain the misalignment of TEXT_OFFSET relative
to EFI_KIMG_ALIGN, because it took me a while to figure that out.

Other than that,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I will queue this as a fix

Thanks,
Ard.



> TEXT_OFFSET is multiple of EFI_KIMG_ALIGN. This can result in the kernel
> being loaded to an erroneous physical alignment. This has been observed
> to result in spurious stack overflow reports and failure to make use of
> the IRQ stacks, and theoretically could result in a number of other
> issues.
>
> We can OR in the low bits of TEXT_OFFSET to ensure that we have the
> necessary offset (and hence have the necessary alignment), so let's do
> that.
>
> Fixes: 6f26b3671184c36d ("arm64: kaslr: increase randomization granularity")
> Reported-by: Kim Phillips <kim.phillips@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: linux-efi@vger.kernel.org
> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index b9bd827caa22..541b82fdc8a2 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -98,6 +98,13 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
>                              (phys_seed >> 32) & mask : TEXT_OFFSET;
>
>                 /*
> +                * With CONFIG_RANDOMIZE_TEXT_OFFSET, TEXT_OFFSET may not be a
> +                * multiple of EFI_KIMG_ALIGN, and we must ensure that we apply
> +                * the offset below EFI_KIMG_ALIGN.
> +                */
> +               offset |= (TEXT_OFFSET % EFI_KIMG_ALIGN);
> +
> +               /*
>                  * If KASLR is enabled, and we have some randomness available,
>                  * locate the kernel at a randomized offset in physical memory.
>                  */
> --
> 2.11.0
>
