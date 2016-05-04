From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] x86/sysfb_efi: Fix valid BAR address range check
Date: Wed, 4 May 2016 08:35:24 +0200
Message-ID: <20160504063524.GB12846@gmail.com>
References: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
 <1462303781-8686-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462303781-8686-3-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Wang YanQing <udknight@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Peter Jones <pjones@redhat.com>, stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> From: Wang YanQing <udknight@gmail.com>
> 
> We can't just break out when meet start is equal to zero,

Hm, wot?

Thanks,

	Ingo
