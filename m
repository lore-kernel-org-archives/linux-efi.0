From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [GIT PULL 00/11] EFI updates for v4.20
Date: Thu, 27 Sep 2018 10:07:23 +0100
Message-ID: <7c25a402-0fc8-fe70-ac95-348a93f4fe69@arm.com>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

Hi all,

On 27/09/18 09:50, Ard Biesheuvel wrote:
> Thomas, Ingo,
> 
> Please pull/cherry-pick the below. Note that the first three patches will
> be depended upon by an irqchip series that Marc Zyngier has sent out last
> week, and that targets the next release as well. So please advise how to
> proceed with that: we could simply apply those patches first and use the
> resulting commit in tip.git as a stable branch, I suppose, but I'll let
> Marc chime in in case he has any other ideas.

A stable branch with these three patches would be great. The irqchip 
code will also end-up in tip, so it should all be quite easy to manage 
anyway.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
