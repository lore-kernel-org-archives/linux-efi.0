From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH RT] rtc: Disable RTC_DRV_EFI on RT
Date: Thu, 26 Jul 2018 14:52:21 +0200
Message-ID: <8640BE46-B141-44F9-BD92-58A21A2B0EA7@linaro.org>
References: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de> <CAKv+Gu_+t_VwY3xDq3nWbnOTfzBc6OtQeRD2GKsseO2uK-uruw@mail.gmail.com> <20180726121504.ba35z3j3wsesryy3@linutronix.de> <5052E25B-9942-40C1-BD53-86E3D7014557@linaro.org> <20180726124613.xgmidioqd4mcqpiw@linutronix.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180726124613.xgmidioqd4mcqpiw@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-efi@vger.kernel.org



> On 26 Jul 2018, at 14:46, Sebastian Andrzej Siewior <bigeasy@linutronix.de=
> wrote:
>=20
>> On 2018-07-26 14:26:25 [+0200], Ard Biesheuvel wrote:
>> What i mean is whatever you end up with if you pass efi=3Dnoruntime to th=
e kernel.
> ah. So I wouldn't have to patch this, just document it. That might work.
>=20

We could also make it the default on -rt, but not disable it entirely, so th=
at efi=3Druntime can be used to re-enable it.


>> But as i mentioned before, you may also lose the ability to reboot/shut d=
own your system this way. Can you please double check?
>=20
> I checked before posting the patch. psci is used instead (on softiron
> here, have nothing else). psci_sys_poweroff() works.
>=20
> Sebastian
