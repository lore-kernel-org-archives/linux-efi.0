From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] efi: stub: define DISABLE_BRANCH_PROFILING for all architectures
Date: Thu, 07 Jan 2016 15:59:26 +0100
Message-ID: <14896110.p9g5zCmDvk@wuerfel>
References: <1450862968-20222-1-git-send-email-ard.biesheuvel@linaro.org> <20160105175114.GG10705@arm.com> <20160106154348.GF16580@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106154348.GF16580-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wednesday 06 January 2016 15:43:49 Will Deacon wrote:
> On Tue, Jan 05, 2016 at 05:51:14PM +0000, Will Deacon wrote:
> > I can take this via the arm64 tree, unless Arnd wants to queue it in
> > arm-soc. Arnd?

arm64 tree is fine with me.
 
> Given that this fixes build errors, I've applied it in the arm64 tree,
> so it should appear in -next soon.
> 

Thanks,

	Arnd
