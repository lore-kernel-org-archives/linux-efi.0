From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH RT] rtc: Disable RTC_DRV_EFI on RT
Date: Thu, 26 Jul 2018 11:15:52 +0200
Message-ID: <CAKv+Gu_+t_VwY3xDq3nWbnOTfzBc6OtQeRD2GKsseO2uK-uruw@mail.gmail.com>
References: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On 26 July 2018 at 11:04, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Based on measurements the EFI functions get_variable /
> get_next_variable take up to 2us. The functions get_time, set_time take
> around 10ms. Those 10ms are too much. Even one ms would be too much.

You cannot extrapolate from these numbers. If the lack of worst case
guarantees on an EFI system is a problem for -rt, the only meaningful
course of action is to disable EFI runtime services entirely.

I think SetVariable() may be even worse than GetTime(), given that NOR
flash updates may involve erasing blocks.

> The funny part is that EFI is invoked with enabled interrupts.
> According to my tracing I see the interrupt almost 10ms later which
> indicates that EFI is disabling interrupts while doing its thing.
>

Yes, and this is also highly implementation specific. Basing this kind
of policy on a single implementation is not very wise imo.

> This was observed on "EFI v2.60 by SoftIron Overdrive 1000". I don't say
> that every EFI implementation does this but given that it has to access a
> slow bus like I2C/SPI it is expected.
>
> Disable EFI's RTC driver on RT.
>

Other calls to GetTime() would still be permitted in this case, so
this seems like a partial solution (although no other calls seem to
exist atm)

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/rtc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a2ba5db36145..248d72711650 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1087,7 +1087,7 @@ config RTC_DRV_DA9063
>
>  config RTC_DRV_EFI
>         tristate "EFI RTC"
> -       depends on EFI && !X86
> +       depends on EFI && !X86 && !PREEMPT_RT_BASE
>         help
>           If you say yes here you will get support for the EFI
>           Real Time Clock.
> --
> 2.18.0
>
