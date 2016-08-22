From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 6/6] efi/fdt: Fix handling error value in
 fdt_find_uefi_params
Date: Mon, 22 Aug 2016 18:45:08 +0200
Message-ID: <20160822164508.GD11327@gmail.com>
References: <1471638904-3494-1-git-send-email-matt@codeblueprint.co.uk>
 <1471638904-3494-7-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471638904-3494-7-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Andrzej Hajda <a.hajda@samsung.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> From: Andrzej Hajda <a.hajda@samsung.com>
> 
> of_get_flat_dt_subnode_by_name can return negative value in case of error.

... which is a problem because <X>, and we solve it by doing <Y>?

Thanks,

	Ingo
