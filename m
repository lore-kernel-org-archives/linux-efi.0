From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 4/7] arm64/efi: uefi_init error handling fix
Date: Thu, 14 Aug 2014 09:55:16 -0400
Message-ID: <1408024516.599.134.camel@deneb.redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-4-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1408007731-15081-4-git-send-email-dyoung@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Young <dyoung@redhat.com>
Cc: Russ Anderson <rja@sgi.com>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Daniel Kiper <daniel.kiper@oracle.com>, Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-08-14 at 17:15 +0800, Dave Young wrote:
> There's one early memmap leak in uefi_init error path, fix it and slightly tune
> the error handling code.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Acked-by: Mark Salter <msalter@redhat.com>
