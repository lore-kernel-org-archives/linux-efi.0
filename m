From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2] efi: arm64: add debugfs node to dump UEFI runtime
 page tables
Date: Fri, 19 Aug 2016 12:57:57 +0100
Message-ID: <20160819115757.GT30909@codeblueprint.co.uk>
References: <1471349601-31257-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1471349601-31257-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Tue, 16 Aug, at 02:13:21PM, Ard Biesheuvel wrote:
> Register the debugfs node 'efi_page_tables' to allow the UEFI runtime
> page tables to be inspected. Note that ARM does not have 'asm/ptdump.h'
> [yet] so for now, this is arm64 only.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> v2: test for CONFIG_ARM64_PTDUMP rather than CONFIG_ARM64
>     add Mark's ack
> 
>  drivers/firmware/efi/arm-runtime.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Thanks Ard. Queued up in 'next'.
