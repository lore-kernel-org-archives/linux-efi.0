From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 00/11] EFI updates for v4.20
Date: Tue, 2 Oct 2018 10:34:56 +0200
Message-ID: <20181002083456.GB120270@gmail.com>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
 <7c25a402-0fc8-fe70-ac95-348a93f4fe69@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c25a402-0fc8-fe70-ac95-348a93f4fe69@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org


* Marc Zyngier <marc.zyngier@arm.com> wrote:

> Hi all,
> 
> On 27/09/18 09:50, Ard Biesheuvel wrote:
> > Thomas, Ingo,
> > 
> > Please pull/cherry-pick the below. Note that the first three patches will
> > be depended upon by an irqchip series that Marc Zyngier has sent out last
> > week, and that targets the next release as well. So please advise how to
> > proceed with that: we could simply apply those patches first and use the
> > resulting commit in tip.git as a stable branch, I suppose, but I'll let
> > Marc chime in in case he has any other ideas.
> 
> A stable branch with these three patches would be great. The irqchip code
> will also end-up in tip, so it should all be quite easy to manage anyway.

Yeah - nevertheless, to keep it all separated nicely, I've created a new
topic tree for this: tip:efi/irqchip (2e3ac98133a3), with just these three
patches on top of latest -git.

That way it can then all be iterated separately.

Does this approach work for you?

Thanks,

	Ingo
