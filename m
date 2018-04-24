From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH] efi/libstub/arm64: handle randomized TEXT_OFFSET
Date: Tue, 24 Apr 2018 10:15:00 -0500
Message-ID: <20180424101500.e5c032b91e87a354e92344c5@arm.com>
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
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 24 Apr 2018 12:00:58 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> When CONFIG_RANDOMIZE_TEXT_OFFSET is selected, TEXT_OFFSET is an
> arbitrary multiple of PAGE_SIZE in the interval [0, 2MB).
> 
> The EFI stub doesn't accuont for this, and only handles the case where
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

Tested-by: Kim Phillips <kim.phillips@arm.com>

Thanks,

Kim
