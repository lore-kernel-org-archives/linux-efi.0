From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] rtc: Disable RTC_DRV_EFI on RT
Date: Thu, 26 Jul 2018 14:46:13 +0200
Message-ID: <20180726124613.xgmidioqd4mcqpiw@linutronix.de>
References: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de>
 <CAKv+Gu_+t_VwY3xDq3nWbnOTfzBc6OtQeRD2GKsseO2uK-uruw@mail.gmail.com>
 <20180726121504.ba35z3j3wsesryy3@linutronix.de>
 <5052E25B-9942-40C1-BD53-86E3D7014557@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5052E25B-9942-40C1-BD53-86E3D7014557@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-efi@vger.kernel.org

On 2018-07-26 14:26:25 [+0200], Ard Biesheuvel wrote:
> What i mean is whatever you end up with if you pass efi=noruntime to the kernel.
ah. So I wouldn't have to patch this, just document it. That might work.

> But as i mentioned before, you may also lose the ability to reboot/shut down your system this way. Can you please double check?

I checked before posting the patch. psci is used instead (on softiron
here, have nothing else). psci_sys_poweroff() works.

Sebastian
