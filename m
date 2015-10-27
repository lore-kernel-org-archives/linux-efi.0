From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/2] efi: Fix warning of int-to-pointer-cast on x86
 32-bit builds
Date: Tue, 27 Oct 2015 21:12:22 +0000
Message-ID: <20151027211222.GE8973@codeblueprint.co.uk>
References: <20151023085011.GB21631@gmail.com>
 <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
 <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
 <20151023102728.GA1974@gmail.com>
 <20151023103022.GA2297@gmail.com>
 <20151023103328.GA3486@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151023103328.GA3486@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Oct, at 12:33:29PM, Ingo Molnar wrote:
> 
> Matt, do you want to take these fixes, or should I apply them directly?

Could you please apply them directly with my Reviewed-by tag?
