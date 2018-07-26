From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] rtc: Disable RTC_DRV_EFI on RT
Date: Thu, 26 Jul 2018 18:04:31 +0200
Message-ID: <20180726160430.ser3j5pfxnjh2bla@linutronix.de>
References: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de>
 <CAKv+Gu_+t_VwY3xDq3nWbnOTfzBc6OtQeRD2GKsseO2uK-uruw@mail.gmail.com>
 <20180726121504.ba35z3j3wsesryy3@linutronix.de>
 <5052E25B-9942-40C1-BD53-86E3D7014557@linaro.org>
 <20180726124613.xgmidioqd4mcqpiw@linutronix.de>
 <8640BE46-B141-44F9-BD92-58A21A2B0EA7@linaro.org>
 <20180726131323.ffecgeqnry6th4mp@linutronix.de>
 <20180726131424.nqkalmmncnfcrh2q@linutronix.de>
 <CAKv+Gu8FgcPZDDKWnC03eWVFH2npJz5_XQDoOzkGdDxxSqCj8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8FgcPZDDKWnC03eWVFH2npJz5_XQDoOzkGdDxxSqCj8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On 2018-07-26 18:01:47 [+0200], Ard Biesheuvel wrote:
> Yes, that's what I was thinking. This way, you can still reboot into
> the same kernel occasionally with EFI runtime services enabled to,
> e.g., use efibootmgr.
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> for both patches if you queue them in the -rt tree. If you want them
> in mainline, please resend them as proper patches once
> CONFIG_PREEMPT_RT_BASE has been declared in mainline as well.
Okay, thank you.

Sebastian
