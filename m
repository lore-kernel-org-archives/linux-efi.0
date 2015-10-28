From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] efi: Fix warning of int-to-pointer-cast on x86
 32-bit builds
Date: Wed, 28 Oct 2015 12:28:26 +0100
Message-ID: <20151028112826.GA5066@gmail.com>
References: <20151023085011.GB21631@gmail.com>
 <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
 <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
 <20151023102728.GA1974@gmail.com>
 <20151023103022.GA2297@gmail.com>
 <20151023103328.GA3486@gmail.com>
 <20151027211222.GE8973@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151027211222.GE8973@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> On Fri, 23 Oct, at 12:33:29PM, Ingo Molnar wrote:
> > 
> > Matt, do you want to take these fixes, or should I apply them directly?
> 
> Could you please apply them directly with my Reviewed-by tag?

Sure, done!

Thanks,

	Ingo
